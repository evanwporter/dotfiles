Overlay is a function that modifies or extends the Nixpkgs package set.

```nix
final: prev: {
  # Your modifications
}
```

These arguments mean:

**Final:** The final package set, including modifications from the overlay

**Prev:** The package set as it existed before the current overlay

You can do this manually:

```nix
let
  original = {
    a = 1;
    b = 2;
  };

  overlay = final: prev: {
    a = prev.a + 10;
    c = final.a + 5;
  };

  final = original // (overlay final original);
in
  final
```

## override vs overrideAttrs
`override` changes the arguments passed to a package function.

`overrideAttrs` changes the attributes passed to the derivation builder.

Rule of thumb: Use `override` to change what goes into the package function, and `overrideAttrs` to change how the derivation is built.

### Sources

https://nixcademy.com/posts/mastering-nixpkgs-overlays-techniques-and-best-practice/
