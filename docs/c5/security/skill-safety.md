---
title: Skill safety
description: How skills are checked before your agents can use them.
order: 6
---

# Skill safety

A skill is instructions your agents follow. That makes skills powerful, and it makes an
unsafe one worth taking seriously: an agent reading a bad instruction will simply do what
it says. This page explains what C5 checks, and what it does not.

## The risk that matters most

The obvious worry is a skill that contains something harmful. The subtler and more
important one is a skill whose contents can change **after** you have looked at it.

A skill that fetches its own instructions from a web address at the moment it runs has
this problem. It can be read, approved, and installed while it is perfectly reasonable —
and then say something different tomorrow, because whoever owns that address changed the
file. The version you reviewed and the version your agent follows are not the same thing.

C5 treats that as the line. Skills ship with their contents included, not fetched later.

## What is checked

Every skill is scanned before it can be used. The scanner looks for:

- Instructions that download and run code
- Skills that rewrite their own instructions from a remote source
- Credentials being read and sent somewhere
- Commands hidden by encoding or obfuscation
- Installs that resolve to "whatever is newest" instead of a fixed version
- Anything that quietly survives a restart

A skill with a serious finding is **switched off automatically**. It does not wait for
someone to notice.

## Checked contents, not just a checked name

When a skill is approved, C5 records a fingerprint of its actual files. Two things follow.

Change any file in an approved skill and the fingerprint no longer matches, so the skill
returns to the queue and is checked again. Approval is tied to the exact contents that
were approved, not to the skill's name.

The same fingerprint is what lets C5 tell you a skill has been altered on disk since it
was installed.

## What ships with C5

The skills included with C5 are reviewed as a set, not accepted individually. The library
was deliberately reduced: skills that pulled their content from third-party addresses,
installed software at unpinned versions, or updated themselves on a schedule were removed
rather than patched.

Every included skill is scanned and approved before release, and the release build fails
if the shipped skill list, its database records, and the files on disk disagree with each
other. A removed skill cannot quietly return in a later build.

## What this does not do

Being honest about the limits matters more than the reassurance.

Scanning finds known-unsafe patterns. It is not proof a skill is good, and it cannot tell
whether a skill's advice is correct for your work. A skill can pass every check and still
be a bad idea for you.

Skills you write or import yourself go through the same scanner, but you are the reviewer.
If you add a skill that tells an agent to do something unwise, C5 will let you.

The strongest control is still [Permissions](/c5/security/permissions): actions that
matter can require your approval, whatever a skill says.

## What you can do

- Look at what a skill actually says before switching it on. They are written in plain
  language on purpose.
- Be wary of any skill that wants to fetch instructions or install software while running.
- Keep skills you are not using switched off. An agent only reads the ones that are on.
- If a skill was switched off automatically, that is the scanner telling you something.
  Read the finding before turning it back on.
