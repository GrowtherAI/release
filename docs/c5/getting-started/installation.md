---
title: Installation
description: Install Growther.ai C5 on macOS, Linux, or Windows.
order: 2
---

# Installation

C5 is a single program file. Pick the way you like to install it below.

> **Note**
> You do not need Node, Docker, or any other tool installed first. C5 brings
> everything it needs with it.

## macOS and Linux

Open your terminal and run:

```bash
curl -fsSL https://growther.ai/install.sh | bash
```

## Windows

Open PowerShell and run:

```powershell
irm https://growther.ai/install.ps1 | iex
```

## Homebrew (macOS and Linux)

If you already use Homebrew, you can install C5 this way instead:

```bash
brew install growther/tap/growther-c5
```

## What the installer does

The installer takes care of a few things for you:

1. It looks at your computer and picks the right version of C5.
2. It downloads that version.
3. It checks the download against a known fingerprint, called a **SHA‑256**. If even one
   byte is wrong, the install stops. This makes sure you got the real file.
4. It puts the `growther` command on your PATH, so you can run it from any folder.
5. It creates your data folder at `~/.growther`.

## Check that it worked

Run this to see the help screen:

```bash
growther --help
```

If you see a list of commands, C5 is installed.

Now turn it on and set it up for the first time:

```bash
growther activate
```

This pairs your computer with your license. C5 will show you a code and open a page
where you confirm it. This only happens once per computer.

You need a license first — get one from [growther.ai](https://growther.ai). If you do not
have one yet, do that before running this step.

## Start C5

Run the command by itself to start C5:

```bash
growther
```

C5 starts and prints the address it is running on:

```text
C5 API running on http://localhost:4299
```

Open that address in your browser to use the app.

> **Tip**
> Want a different port? Set the `PORT` value before you start:
> `PORT=5000 growther`

## Supported platforms

| System  | Chips supported            |
| ------- | -------------------------- |
| macOS   | Apple Silicon and Intel    |
| Windows | x86_64 and ARM64           |
| Linux   | x86_64                     |

## If the command is not found

If your terminal says `growther: command not found`, your shell probably has not picked
up the new PATH yet. Close the terminal window and open a new one, then try again.

Still stuck? Run the built-in checkup:

```bash
growther doctor
```

It looks at your install, your license, and your files, and tells you what is wrong.
See [Common issues](/c5/troubleshooting/common-issues) for more help.

## Next steps

- [Quickstart](/c5/getting-started/quickstart) — run your first task.
- [Updating C5](/c5/getting-started/updating) — keep C5 current.
