---
title: Reaching C5 by a corporate name
description: Change the host name passkeys are bound to without invalidating the ones people already have, using the dual-name enrolment window and the refusal that protects you.
order: 12
---

# Reaching C5 by a corporate name

By default C5 answers to `localhost` on the machine it runs on, and every passkey enrolled on
it is bound to that name. If you want people to reach a shared C5 at something like
`c5.contoso.com`, the passkeys have to move too — and that is the part that needs care.

This page is for IT administrators. The controls are under **Settings › Enterprise › Access
from other machines**.

## Why this is a command and not just a setting

A passkey is bound to the host name it was created under, and the browser checks that name
exactly. Editing the name by hand invalidates every enrolled passkey the moment you save, with
no warning and no staging.

If the only way into the only administrator account is a passkey, that leaves an organisation
locked out of its own C5 with no way back that does not involve the machine's own command line.

So C5 does the change as three things that cannot be separated:

1. a check that refuses when it would lock you out,
2. the change itself, and
3. a **dual-name enrolment window** that keeps the old name working while people move.

## What happens to existing passkeys

Each passkey now records the name it was created under. Changing the name does not invalidate
them — they carry on being checked against the name they were actually bound to.

While the window is open:

| Passkey | What happens |
| --- | --- |
| Enrolled before the change | Keeps working, on the old address |
| Enrolled after the change | Works on the new address |
| Re-enrolled during the window | Bound to the new name, works on the new address |

People re-enrol one at a time, at their own pace. There is no flag day.

The window is **not a timer**. It stays open until you close it, because a window that closed
itself would lock people out at a moment nobody chose.

## Do it

Run this on the machine that hosts C5, as the account that runs C5. See what is enrolled first:

```bash
growther webauthn status
```

It reports the current name, the sign-in origins, whether your organisation's policy sets them,
whether a window is open, how many passkeys exist and which name each is bound to, and how each
administrator signs in.

Then:

```bash
growther webauthn migrate-rpid --to c5.contoso.com
```

By default the sign-in origin becomes `https://c5.contoso.com`. Give `--origins` if people
reach C5 at more than one address, or on a non-standard port:

```bash
growther webauthn migrate-rpid --to contoso.com \
  --origins https://c5.contoso.com,https://c5-eu.contoso.com
```

Both commands ask you to confirm before they change anything. Add `--yes` when you are running
them from a script. The change is live for the running C5, with no restart.

Once everyone has re-enrolled — `growther webauthn status` tells you when nothing is left on
the old name:

```bash
growther webauthn finish
```

That closes the window. Passkeys still bound to the previous name stop working from that point,
so do not run it early.

You can do the same thing from **Settings › Enterprise › Access from other machines**. It
performs exactly the same checks, so nothing you can do in a browser is anything the command
would have refused.

## When C5 refuses, and why

There is no `--force`. A flag that walked past these would be used exactly once, by the person
who most needed it not to exist.

**The only administrator credential is a passkey.** This is the refusal the whole feature exists
for. C5 goes ahead only if at least one of these is true:

- an enabled administrator signs in with something that is not a passkey — a password, a PIN, a
  directory account, or the local break-glass account; or
- an identity provider is configured, so an administrator can sign in through it whatever
  happens to the passkeys.

Fix it by enrolling a second administrator with a password or PIN, or by setting up
[single sign-on](/c5/security/identity) first. This is why the corporate name became possible
only once single sign-on existed: the check now has something to refuse in favour of.

**The name is not a registrable suffix of the origins.** `c5.contoso.com` works for
`https://c5.contoso.com`; `contoso.com` works for both `https://c5.contoso.com` and
`https://c5-eu.contoso.com`; `contoso.com` does not work for `https://c5.fabrikam.com`. If it
did not refuse this, the browser would reject every sign-in afterwards, and that failure reads
as a broken passkey rather than as the misconfiguration it is.

**The origins are not https.** Browsers only run passkeys in a secure context, so an assertion
from a plain `http://` address would fail every time. `localhost` is the exception, as it is
everywhere else.

**The name is an IP address.** Passkeys cannot be bound to an address. Use a host name.

**A window is already open for a different name.** Close it with `growther webauthn finish`
first. A second migration now would forget which name the first set of passkeys is bound to.

**Your organisation's policy sets the name.** Then change it in the policy source — Intune,
Group Policy, Jamf or `/etc/growther/policy.d` — and run the command again to open the window.
The name and the sign-in origins are **device-policy settings only**: a signed policy file or a
relayed bundle cannot set them, because whatever can move this value decides which credentials
open your deployment.

## What this does not do

Changing the name people's passkeys are bound to is not the same as making C5 reachable at that
name. You still need to:

- point the name at the machine, and terminate TLS in front of C5;
- set the bind address and the allowed host names — see
  [Managed configuration](/c5/configuration/enterprise-policy);
- tell each person the new address.

And one thing does not follow the name at all: **SAML**. C5 registers
`http://localhost:<port>/api/v1/auth/saml/acs` as the address its assertions come back to, and
changing the passkey name does not change it. OpenID Connect and LDAP are unaffected.

## Next steps

- [Sign in with your organisation](/c5/security/identity) — set this up first if the refusal
  above blocks you.
- [Managed configuration](/c5/configuration/enterprise-policy) — locking the name from Intune,
  Group Policy or Jamf.
- [The growther command](/c5/cli/commands) — `growther webauthn` in the command reference.
