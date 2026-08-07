---
title: What tools do
description: How agents reach outside the chat window to do real work.
order: 1
---

# What tools do

A **tool** is something an agent can use to affect the real world. Without tools, an
agent can only talk. With tools, it can do.

## Examples of tools

- Reading and writing files on your computer
- Searching the web and reading pages
- Running commands
- Talking to other programs you use
- Controlling your screen, keyboard, and mouse

## How an agent uses one

When an agent decides it needs a tool, it says so, uses it, and gets a result back. All
of that shows up in the conversation. You can see:

- Which tool it used
- What it asked for
- What came back

Nothing is hidden. If an agent read a file, you will see which file.

## You decide what is allowed

An agent can only use tools you have allowed. Some are safe and always on. Others ask
you first. Some you may want to switch off entirely.

C5 stops and asks before anything risky — deleting things, spending money, sending data
off your computer. You get a clear message describing exactly what it wants to do.

This is covered fully in [Permissions](/c5/security/permissions).

## Built-in safety

Beyond asking you, C5 has guards that work on their own:

- **A tool that keeps failing gets switched off** for a while, instead of retrying
  forever. This stops one broken thing from burning your budget.
- **Information leaving your computer is checked** so sensitive data does not go out by
  accident.
- **Everything is recorded**, so you can look back at what happened.

## Adding more tools

Two ways:

- **Integrations** connect C5 to services you already use. See
  [Integrations](/c5/tools/integrations).
- **MCP servers** are a standard way to add new abilities. See
  [MCP servers](/c5/tools/mcp-servers).

## Seeing which tools get used

The **Tools** view in [Analytics](/c5/using-c5/analytics) shows which tools your agents
reach for most, and which ones fail. A tool that fails often is usually misconfigured
rather than broken.

## Where to go next

- [Permissions](/c5/security/permissions) — set the rules.
- [MCP servers](/c5/tools/mcp-servers) — add new abilities.
- [Computer use](/c5/tools/computer-use) — let an agent drive your screen.
