1. `$prePhases`

2. `unpackPhase`
	* Extract source code

3. `patchPhase`
	- apply patches and modify source

4. `$preConfigurePhases`

5. `configurePhase`
	- prepare the build config

6. `$preBuildPhases`

7. `buildPhase`
	- compile the software

8. `checkPhase`
	- run tests if enabled

9. `$preInstallPhases`

10. `installPhase`
	- install files into `$out`

11. `fixupPhase`
	- perform final cleanup and adjustments

12. `installCheckPhase`
	- test installed files; if enabled

13. `$preDistPhases`

14. `distPhase`

15. `$postPhases`

Reference: [Nixpkgs Standard Environment Phases](https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases)

Note: `$prePhases`, `$preConfigurePhases`, `$preBuildPhases`, `$preInstallPhases`, `$preDistPhases`, and `$postPhases` are variables containing additional phases, not individual phases themselves.

```nix
stdenv.mkDerivation {
  pname = "hello";
  version = "1.0";
  src = ./.;

  prePhases = [ "myCustomPhase" ];

  myCustomPhase = ''
    echo "This runs before unpackPhase"
  '';
}
```

When overriding a phase, for example installPhase, it is important to start with runHook preInstall and end it with runHook postInstall, otherwise preInstall and postInstall will not be run.
