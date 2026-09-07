---
title: Secrets and keys
description: Move API keys out of the config file into your keystore or vault, and escrow the device key so a rebuilt machine can be recovered.
order: 9
---

# Secrets and keys

C5 holds two kinds of secret. Understanding the difference is most of what you need.

**Your API keys and tokens** let C5 talk to model providers, GitHub, Slack and the rest.
By default they sit in `config/c5.yaml`, readable by anyone who can read your files.

**The device key** is different. It is 32 random bytes that encrypt your four databases,
sign your session tokens, and back the break-glass recovery path. Lose it and the
databases are unreadable, even by you. Nothing can rebuild it.

## Move your API keys into a keystore

C5 can keep each key in your operating system's own keystore, or in your organisation's
vault, and leave only a reference behind in the config file.

Open **Settings › Enterprise › Secrets custody**, or run:

```bash
growther secrets status
growther secrets migrate --to keychain     # macOS
growther secrets migrate --to dpapi        # Windows
growther secrets migrate --to secret-service   # Linux
```

Vault backends work the same way:

```bash
growther secrets migrate --to keyvault     # Azure Key Vault
growther secrets migrate --to aws-sm       # AWS Secrets Manager
growther secrets migrate --to vault        # HashiCorp Vault
```

Afterwards `c5.yaml` holds a reference rather than a value:

```yaml
OPENAI_API_KEY: "ref:keychain:c5/OPENAI_API_KEY"
```

Each key is written to the keystore, read back, and only then replaced in the file. If the
read-back does not return exactly what was written, nothing is changed. `growther secrets
revert` brings the plaintext values back.

On Windows fleets where AppLocker or WDAC enforces Constrained Language Mode, PowerShell
cannot reach the encryption API. C5 detects this, keeps the keys in the file, and says so
in `growther doctor`. Set up escrow (below) on those machines.

## Escrow the device key

Escrow wraps the device key set, sealed to a public key **you** hold, into a file that is
safe to keep with your backups. Growther never has your private half and never sees the
key.

```bash
growther key escrow keygen --out ./c5-escrow      # once, on an admin workstation
growther key escrow enable ./c5-escrow/escrow-kek.pub
growther key status
```

The wrapped file lands at `config/key-escrow.blob`. It is not a secret: without your
private key it is meaningless, so it belongs in your normal backup rotation.

Keep the private key where your organisation keeps root secrets. It is the only way back
in after a machine is wiped.

## Then, if you want, wrap the device key itself

With escrow verified, C5 can move the device key out of its file and into the keystore:

```bash
growther key wrap
```

The key is written to the keystore, read back, and only then is the plaintext file
overwritten and deleted. `growther key unwrap` reverses it.

C5 refuses to wrap the key while escrow is missing or out of date. That refusal is
deliberate. On Entra-joined Windows machines the keystore blob is tied to the user's
password key: a forced password reset, an Intune "remove user", or a rebuilt profile
destroys it. Escrow is what makes that recoverable rather than fatal.

## Recover a rebuilt machine

On the new machine, after installing C5, and with C5 stopped:

```bash
growther key recover --escrow ./key-escrow.blob --private-key ./c5-escrow/escrow-kek.key
growther restore --from /backups/growther/2026-09-06T02-00-00 \
                 --escrow ./key-escrow.blob --private-key ./c5-escrow/escrow-kek.key
```

Generate the pair off the C5 machine: the private key must never sit beside the blob it
opens. `key recover` puts the key set back in the right order. `restore` verifies every backup
file against its recorded hash, snapshots whatever is already there, restores the
databases, checks each one opens and passes an integrity check with the recovered key, and
reports whether the licence still recognises this deployment.

## What `growther doctor` tells you

```bash
growther doctor
```

- **Key custody**: file, keystore, or keystore with escrow.
- **Escrow**: disabled, enabled with its key id, or **stale** when the blob no longer
  matches the current device key. Stale escrow under keystore custody is a failure, not a
  warning: fix it before the machine is rebuilt.
- **Plaintext secrets**: how many API keys are still values rather than references.

## What never happens

- A secret is never passed on a command line. Command lines are recorded by Windows
  process auditing and macOS logging; C5 passes every secret on standard input instead.
- A secret never travels in a policy. Your organisation's policy can say *which* keystore
  to use; it can never carry a key.
- The device key is never written to a network folder, a roaming profile, or a synced
  folder, and never leaves the machine except inside an escrow blob sealed to your key.
