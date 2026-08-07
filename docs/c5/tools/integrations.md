---
title: Integrations
description: Connect C5 to the services and programs you already use.
order: 4
---

# Integrations

An **integration** connects C5 to something you already use, so your agents can work
with it directly.

## Which services can I connect?

The current list is in the app, under **Settings → Integrations** — it is the accurate
answer, and it grows between releases, which is why this page does not try to repeat it.

If what you need is not listed, it may still be reachable: [MCP servers](/c5/tools/mcp-servers)
are an open standard for adding abilities, and many services already have one.

## Setting one up

1. Go to **Settings**.
2. Open the **Integrations** tab.
3. Pick the service you want.
4. Follow the steps to connect it.
5. Choose what C5 is allowed to do with it.

Most services connect by pasting in a key, or by signing in and approving access.

## Choosing what it can do

Every integration lets you pick how much access to give. Give the least that gets the
job done.

If an agent only needs to read your calendar, do not also let it delete events. You can
always add more later.

> **Tip**
> Where a service supports it, make a separate key just for C5. If you ever want to cut
> access, you can turn off that one key without disturbing anything else.

## Checking the connection

Each integration shows its state:

- **Connected** — working normally.
- **Needs attention** — usually an expired key or a changed password.
- **Failed** — could not connect. C5 explains why.

C5 tests the connection when you save, so you find out immediately rather than when a
task fails at midnight.

## Keys and secrets

Keys you paste in are stored encrypted on your own computer. They are never sent
anywhere except to the service they belong to.

You can replace or remove a key at any time. Removing it stops all access right away.

See [Local encryption](/c5/security/encryption) for how storage works.

## When something stops working

Integrations usually break for boring reasons:

- **The key expired.** Make a new one and paste it in.
- **A password changed.** Reconnect.
- **Access was revoked** on the other service's side.
- **The service is down.** Check its status page.

Open **Settings → Integrations** and reconnect. C5 tests the connection as you save, so
you find out immediately rather than when a task fails at midnight.

## Removing an integration

Open **Integrations**, find it, and remove it. Access stops immediately. Work that
already used it stays in your Library.

## Where to go next

- [MCP servers](/c5/tools/mcp-servers) — add abilities beyond the built-in list.
- [Permissions](/c5/security/permissions) — control what agents may do with a connection.
