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
The Budget tab is also where you track progress toward self-improvement milestones like
the Retrospective Loop (50 tasks) and Reward Model Promotion (100 tasks).
See [Budgets & costs](/c5/using-c5/ops).

### Autonomy

Decide how much your agents may do on their own. Start cautious. As you learn what C5
does well, loosen it.

See [Permissions](/c5/security/permissions).

### Guardrails

Set boundaries on what your agents may do, where they can connect on the web, and what data gets redacted before leaving your computer.
See [Guardrails](/c5/security/guardrails).

### Locations

Tell C5 which folders to bring documents in from, and where to put finished work. Point
it at the folders you actually work in, so imports and deliverables land somewhere you
expect.

> **Warning**
> This is a convenience setting, not a security boundary. It does not stop an agent from
> reaching other parts of your disk. Use
> [Permissions](/c5/security/permissions) and [Guardrails](/c5/security/guardrails) for that.

## How long C5 keeps things

**Storage** is where you decide how much history to hold. Two of the sliders there are worth
understanding, because they control records you may need after the fact.

| Slider                      | Range       | Default |
| --------------------------- | ----------- | ------- |
| **Audit Trail Retention**   | 1–365 days  | 90 days |
| **System Events Retention** | 31–365 days | 90 days |

**Audit Trail Retention** covers the security record of who did what: sign-ins and account
changes, admin actions, attempts C5 blocked, and changes to encryption. C5 removes it a whole
day at a time, and only once the last entry from that day has aged out, so nothing inside your
window is ever cut short. See [Audit trail](/c5/security/audit-trail).

This slider also covers the **tool decisions** in the same view — each time an agent was allowed
or refused a tool. Those are tidied on the same nightly pass, but with one difference worth
knowing:

> **Note**
> **Tool decisions are never removed sooner than 90 days**, whatever this slider says. They are
> also what the Analytics tool charts count, and those charts can look back up to 90 days — so if
> a shorter setting were applied to them, a chart would quietly show less activity than really
> happened and give you an all-clear nobody measured. Setting this above 90 days keeps them for
> longer, in step with everything else; setting it below only shortens how long the audit records
> themselves are kept.

One thing in the Audit view is still not covered: the **system notifications** merged into the
same list have no retention setting, and nothing ages them out. The **Source** column is what tells
the three kinds of row apart.

**System Events Retention** covers C5's own operational record: coordinator failovers, gateway
timeouts, shutdowns, steps that had to be abandoned and requeued, and the adjustments C5 makes
to its own thresholds and prompts as it learns. This is what the Monitor screens read when they
tell you how the platform itself has been behaving.

> **Warning**
> System Events cannot be set below **31 days**. The Monitor failover card counts events over
> a fixed 30-day window, so a shorter retention would delete events that card is still trying
> to count — and it would report fewer problems than actually happened. An all-clear nobody
> measured is worse than no number at all, so the floor is enforced.

Both are cleared out once a day, late in the evening, a few minutes ahead of the nightly
database backup — so your backups hold the tidied-up version rather than a copy of what you
asked to delete. They tidy differently: the audit records go a whole day at a time, for the
reason described on the [Audit trail](/c5/security/audit-trail) page, while tool decisions and
system events are removed one at a time as each passes its cutoff.

If C5 is asleep or switched off at that moment, nothing is lost. The next night removes
everything that was due tonight as well.

If you need records for longer than you want to store them, export them instead of raising the
slider — see [Audit trail](/c5/security/audit-trail).

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

If you are not sure what you changed, the **Audit** view in [Ops](/c5/using-c5/ops) covers
some of it: changes to what tools an agent may use, and to search providers and integrations,
are recorded there with a timestamp. An ordinary **Save** on the other settings areas is not
recorded there — so when a setting matters, note what it was before you change it.

If C5 will not start at all after a change, see
[Common issues](/c5/troubleshooting/common-issues).

## Where to go next

- [Config files](/c5/configuration/config-files) — how C5 manages `c5.yaml` on disk.
- [Model providers](/c5/configuration/model-providers) — connect cloud and local models.
- [Guardrails](/c5/security/guardrails) — safety limits and network allowlists.

