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
| `growther verify`  | Prove a file really came from us. Works offline.                 |
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

### `growther verify`

Checks that a file really is the one we built, and that nobody has changed it since.
Useful if you downloaded C5 somewhere other than our site, or if you simply want to
confirm the copy you are running is untouched.

```bash
growther verify            # check the copy of C5 you are running
growther verify ./growther # check a specific file you downloaded
```

It works **offline**. Nothing is sent anywhere and nothing needs downloading: the key
used to check the signature is built into C5 itself.

What the answers mean:

| You see                         | What it means                                          |
| ------------------------------- | ------------------------------------------------------ |
| ✓ signature is valid            | The record of how this was built really came from us.  |
| ✓ contents match                | The file has not been changed since we built it.       |
| ✗ has been altered              | Do not run it. Download it again from growther.ai.     |
| ✗ signature is INVALID          | Do not run it. Download it again from growther.ai.     |
| ? unsigned / no key / no record | Cannot tell either way — see below.                    |
| ? this is a release archive     | Extract it, then verify the program inside.            |

A **?** is not a pass. It means the check could not be completed — usually because you
are running a development build, because the file has no build record next to it, or
because you pointed it at a downloaded `.tar.gz`/`.zip` rather than the program itself.
Treat it as "unknown", not "fine".

Checking a downloaded archive tells you its build record is genuine but says nothing
about the bytes inside it, so extract it first and verify the program:

```bash
tar -xzf growther-c5-macos-arm64.tar.gz
growther verify ./growther-c5-macos-arm64
```

If you are writing a script, the exit codes are `0` verified, `1` failed or altered, and
`2` could not be checked.

See [Verifying releases](/c5/security/verifying-releases) for the whole trust story.

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
