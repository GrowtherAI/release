---
title: Log filtering
description: Filter terminal logs by category with hotkeys and save your preferences in cli.yaml.
order: 4
---

# Log filtering

When you run `growther` in an interactive terminal, C5 shows a startup banner and an interactive log filter box:

```text
┏━━━ Log Filter ━━ OFF by default ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  * all        a agents     b database   d dispatcher  g github    ┃
┃  e evolution  k skills     m messages   o orch        q quality   ┃
┃  r recovery   s sessions   t tokens     v voice       ? help      ┃
┗━━━ ctrl+r restart ━━━ ctrl+c quit ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

All log categories are **OFF by default** so your terminal stays clean, quiet, and easy to read. Errors, warnings, and startup notices are always printed so you never miss important events.

## Turning categories on and off

While C5 is running, press a single key on your keyboard to toggle a category ON or OFF in real time. You do not need to press Shift or Enter:

| Key | Category | What it covers |
| --- | --- | --- |
| `a` | **agents** | Autonomous agent tasks, tool calls, and step execution |
| `b` | **database** | SQLite queries, backups, and schema migrations |
| `d` | **dispatcher** | Job queues, concurrency limits, and task resume checks |
| `e` | **evolution** | Adaptive learning and self-improving algorithms |
| `g` | **github** | Background sync with GitHub repositories and tasks |
| `k` | **skills** | Skill discovery, indexing, and runtime execution |
| `m` | **messages** | Chat platforms like Discord, Slack, Teams, and Telegram |
| `o` | **orchestration** | Chat routing, intent analysis, and response generation |
| `q` | **quality** | Automated test evaluation and quality gates |
| `r` | **recovery** | Smart retries, self-heal routines, and shutdown handling |
| `s` | **sessions** | Client connections, web sockets, and session lifecycles |
| `t` | **tokens** | Token counts and LLM prompt budgets |
| `v` | **voice** | Offline Whisper speech recognition and microphone events |

Categories that are **ON** show in **green**. Categories that are **OFF** show in **cyan/blue**.

### Special hotkeys

- `*` — **Toggle all categories**: Turns all categories ON if any are off, or turns all categories OFF if all are on.
- `?` — **Help table**: Shows or hides a 2-column list of all categories and their current states.
- `Ctrl+R` — **Restart server**: Gracefully reloads C5 in place without closing your terminal window.
- `Ctrl+C` — **Quit**: Stops C5 cleanly.

## Remembering your choices (`cli.yaml`)

You never have to re-enable your favorite categories every time you launch C5. Your choices are automatically saved to:

```text
~/.growther/config/cli.yaml
```

- **First run**: C5 creates this file automatically the first time you run `growther`.
- **Automatic saving**: Whenever you press a hotkey in the terminal, C5 updates `cli.yaml` immediately.
- **Next startup**: The next time C5 starts, it reads `cli.yaml` and restores your exact active categories.

### Editing `cli.yaml` directly

You can also edit `~/.growther/config/cli.yaml` in your favorite text editor before or between runs:

```yaml
# ~/.growther/config/cli.yaml
# Growther C5 CLI Configuration
# Category-based console log filtering (toggled via CLI hotkeys or edited here)
filters:
  agents: false
  database: false
  dispatcher: false
  evolution: false
  github: false
  messages: false
  orchestration: false
  quality: false
  recovery: false
  sessions: false
  skills: false
  tokens: false
  voice: false
```

Set any category to `true` to turn it on, or `false` to keep it off. You can use full category names (such as `voice: true`) or single hotkey letters (such as `v: true`).

## Where to go next

- [The growther command](/c5/cli/commands) — every command and option available in the CLI.
- [Config files](/c5/configuration/config-files) — where your settings and API keys live.
- [Running doctor](/c5/cli/doctor) — check your setup and diagnose problems.
