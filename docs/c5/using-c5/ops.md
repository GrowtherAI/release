---
title: Budgets & costs
description: Set spending limits and see exactly where your money goes.
order: 6
---

# Budgets & costs

**Ops** is where you keep an eye on the money. It answers one question: what is this
costing me, and where is it going?

## Why budgets matter

Agents use AI models, and most models cost money per use. An agent working on a big job
can make many calls. Without a limit, a runaway task could spend more than you meant to.

Budgets stop that. You set a ceiling, and C5 will not go past it.

## Setting a budget

1. Go to **Ops**.
2. Open the **Budget** tab.
3. Set a limit for the day, the week, or the month.
4. Save.

You can set limits for the whole system, or for one project.

### The voice budget is separate, and lives elsewhere

Speech has its own limit, in the **Voice Spending Limit** panel under **Settings → Budget** —
not on this page. It is separate on purpose: voice is charged by the minute of audio and by the
character of speech read aloud, which is a different shape of spending from the work your agents
do, and most people want a much smaller ceiling on it.

It works the same way as the main cap — a switch, an amount, and a choice of daily, weekly,
monthly or yearly, resetting on the day you pick. C5 works out what a request will cost *before*
making it and refuses rather than overshooting.

Two things never count against it:

- **The built-in on-device engine is free**, so it keeps working even when the voice budget is
  spent. If you want dictation that cannot be interrupted by a limit, put that provider first.
- **Silence is never sent.** A recording with nothing in it is discarded in the browser and
  costs nothing.

See [Voice](/c5/using-c5/voice) for the providers themselves.

## What happens at the limit

C5 does not just stop dead. As you get close, it warns you. At the limit, it pauses new
work and tells you clearly what happened.

Nothing is lost. Paused work waits. Raise the limit or wait for the next period, and it
picks up again.

> **Tip**
> Set your first budget low — lower than you think you need. It is easy to raise later,
> and a low ceiling teaches you what things actually cost.

## Seeing where money went

The Ops charts break spending down by:

- **Time** — today, this week, this month
- **Task** — which jobs cost the most
- **Model** — which AI models you are paying for

If a number looks wrong, click into it. You can follow the cost all the way down to the
task that caused it.

## Other things in Ops

| Tab          | What it is for                                                     |
| ------------ | ------------------------------------------------------------------ |
| **Budget**   | Spending limits and cost charts.                                    |
| **Triage**   | Things that need a decision from you.                               |
| **Errors**   | Problems that came up, grouped so you can spot patterns.            |
| **Audit**    | A record of what happened and when.                                 |
| **Memory**   | What C5 has remembered from your past work.                         |

## Self-improvement milestones

As your agents complete real work, C5 unlocks advanced self-improvement features. These
are gated behind completed task milestones so they only run once there is enough history
to be helpful without wasting your budget on early guesses.

When you reach a milestone, a star badge appears in the bottom left of your sidebar:

| Milestone | Completed tasks | Sidebar badge | What it does |
| --- | --- | --- | --- |
| **Retrospective Loop** | 50 tasks | **Violet star** | Analyzes failed tasks to suggest new review rules and compare rule similarity. |
| **Reward Model Promotion** | 100 tasks | **Blue star** | Uses historical data to automatically promote experimental prompt variants when they beat the baseline. |

### Tracking your progress

You can check your progress toward each milestone in **Settings › Budget**:

1. Go to **Settings**.
2. Open the **Budget** tab.
3. Look at the **Retrospective Loop** and **Reward Model Promotion** cards to see your current completed task count (e.g. `34/50` or `82/100`).

Once unlocked, you can click either star in the sidebar to review what unlocked, or turn the feature on or off in **Settings › Budget** to manage token usage.

## Keeping costs down

A few habits help:

- **Use smaller models for simple work.** Not every task needs the most expensive
  option. See [Model providers](/c5/configuration/model-providers).
- **Be specific.** A clear request takes fewer tries than a vague one.
- **Check your schedules.** A frequent schedule is usually the biggest line on the bill.
- **Run models locally** for routine work, and save paid models for the hard parts.

## Where to go next

- [Labs](/c5/using-c5/labs) — recipes, skills, and prompt variants.
- [Analytics](/c5/using-c5/analytics) — track agent performance over time.
- [Settings](/c5/configuration/settings) — full configuration map.

