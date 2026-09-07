---
title: Managed configuration
description: Push C5 settings from Intune, Jamf, Group Policy or a signed policy file; what users see when a setting is locked; the growther policy commands.
order: 7
---

# Managed configuration

C5 can take its settings from your organisation instead of from each user. Push a
policy from the tools you already run, and every setting it locks shows *Managed by
your organization* on the user's screen.

This page is for IT administrators. Users need to do nothing.

## What you can manage

Every key an organisation may set is listed in the generated templates (below) and
under **Settings › Enterprise › Policy** on any C5. In short:

- **Where things live**: the configuration, data, secrets and cache folders (device
  policy only).
- **Network posture**: port, bind address, allowed hosts, whether credential-less
  sign-in is allowed from the network, proxy and certificate authority, or fully
  offline for air-gapped fleets.
- **What leaves the machine**: sharing improvements with the Mothership, anonymous
  error reports, GitHub backups, automatic updates and the release channel.
- **Models**: which providers and models agents may use.
- **Security**: elevated exec, workspace-only edits, autonomy ceilings, the global cost
  cap, allowed domains.
- **Retention and audit**: audit and event retention, legal hold, the audit shipping
  endpoint.
- **Identity**: the sign-in provider, admin role, whether single sign-on is required.

Secrets are never part of a policy. API keys and tokens live in the keystore; a policy
refers to them, it never carries them.

## Four ways to deliver a policy

### Windows: Intune or Group Policy

Import `Growther-C5.admx` and `en-US/Growther-C5.adml` from the `packaging/enterprise`
folder of the release into the Intune Settings Catalog (imported ADMX) or your central
store. Policies under **Computer Configuration › Growther C5** are locked;
**Recommended** values are defaults the user may change. The values land in
`HKLM\SOFTWARE\Policies\Growther\C5`.

### macOS: Jamf or Intune

Deploy a configuration profile for the preference domain `ai.growther.c5`. Top-level
keys are locked; keys inside a `Recommended` dictionary are defaults. A sample profile,
`ai.growther.c5.mobileconfig`, is in the same folder.

### Linux

Drop one or more YAML files in `/etc/growther/policy.d/`. They are merged in name order
and use the same document shape as a signed policy file.

### A signed policy file (any platform)

Publish a policy document on a share or at an https address and point devices at it
through the platform policy (`PolicySource`), or through `/etc/growther/policy-source.yaml`
on Linux. File and https sources must be signed with a key you pin on each device:

```bash
growther policy keygen --out ./policy-keys          # once, on an admin workstation
growther policy sign policy.yaml --key ./policy-keys/policy-signing.key --out policy.signed.yaml
sudo growther policy pin ./policy-keys/policy-signing.pub   # on each device, or through your MDM
```

A policy document looks like this:

```yaml
schemaVersion: 1
policyId: contoso-c5-baseline
version: 12
managed: true
maxOfflineHours: 336
keys:
  shareImprovements: { value: false, locked: true }
  allowedProviders: { value: ["anthropic", "azure-openai"], locked: true }
  auditRetentionDays: { value: 730 }
```

Azure App Configuration and AWS AppConfig are also accepted as sources; their identity
stands in for the signature, and a signature is verified when present.

## How a policy is applied

1. C5 reads the device policy, then the signed document, at start and every fifteen
   minutes (or on demand).
2. The signature is checked against the pinned key, and the version must be higher
   than the last one applied. An older document is refused as a replay.
3. Every key is checked on its own. An unknown key, a secret, or a value of the wrong
   type is reported and skipped. A locked key with a bad value falls to its safest
   default and raises a critical audit event. One typo never unlocks a fleet.
4. Locked keys shadow whatever the user had set. Lifting the policy restores the
   user's value.
5. If the source becomes unreachable, the last verified policy holds for the grace
   window (default fourteen days). After that, locked keys fall to their safest
   defaults and C5 says so. It never quietly runs unmanaged.
6. To stop managing on purpose, publish a signed document with `managed: false`.

## What users see

A locked control is disabled, shows the value your policy set, and carries a small lock
that names the source when hovered. Administrators who save a page that includes a
locked setting see which settings were set aside; nothing else on the page is lost.

**Settings › Enterprise › Policy** shows the source, the policy id and version, the
signature state, when it was fetched and applied, the locked settings, the defaults it
applied, and any keys it rejected with the reason.

## Validate before you ship

```bash
growther policy validate policy.signed.yaml
growther policy show
growther policy reload
```

`validate` prints one row per key and exits non-zero if anything would be rejected.

## Unattended installs

To push C5 itself, use the Windows or macOS installer package — see
[Deploying across an organisation](/c5/configuration/deploying).

Add `--policy-expected` to the install script, or run `growther policy expect` after
installing. C5 then treats the absence of a policy as a fault rather than a choice, and
disables the anonymous first-user setup so nobody can claim the administrator seat before
your policy arrives. Create the first administrator from the device:

```bash
growther user bootstrap-admin --name "IT Admin"
```

or let the first sign-in through your identity provider create it.

`growther doctor --json` reports *Managed install* with the marker and the admin count,
which is what an Intune detection script or a Jamf extension attribute should read.
