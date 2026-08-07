---
title: Backups & recovery
description: Keep a copy of your work, and get it back when you need it.
order: 3
---

# Backups & recovery

C5 backs itself up. You should still keep your own copy.

## What C5 does on its own

C5 looks after its own storage:

- **Automatic backups** on a schedule you can change
- **Self-repair** when storage gets damaged
- **Self-recovery** after a crash or a power cut

If your computer loses power mid-task, C5 comes back knowing what it was doing and picks
up from there. You do not lose your place.

## Why you still need your own copy

C5's backups live in the same folder as your data. That protects you from software
problems. It does **not** protect you from:

- A failed hard drive
- A lost or stolen laptop
- Deleting the folder by accident

For those, you need a copy somewhere else.

## Backing up

Everything is in one folder — by default `~/.growther`. Copy that folder and you have
copied your entire C5.

The simplest approach is to include it in whatever backup you already run. Time Machine,
a cloud backup service, or a copy to an external drive all work.

> **Danger**
> A copy of `~/.growther` contains your encryption key, at
> `config/device-master-key`. That means a backup of the folder is **not** protected
> by C5's encryption — anyone who gets the copy can open it.
>
> Either put the backup somewhere you would be willing to keep unencrypted files, or
> encrypt the backup itself. See [Local encryption](/c5/security/encryption).

Best practice is to back up while C5 is stopped, so nothing is mid-write:

```bash
growther stop
# run your backup
growther
```

A backup taken while C5 is running is usually fine, but stopping first removes all doubt.

## Backup settings

Inside the app you can change:

- **How often** automatic backups run
- **How many** old ones are kept
- **How long** history is kept before old records are trimmed

If disk space is tight, shortening history retention is the biggest lever.

## Restoring

To restore onto the same computer:

1. Stop C5: `growther stop`
2. **Move your current data folder aside — do not delete it:**

   ```bash
   mv ~/.growther ~/.growther.before-restore
   ```

3. Copy your backup into place as `~/.growther`.
4. Start C5: `growther` — and check that your work is actually there.
5. Only once you are satisfied, delete `~/.growther.before-restore`.

> **Danger**
> Do not overwrite your live data folder with a backup you have not opened yet. If the
> backup turns out to be incomplete or corrupted, moving the old folder aside is the
> only thing standing between you and losing both copies.

To move to a new computer:

1. Install C5 — see [Installation](/c5/getting-started/installation).
2. Stop it: `growther stop`
3. Copy your backup into place as the data folder.
4. Start it: `growther`
5. Activate: `growther activate`

Your projects, files, history, and settings come with you.

## Checking your backup works

An untested backup is a guess. Test it by restoring the copy into a spare folder and
starting C5 there:

```bash
mkdir -m 700 -p ~/c5-restore-test
cp -R /path/to/your/backup/. ~/c5-restore-test/
GROWTHER_HOME=~/c5-restore-test growther
```

`GROWTHER_HOME` tells C5 to use that folder instead of your real one, so this cannot
disturb your working setup. Open the app and look for your projects and chats. If they
are there, your backup is good.

Delete the test folder afterwards:

```bash
rm -rf ~/c5-restore-test
```

> **Warning**
> Restore into a folder only you can read — that is what `mkdir -m 700` above is for —
> and put it in your home folder, not in `/tmp`. A restored copy contains your key, and
> `/tmp` is shared with every other user and program on the machine.

> **Note**
> Pointing `GROWTHER_HOME` at an empty folder does not test anything. C5 will simply set
> up a brand-new, empty install there. You have to copy the backup in first.

## If something is badly wrong

Run the checkup first:

```bash
growther doctor
```

It will tell you whether the problem is your install, your license, or your data. See
[Running doctor](/c5/cli/doctor) and
[Common issues](/c5/troubleshooting/common-issues).
