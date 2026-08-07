---
title: The growther command
description: Every C5 command, what it does, and when to use it.
order: 1
---

# The growther command

C5 installs one command: `growther`. This page lists everything it can do.

To see this list in your terminal at any time:

```bash
growther help
```

## Start C5

Run the command with nothing after it:

```bash
growther
```

This starts the C5 server and prints the address it is running on — open that address in
your browser to use the app. The first time you run it, C5 sets itself up and asks you to
activate.

## All commands

| Command             | What it does                                                   |
| ------------------- | -------------------------------------------------------------- |
| `growther`          | Start C5. First run sets itself up.                             |
| `growther stop`     | Stop C5 gently, letting it finish what it is doing.             |
| `growther status`   | Say whether C5 is running, and how it is set to start.          |
| `growther service`  | Manage starting C5 automatically. See below.                    |
| `growther activate` | Pair this computer with your license.                           |
| `growther update`   | Get the newest version.                                         |
| `growther rollback` | Go back to the version you had before.                          |
| `growther doctor`   | Check your setup and report anything wrong.                     |
| `growther uninstall`| Remove C5 from your computer.                                   |
| `growther version`  | Print which version you have.                                   |
| `growther help`     | Show the list of commands.                                      |

## Commands in detail

### `growther status`

Tells you whether C5 is running right now, and whether it is set to start on its own
when your computer boots.

```bash
growther status
```

### `growther service`

Controls whether C5 starts by itself and stays running.

```bash
growther service install     # start C5 automatically from now on
growther service status      # check whether that is set up
growther service uninstall   # stop starting automatically
```

Use `install` if you want C5 always ready. Use `uninstall` to go back to starting it
by hand.

### `growther activate`

Pairs your computer with your license. C5 shows you a short code and opens a page
where you confirm it. You only do this once per computer.

```bash
growther activate
```

### `growther update`

Gets the newest version. See [Updating C5](/c5/getting-started/updating) for the
full story.

```bash
growther update            # update now
growther update --check    # only check, do not install
growther update --restart  # update, then restart the service
```

### `growther doctor`

Checks your whole setup and tells you what is wrong in plain words. This is the first
thing to run when something is not working.

```bash
growther doctor
```

See [Running doctor](/c5/cli/doctor) for what it checks.

### `growther uninstall`

Removes the C5 program, takes it off your PATH, and turns off automatic starting.

```bash
growther uninstall
```

**Your data is kept.** Everything in your data folder stays where it is, so you can
reinstall later and pick up where you left off.

> **Danger**
> To delete your data too, add `--purge-data`. This erases everything C5 has stored —
> your chats, tasks, files, and settings. It cannot be undone.

```bash
growther uninstall --purge-data
```

## Getting the version

```bash
growther version
```

Useful when reporting a problem — see [Getting help](/c5/troubleshooting/getting-help).

## Next steps

- [Environment variables](/c5/cli/environment) — change ports, folders, and channels.
- [Running doctor](/c5/cli/doctor) — check your setup.
