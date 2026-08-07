---
title: Running doctor
description: Have C5 check its own setup and tell you what is wrong.
order: 3
---

# Running doctor

`growther doctor` checks your setup and reports anything wrong, in plain words. It is
the first thing to try when something is not working.

```bash
growther doctor
```

It only reads and checks. It does not change anything.

## What it checks

These are the exact checks it runs:

| Check                  | What it is looking for                                  |
| ---------------------- | -------------------------------------------------------- |
| **Data home**          | Your data folder exists and can be written to.           |
| **Install**            | The program is where it should be.                       |
| **License**            | This computer is activated.                              |
| **Build manifest**     | The record of how this build was made is present.        |
| **Manifest signature** | That record really was signed by Growther.ai.            |
| **Binary integrity**   | The program file matches what was installed.             |
| **SOC2 change-mgmt**   | The change-control checks used for compliance.            |
| **Databases**          | Your data files are present where they should be.        |
| **Mothership**         | C5 can reach the cloud service, if you use it.           |

> **Note**
> Doctor does **not** test your model providers or your integrations. Those are checked
> when you save them in Settings, which is also where a bad key is reported. See
> [Model providers](/c5/configuration/model-providers).

## Reading the output

Each check gets a clear result:

- **OK** — nothing to do.
- **Warning** — works, but something is not ideal.
- **Failed** — this is broken, and doctor tells you how to fix it.

Work top to bottom. An early failure often causes the ones below it, so fixing the first
problem sometimes clears several at once.

## Common findings

**"Install" failed**
C5 is not where it expects to be. Reinstall — see
[Installation](/c5/getting-started/installation). If your terminal simply cannot find the
`growther` command, close the terminal window and open a new one first; shells only pick
up PATH changes in new sessions.

**"Not activated"**
Run `growther activate` to pair this computer with your license.

**"Database check failed"**
Your stored data could not be opened. C5 repairs itself where it can — see
[Backups and recovery](/c5/security/backups) if it cannot.

**"Cannot reach the update service"**
Usually a network or firewall issue. C5 keeps working offline; you just will not get
updates until it can connect.

**"Integrity check failed"**
The program file does not match what was published.

> **Danger**
> Do not ignore an integrity failure. It means the program on disk is not the one
> Growther.ai signed. Reinstall from the official installer, and see
> [Verifying releases](/c5/security/verifying-releases).

## When you ask for help

Run doctor first and include its output. It answers most of the questions a support
person would otherwise have to ask you.

See [Getting help](/c5/troubleshooting/getting-help).
