---
title: Sign in with your organisation
description: Entra ID, Okta or any OpenID Connect provider; on-prem Active Directory over LDAP; SCIM and group sync.
order: 11
---

# Sign in with your organisation

C5 can hand sign-in to the identity provider your organisation already uses, so people
reach it with the account they use for everything else, under the same multi-factor and
Conditional Access rules.

This page is for IT administrators. Set it up under **Settings › Enterprise › Identity
and sign-in**.

## What works

| Provider | How |
| --- | --- |
| Microsoft Entra ID | OpenID Connect. Tested first-class |
| Okta, Google Workspace, Ping, Keycloak | OpenID Connect, same settings |
| AD FS | OpenID Connect |
| On-prem Active Directory with no cloud tenant | LDAP sign-in |

## Set up Entra ID

Register C5 in your tenant as a desktop application with the redirect URI
`http://localhost:4299/api/v1/auth/oidc/callback` (Entra permits a `localhost` redirect on
any port for desktop apps; use the port C5 actually listens on). Then in **Settings ›
Enterprise › Identity and sign-in**:

1. Choose **Entra ID** and enter your tenant id. C5 builds the issuer URL for you.
2. Enter the application (client) id.
3. Name the **app role or group** whose members are C5 administrators.
4. Choose whether an unknown but authenticated person gets an account automatically.
5. Press **Test connection**, then Save.

People now see **Sign in with Microsoft** on the sign-in card.

To require it, turn on **Require single sign-on**. Local passwords, PINs and passkeys stop
working, except on the machine itself: the break-glass path stays open on this computer so
a misconfiguration can never lock you out of your own deployment.

## Multi-factor

C5 treats a sign-in as multi-factor when the token says so, either through an `amr` claim
or a Conditional Access authentication-context claim. If your tenant enforces MFA for
everyone through Conditional Access and you would rather not request the claim, turn on
**Trust tenant MFA** and C5 will accept the tenant's guarantee.

Administrative actions require multi-factor either way.

## On-prem Active Directory

Choose **On-prem AD** and give C5 an `ldaps://` URL, the base DN to search under, the
service account to search with (its password as a keystore reference), and the group DN
whose members are administrators. C5 searches for the user, binds as them to check the
password, and reads their group membership. The connection is encrypted unless the server
is on this machine.

## Keeping accounts in step

Two ways, and you should pick one, not both:

- **SCIM 2.0** at `/scim/v2`, for deployments reachable from your identity provider
  through a reverse proxy. Generate the bearer token in **Provisioning**; it is shown once.
  Add the proxy's host name to the allowed hosts or the request is refused before it
  reaches the token check.
- **Group sync**, which C5 initiates itself against Microsoft Graph. Nothing needs to reach
  C5 from outside, so this is the right choice for a normal loopback install.

Both create accounts, set the administrator flag from group membership, and disable people
who leave. Disabling ends their open sessions immediately rather than at the next expiry,
and frees their seat.

Using both against one tenant is refused: the two channels describe the same person with
different identifiers, and C5 stops rather than silently creating two accounts and burning
two seats.

## Signing in without a browser

On a server with no desktop:

```bash
growther login
```

C5 prints a code and a URL to open on any other device, and completes the sign-in when you
have approved it.

## What C5 never does

- It never mints a session from the provider's redirect. The redirect is verified and
  parked; a one-time code is exchanged over the signed channel, so the one place a session
  is created stays the one place.
- It never stores your client secret, bind password, SCIM token or Graph secret in a
  configuration file. All four are keystore references. See
  [Secrets and keys](/c5/security/secrets-and-keys).
- It never accepts an unsigned or wrongly-signed token, a replayed one, or one issued for
  another application.

## A limit worth knowing before you roll out

Browser sign-in completes on the machine running C5, because the redirect goes to
`localhost`. People using C5 on their own machine are unaffected. For a shared deployment
that people reach over the network, use `growther login` on the server for now; reaching a
shared C5 by corporate host name is planned work that changes how passkeys are bound, so it
is being done deliberately rather than quietly.
