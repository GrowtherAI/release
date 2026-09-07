---
title: Where your data lives
description: Configuration, databases, keys and caches; how to move C5 to another local disk; why a network folder is refused for databases.
order: 6
---

# Where your data lives

C5 keeps everything on your computer. This page explains what sits where, how to
move it, and what C5 will refuse to do with it.

## The four kinds of files

| Kind             | What it holds                                                                     | Where it may live                                          |
| ---------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| Configuration    | your settings, `config/c5.yaml`, guardrails, the install record                   | your home folder, or a folder your organisation manages    |
| Databases        | tasks, notes, deliverables, runs, telemetry: four encrypted databases              | a local disk on this computer only                         |
| Secrets and keys | the device key that encrypts the databases, the deployment key, your API keys     | this computer only, or your keystore                       |
| Caches           | downloaded models, the memory-search engine, temporary files                      | a local disk; safe to delete, C5 downloads them again      |

By default all four sit under one folder:

```text
~/.growther                      macOS and Linux
%USERPROFILE%\.growther          Windows (configuration)
%LOCALAPPDATA%\Growther\C5       Windows (databases and keys on new installs)
```

New Windows installs keep the databases and keys under `%LOCALAPPDATA%` on purpose: that
folder never travels with a roaming profile, so signing in on another machine cannot
carry an encrypted database away from the key that opens it.

## See it in Settings

Open **Settings › Storage › Configuration & Data**. The card shows:

- **Source**: whether this device chose the location (Local), or your organisation did
  (Managed by your organization).
- **Where things live**: one row per kind of file, with the path, a badge that says
  whether it is on this device, on a network folder, or in a synced folder, and a dot
  that goes amber when something is not where it should be.
- **Actions**: change the local folder, verify the layout, roll back a move, or remove a
  retired copy after a move.

If C5 is running from an older location than the one now configured, a banner says so
until you restart.

## Move C5 to another local disk

Use the card's **Change local folder** button, or the command line:

```bash
growther home migrate --to /Volumes/Work/growther
```

Both run the same procedure:

1. **Validate** the new folder: it must be on a local disk, writable, not inside a
   protected folder, and have room for one and a half times your current data.
2. **Review the plan**: what moves, what stays, and what you can prune (old encrypted
   backup copies can add up to gigabytes).
3. **Confirm**: type `move`. C5 stops, copies everything with a verified checkpoint of
   every database, checks each copy against your key before anything is switched, then
   restarts from the new folder.

The old folder is kept as a retired copy with its secrets shredded, so you can **Roll
back** from the card at any time until you choose **Remove retired copy**.

To see the current layout or check a folder first:

```bash
growther home show
growther home probe /Volumes/Work/growther
```

## What C5 refuses, and why

**Databases are never placed on a network folder, a mapped drive, a roaming profile, or
a synced folder** such as OneDrive, Dropbox or iCloud Drive. C5 checks the filesystem
at every start and refuses to run if the databases are on one of those. The reason is
not caution for its own sake: the database engine keeps part of its state in shared
memory that only one computer can see, so two computers opening the same folder would
corrupt it, and a sync client can copy a half-written file over a good one.

If a configured folder is unreachable when C5 starts, it stops with a message naming
the folder and who set it, rather than silently starting an empty second copy somewhere
else.

**Two computers never share one folder.** The lock C5 takes on the data folder now
records which machine holds it. A second machine pointed at the same folder refuses to
start and tells you which machine has it. If a machine has been rebuilt and a stale lock
is in the way:

```bash
growther lock status
growther lock break --confirm
```

## Backups and network storage

Network storage is welcome for what belongs there: encrypted backups, exported audit
evidence, and the policy file your organisation may publish. Set the backup folder under
**Settings › Storage**, or an Azure Blob or S3 target under **Settings › Enterprise ›
Enterprise storage**.

## Check the layout from the command line

```bash
growther doctor
growther doctor --json
```

The report includes *Home source*, *Data dir filesystem*, *Secrets location* and *Lock
host*. The `--json` form also writes `doctor-status.json` into the C5 folder for device
management tools to read.
