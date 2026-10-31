#!/usr/bin/env python3

# Loosely based off of
# https://github.com/hlissner/dotfiles/blob/fa72377393680f953fcb9efaa30994ea91eba233/bin/hey

import argparse
import re
import shlex
import shutil
import subprocess
from pathlib import Path

HOME = Path.home()
FLAKE = HOME / "dotfiles/nix"
HOST = "laptop"
TEMPLATES = FLAKE / "modules/programs/util/nx/_templates"
SYSTEM_PROFILE = "/nix/var/nix/profiles/system"

EXTRACT_EXPR = """
sys:
let
  lib = sys.pkgs.lib;
  nixpkgs = toString sys.pkgs.path;

  mine = d: !(lib.hasPrefix nixpkgs d.file);

  defs =
    sys.options.environment.systemPackages.definitionsWithLocations;

  systemPackages =
    lib.concatMap
      (d: d.value)
      (lib.filter mine defs);

  userPackages =
    lib.concatLists
      (lib.mapAttrsToList
        (_: user: user.packages or [])
        sys.config.users.users);

  name = p:
    p.pname or (lib.getName p);

in
  lib.listToAttrs (
    map
      (p: lib.nameValuePair
        (name p)
        (p.version or ""))
      (systemPackages ++ userPackages)
  )
"""


def run(*args, capture=False, cwd=None):
    result = subprocess.run(
        args,
        cwd=cwd,
        text=True,
        check=True,
        stdout=subprocess.PIPE if capture else None,
    )
    return result.stdout if capture else None


def update(args):
    run(
        "nix-shell",
        "maintainers/scripts/update.nix",
        "--argstr",
        "package",
        args.package,
        cwd=HOME / "nixpkgs",
    )


def pull(args):
    run("nix", "flake", "update", "--flake", str(FLAKE))


def test(args):
    run(
        "sudo",
        "nixos-rebuild",
        "test",
        "--flake",
        f"{FLAKE}#{HOST}",
        "--impure",
    )


def switch(args):
    run(
        "sudo",
        "nixos-rebuild",
        "switch",
        "--flake",
        f"{FLAKE}#{HOST}",
        "--impure",
    )


def ensure_line(path, line):
    if not path.exists():
        path.write_text(f"{line}\n")
        print(f"Created {path.name}")
        return

    content = path.read_text()

    if line not in content.splitlines():
        with path.open("a") as file:
            if content and not content.endswith("\n"):
                file.write("\n")
            file.write(f"{line}\n")

        print(f"Updated {path.name}")


def init(args):
    if args.language is None:
        print("Available languages:")
        for path in sorted(TEMPLATES.iterdir()):
            if path.is_dir():
                print(f"  {path.name}")
        return

    source = TEMPLATES / args.language / "flake.nix"
    destination = Path.cwd() / "flake.nix"

    if not source.is_file():
        raise ValueError(f"Unknown language: {args.language}")

    if destination.exists() or destination.is_symlink():
        raise FileExistsError("flake.nix already exists")

    shutil.copyfile(source, destination)
    print("Created flake.nix")

    ensure_line(Path(".envrc"), "use flake")
    ensure_line(Path(".gitignore"), ".direnv/")

    print(f"\nInitialized {args.language} development environment.")
    print("Run 'direnv allow' to activate.")


def review(args):
    print(f"Looking up nixpkgs PR #{args.pr}...", flush=True)

    title = run(
        "gh",
        "pr",
        "view",
        str(args.pr),
        "--repo",
        "NixOS/nixpkgs",
        "--json",
        "title",
        "--jq",
        ".title",
        capture=True,
    ).strip()

    print(f"PR: {title}")

    match = re.match(r"^([^:\s]+):", title)

    if not match:
        raise ValueError(f"Cannot determine package from PR title: {title}")

    package = match.group(1)
    print(f"Detected package: {package}")

    run(
        "gh",
        "workflow",
        "run",
        "review.yml",
        "--repo",
        "evanwporter/nixpkgs-review-gha",
        "-f",
        f"pr={args.pr}",
        "-f",
        f"extra-args=-p {package}",
    )

    print("Review submitted.")


def shell(args):
    argv = args.arguments

    if "--" in argv:
        index = argv.index("--")
        packages = argv[:index]
        command = argv[index + 1 :]
    else:
        packages = argv
        command = None

    if not packages:
        raise ValueError("Usage: nx shell <package...> [-- command...]")

    if command is None:
        run("nix-shell", "-p", *packages)
        return

    if not command:
        command = [packages[0]]

    run(
        "nix-shell",
        "-p",
        *packages,
        "--run",
        shlex.join(command),
    )


def evaluate(args):
    run(
        "nix",
        "eval",
        "--raw",
        f"{FLAKE}#nixosConfigurations.{HOST}.config.system.build.toplevel.drvPath",
        "--impure",
    )


def main():
    parser = argparse.ArgumentParser(
        prog="nx",
        description="A tool for managing my NixFig.",
    )

    subparsers = parser.add_subparsers(
        dest="command",
        required=True,
    )

    def command(name, help, handler):
        sub = subparsers.add_parser(name, help=help)
        sub.set_defaults(handler=handler)
        return sub

    command("update", "Update a nixpkgs package", update).add_argument("package")

    command("pull", "Update flake inputs", pull)
    command("test", "Temporarily activate NixOS configuration", test)
    command("switch", "Rebuild and switch NixOS configuration", switch)

    command("init", "Initialize a development environment", init).add_argument(
        "language", nargs="?"
    )

    command("review", "Run nixpkgs-review GitHub Action", review).add_argument(
        "pr", type=int
    )

    command("eval", "Evaluate NixOS configuration without building", evaluate)

    command("shell", "Run a temporary shell with packages", shell).add_argument(
        "arguments", nargs=argparse.REMAINDER
    )

    args = parser.parse_args()

    try:
        args.handler(args)
    except (subprocess.CalledProcessError, OSError, ValueError) as error:
        parser.exit(1, f"nx: {error}\n")


if __name__ == "__main__":
    main()
