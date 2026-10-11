```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  src = fetchurl {
    url = "http://example.org/libfoo-1.2.3.tar.bz2";
    hash = "sha256-tWxU/LANbQE32my+9AXyt3nCT7NBVfJ45CX757EMT3Q=";
  };
}
```

You only need a `name` and a `src`.

Alternative `name` can be formed from `pname` and `version`.

## `rec` vs `finalAttrs`

`rec` lets attributes reference other attributes in the same original definition.

`finalAttrs` lets attributes reference the final values of other attributes, including changes made through `overrideAttrs`.

```nix 
stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  version = "1.0";

  withFeature = true;

  configureFlags =
    lib.optionals finalAttrs.withFeature [
      "--with-feature"
    ];
})
```

`finalAttrs` here is the argument of a function. The function accepts one argument and returns an attribute set. Its not a special keyword either.

It basically evaluates to something like:

```nix
finalAttrs = {
  pname = "hello";
  version = "1.0";
  withFeature = true;

  configureFlags =
    lib.optionals finalAttrs.withFeature [
      "--with-feature"
    ];
};
```

### overrideAttrs

`overrideAttrs` is a function exposed by packages created with mkDerivation.

### patchelf

ELF is a Executable and Linkable Format

Standard binary format used for executables, shared libraries and object files.

A dynamically linked ELF executable typically contains the path to the dynamic linker that Linux should use to run it.

Command	Purpose

```
--print-interpreter: Display the dynamic linker path
--set-interpreter: Change the dynamic linker path
--print-rpath: Display the library search path
--set-rpath: Change the library search path
--print-needed: List required shared libraries
--replace-needed: Change a shared-library dependency
```

RPATH is the directory apth stored inside an ELF binary that tells the dynamic linker where to look for shared libraries at runtime.

RUNPATH applies to the executables direct dependencies. RPATH can also influence the search for dependencies further down the dependency tree.

* PT_INTERP — Which dynamic linker should execute this program?

* DT_NEEDED — Which shared libraries does this program require?

* RPATH / RUNPATH — Where should the dynamic linker search for those libraries?
