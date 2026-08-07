---
title: Settings
description: A map of every settings area and what it controls.
order: 1
---

# Settings

Settings is where you tell C5 how to behave. This page is a map, so you know which area
you want.

You do not need to change most of these. C5 works sensibly out of the box.

## The areas

| Area              | What it controls                                             |
| ----------------- | ------------------------------------------------------------- |
| **General**       | Basic behavior and appearance.                                |
| **LLMs**          | Which AI models you use and their keys.                       |
| **Autonomy**      | How much your agents may do without asking you.               |
| **Guardrails**    | Hard limits agents cannot cross.                              |
| **Budget**        | Spending caps and warnings.                                   |
| **Tools**         | Which tools exist and how each one is allowed to be used.     |
| **Tool Health**   | Whether each tool is working, and what has been failing.      |
| **Extensions**    | Optional capabilities, each switchable on, prompt, or off.    |
| **Integrations**  | Connections to other services and MCP servers.                |
| **Access**        | Who can use this C5 and what they may do.                     |
| **Alerts**        | When and how C5 tells you something happened.                 |
| **Communications**| How C5 reaches you — email and other channels.                |
| **Learning**      | How much C5 adapts from your usage.                           |
| **Locations**     | Folders C5 brings documents in from and writes results into.  |
| **Storage**       | Your data, its encryption, and export.                        |
| **System**        | Ports, paths, and how C5 runs on this machine.                |

## The ones worth setting early

### LLMs

You have to set this up before anything works. Add at least one model and its key. See
[Model providers](/c5/configuration/model-providers).

### Budget

Set a spending limit on your first day. It is the cheapest mistake-insurance available.
See [Budgets](/c5/using-c5/ops).

### Autonomy

Decide how much your agents may do on their own. Start cautious. As you learn what C5
does well, loosen it.

See [Permissions](/c5/security/permissions).

### Locations

Tell C5 which folders to bring documents in from, and where to put finished work. Point
it at the folders you actually work in, so imports and deliverables land somewhere you
expect.

> **Warning**
> This is a convenience setting, not a security boundary. It does not stop an agent from
> reaching other parts of your disk. Use
> [Permissions](/c5/security/permissions) and Guardrails for that.

## Alerts

Alerts tell you when something needs you. Worth turning on:

- A task is blocked and waiting for your answer
- A schedule failed
- You are close to a spending limit
- Something was blocked for security reasons

Without alerts you will find out when you next open C5, which might be tomorrow.

## Saving changes

Changes save when you click **Save** and apply to new work right away. Work already
running finishes under the settings it started with, so nothing shifts mid-task.

## If you break something

Settings are just values you can change back. Note what you changed, set it to what it
was, and save.

If you are not sure what you changed, the **Audit** view in [Ops](/c5/using-c5/ops)
records configuration changes with a timestamp.

If C5 will not start at all after a change, see
[Common issues](/c5/troubleshooting/common-issues).
