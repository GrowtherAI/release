---
title: Schedules
description: Set up work that runs on its own, on a timer you choose.
order: 4
---

# Schedules

A schedule is work that runs on its own. You set it up once, and C5 does it again and
again without you asking.

## Good things to schedule

- A summary of your week, every Friday afternoon
- A check on your inbox each morning
- A report pulled together on the first of the month
- A nightly tidy-up of a folder

If you find yourself asking for the same thing over and over, make it a schedule.

## Making one

1. Go to **Schedules**.
2. Click **New schedule**.
3. Write what you want done, the same way you would in Chat.
4. Pick when it should run.
5. Save.

That is it. C5 takes it from there.

## Picking when it runs

You can choose simple timing in plain words — every day, every Monday, every hour, the
first of each month.

If you need something more exact, you can write a **cron** pattern. Cron is a short way
of describing a repeating time. You do not need to learn it unless you want to.

| You want                | Cron pattern  |
| ----------------------- | ------------- |
| Every day at 9 in the morning | `0 9 * * *`   |
| Every Monday at 8       | `0 8 * * 1`   |
| Every hour              | `0 * * * *`   |
| First day of the month  | `0 9 1 * *`   |

C5 shows you the next few run times before you save, so you can check you got it right.

## Watching them run

Each schedule has a history. You can see:

- When it last ran
- Whether it worked or failed
- How long it took
- What it produced

Click any run to open it like a normal task and see every step.

## Pausing and stopping

You can pause a schedule and turn it back on later. Pausing keeps the setup and the
history — it just stops running for now.

Deleting removes the schedule. Work it already finished stays in your Library.

## If a run fails

C5 tells you and keeps the schedule alive. It will try again at the next normal time.
It does not quietly stop.

Open the failed run to see what went wrong. Common causes are an expired API key or a
spending limit that was already used up.

> **Tip**
> Set up an alert so you hear about failures right away instead of finding out later.
> See [Settings](/c5/configuration/settings).

## Things to watch out for

- **Costs add up.** A schedule that runs every hour runs 720 times a month. Set a budget
  in [Ops](/c5/using-c5/ops) before you build a busy schedule.
- **Your computer has to be on.** C5 runs on your machine. If it is asleep, the schedule
  waits. C5 will catch up when it wakes.
- **Start slow.** Run something daily for a week before you move it to hourly.
