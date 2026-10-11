Hooks are shells code that run automatically at specific points during the build process

1) Phase Hooks: Run before or after a build phase

```nix
stdenv.mkDerivation {
  pname = "hello";
  version = "1.0";
  src = ./.;

  preBuild = ''
    echo "About to compile!"
  '';

  postBuild = ''
    echo "Compilation finished!"
  '';
}
```

`preBuild` and `postBuild` are hooks that are attached before and after the build phase

2) Package Setup Hooks: scripts supplied by dependencies which nix automatically sources that configure and modify the build env

See https://nixos.org/manual/nixpkgs/stable/#chap-hooks

