# Pi configuration

`agent/settings.json` is the portable Pi configuration. Package sources are pinned to exact npm versions or a Git commit, so Pi can restore the same extensions and theme package without committing credentials, sessions, caches, or installed `node_modules`.

After this directory is linked to `~/.pi`, install/reconcile the configured packages with:

```bash
pi update --extensions
```

The selected theme is `ansi-dark`, supplied by the pinned `pi-ansi-themes` package.
