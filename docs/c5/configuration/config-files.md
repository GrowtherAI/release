---
title: Config files
description: Manage your keys, coordinator addresses, and settings in ~/.growther/config/c5.yaml.
order: 3
---

# Config files

Most of the time, you manage C5 through the web interface in **Settings**.

Behind the scenes, C5 keeps your API keys, local coordinator addresses, and bootstrap
settings in a single file on your computer:

```text
~/.growther/config/c5.yaml
```

*(If you used an older version of C5, this replaces the deprecated `~/.growther/.env` file.)*

## What is in `c5.yaml`

The file is organized into clear sections:

- **Core & System Settings** — Your license key seed, port, and home directory.
- **API & MCP Services** — Search tokens (Brave), GitHub access tokens, and chat integrations.
- **LLM Coordinators & Agent Platforms** — Base URLs and keys for local model runners like LM Studio, Ollama, and llama.cpp.
- **Cloud LLM Providers** — API keys for Anthropic, OpenAI, Google Gemini, AWS Bedrock, and others.
- **Custom Keys** — Any extra environment variables you add yourself.

Here is a short example of what it looks like:

```yaml
# --- 1. C5 Core & System Settings ---
PORT: "4299"

# --- 2. API & MCP Services ---
BRAVE_API_KEY: "BSAHohpa..."
GITHUB_PERSONAL_ACCESS_TOKEN: ""

# --- 3. LLM Coordinators & Agent Platforms ---
LMSTUDIO_BASE_URL: "http://127.0.0.1:1234/v1"
LMSTUDIO_API_KEY: ""
OLLAMA_BASE_URL: "http://127.0.0.1:11434"
LLAMACPP_BASE_URL: "http://127.0.0.1:8080/v1"
OPENROUTER_API_KEY: ""

# --- 4. Cloud LLM Providers ---
ANTHROPIC_API_KEY: "sk-ant-api03-..."
OPENAI_API_KEY: ""
GEMINI_API_KEY: ""
```

## How changes take effect

You can update your settings in two ways:

1. **In the web interface** — Go to **Settings › LLMs** or **Settings › Integrations**, paste your key or address, and click **Save**.
2. **By editing the file** — Open `~/.growther/config/c5.yaml` in your favorite text editor, make your changes, and save the file.

### Live updates (Hot reloading)

When you update a coordinator Base URL (like moving LM Studio or Ollama to another machine or port) or add an API key:

- C5 picks up the changes **immediately**.
- You do **not** need to restart the C5 server.
- The model scanner instantly uses your new address to find available models.

When C5 writes to this file after you click **Save** in the app, it preserves your existing comments, blank lines, and custom keys.

## File permissions and security

Your `c5.yaml` file holds sensitive passwords and tokens. C5 saves it with owner-only (`0600`) permissions:

- Only your user account can read or write to it.
- Other user accounts on the same computer cannot open it.

> **Warning**
> Treat `c5.yaml` like a password file. Do not commit it to public version control or paste its contents into public messages.
> See [Local encryption](/c5/security/encryption).

## Where to go next

- [Model providers](/c5/configuration/model-providers) — how to connect cloud and local models.
- [Settings](/c5/configuration/settings) — a full map of the settings screen.
- [Guardrails](/c5/security/guardrails) — safety limits and network allowlists.
