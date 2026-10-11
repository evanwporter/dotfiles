
### `//`

`//` is the attribute set merge operator. if both sets have the same attribute, then the value on the right takes precendence.

In:

```nix 
{ a = 1; b = 2; } // { c = 3; }
```

Out:

```nix 
{
  a = 1;
  b = 2;
  c = 3;
}
```

### Functions

Functions take 1 argument and return an expression.


| Syntax                | Meaning                                           |
| --------------------- | ------------------------------------------------- |
| `x: x + 1`            | Function taking one argument                      |
| `f 5`                 | Call function `f` with `5`                        |
| `x: y: x + y`         | Function taking two arguments through currying    |
| `f 3 4`               | Apply `f` to `3`, then to `4`                     |
| `{ x, y }: x + y`     | Function taking an attribute set with `x` and `y` |
| `{ x, y, ... }: ...`  | Accept additional attributes                      |
| `{ x ? 10 }: x`       | Attribute argument with a default                 |
| `finalAttrs: { ... }` | Function returning an attribute set               |


### Expression

A expression is a piece of code that evaluates to a value

## @

```nix
args@{ x, y, ... }: x + y
```

Here, args receives the entire attribute set, while x and y are extracted individually.

For example:

```nix
let
  example = args@{ x, y, ... }: {
    sum = x + y;
    original = args;
  };
in
example {
  x = 5;
  y = 10;
  z = 20;
}
```

## ...

`...` inside a functions argument set allows it to accept addition attributes even if they aren't listed.

So `...` lets extra attributes through while `@` lets you access the complete set containing those attributes.


## Importing a Nix File

A nix file contains one expression.

Using `import` can be thought of as subtituting the imported file for the value.

Suppose values.nix contains:

```nix
{
  x = 5;
  y = 10;
}
```

And default.nix contains:

```nix
let
  values = import ./values.nix;
in
values.x + values.y
```

You can conceptually think of it as:

```nix
let
  values = {
    x = 5;
    y = 10;
  };
in
values.x + values.y
```

## Inherit

Inherit is shorthand for assigning an existing variable to an attribute with the same name.

```nix
let
  x = 10;
  y = 20;
in {
  x = x;
  y = y;
}
```

```nix
let
  x = 10;
  y = 20;
in {
  inherit x y;
}
```

## Nix `${XXX}`

| Syntax       | Meaning                                           | Language    |
| ------------ | ------------------------------------------------- | ----------- |
| `${xxx}`     | Interpolate a Nix expression                      | Nix strings |
| `foo.${xxx}` | Dynamically select an attribute name              | Nix         |
| `$xxx`       | Expand a shell variable                           | Bash        |
| `${xxx}`     | Expand a shell variable                           | Bash        |
| `$(xxx)`     | Execute a shell command and substitute its output | Bash        |


# builtins

https://nix.dev/manual/nix/2.25/language/builtins

## builtin.mapAttrs

`builtins.mapAttrs` applies a function to every attribute in an attribute set, producing a new attribute set with the same keys but transformed values.

```nix
builtins.mapAttrs (name: value: expression) attrSet
```

## lib.filterAttrs

```nix
filterAttrs :: (String -> Any -> Bool) -> AttrSet -> AttrSet
```

### Parameters
• pred: A function taking two arguments—the attribute name (String) and the attribute value (Any)—and returning a boolean (Bool). If it returns true, the attribute is kept; if false, it is removed.
• set: The input attribute set you want to filter.

## if statements

if condition then value1 else value2

