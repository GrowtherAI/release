---
title: Environment variables
description: Change where C5 stores data, which port it uses, and which releases it gets.
order: 2
---

# Environment variables

Environment variables let you change how C5 behaves without editing any files. You set
them before the command, like this:

```bash
PORT=5000 growther
```

Or you can set them for your whole terminal session:

```bash
export PORT=5000
growther
```

## The variables

| Variable                   | What it does                                    | Default                  |
| -------------------------- | ----------------------------------------------- | ------------------------ |
| `GROWTHER_HOME`            | Where C5 keeps all your data.                    | `~/.growther`            |
| `GROWTHER_DATA_DIR`        | Where the databases live. Must be a local disk.  | `<home>/data`            |
| `GROWTHER_SECRETS_DIR`     | Where the device key set lives. Local only.       | `<home>/config`          |
| `GROWTHER_CACHE_DIR`       | Where downloaded models and caches live.         | `<home>`                 |
| `PORT`                     | Which port the C5 server listens on.             | `4299`                   |
| `GROWTHER_CHANNEL`         | Which releases you get: stable, beta, or dev.    | `stable`                 |
| `GROWTHER_NO_SELF_INSTALL` | Set to `1` to run the program where it sits.     | off                      |
| `GROWTHER_NO_MODIFY_PATH`  | Set to `1` so C5 never edits your shell files.   | off                      |

## Common things people do

### Use a different port

If something else on your computer already uses port 4299:

```bash
PORT=5000 growther
```

### Keep your data somewhere else

Handy if you want your C5 data on an external drive, or you want two separate setups
that do not share anything:

```bash
GROWTHER_HOME=/Volumes/Work/growther growther
```

> **Warning**
> Each data folder is its own separate world. Chats, tasks, and settings in one folder
> are not visible from another.

### Try early versions

```bash
GROWTHER_CHANNEL=beta growther update
```

Switch back with `GROWTHER_CHANNEL=stable growther update`.

### Keep C5 out of your shell files

Some people manage their PATH by hand and do not want any program editing their shell
setup:

```bash
GROWTHER_NO_MODIFY_PATH=1 growther
```

You will then need to add C5 to your PATH yourself.

## What is in your data folder

Everything C5 knows lives in `GROWTHER_HOME` (by default `~/.growther`):

- Your chats, tasks, and their whole history
- Files your agents made
- Your settings and API keys — see [Config files](/c5/configuration/config-files)
- Backups

The databases are encrypted, and on macOS and Linux the key file lives in this same folder
— so a copy of the folder is a copy of everything, key included. See
[Local encryption](/c5/security/encryption) before you back it up anywhere shared.

**On Windows it is two folders.** Every install created since C5 2026.9 keeps configuration
under `%USERPROFILE%\.growther` and puts the databases and keys under
`%LOCALAPPDATA%\Growther\C5`, because `%LOCALAPPDATA%` does not travel with a roaming
profile — an encrypted database must never be carried to a machine without its key.

Run `growther home show` to see every path your install actually uses, and back up all of
them. See [Where your data lives](/c5/configuration/data-location) for the full layout.

## Locations are decided once

`GROWTHER_HOME` and the three folders above are read when C5 starts and never change
while it runs. On a managed device an organisation policy wins over the environment;
otherwise the environment wins over the pointer file C5 writes when you move the home
from Settings. A service unit registered by an older version may still carry an old
`GROWTHER_HOME`; C5 prefers the pointer in that case and rewrites the unit at the next
start.

Databases are refused on a network folder, a mapped drive, a roaming profile or a synced
folder. `GROWTHER_ALLOW_REMOTE_DATA=1` lifts that only in development builds, never in a
released binary.
