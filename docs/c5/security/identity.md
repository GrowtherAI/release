---
title: Sign in with your organisation
description: Entra ID, Okta or any OpenID Connect provider; SAML 2.0; on-prem Active Directory over LDAP; SCIM and group sync.
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
| Any provider that speaks SAML 2.0 | SAML sign-in |
| On-prem Active Directory with no cloud tenant | LDAP sign-in |

Choose the protocol at the top of the section. The fields below it change to match; there
is one identity setup, not three.

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

## Sign in with SAML

Choose **SAML**. Any provider that speaks SAML 2.0 works — Entra ID, Okta, Ping, ADFS,
Shibboleth, OneLogin.

First give your provider the address it must send assertions to. C5 shows it at the top of
the SAML form, and it must match **byte for byte**:

```text
http://localhost:4299/api/v1/auth/saml/acs
```

Register that as the assertion consumer service, with the HTTP-POST binding. If your provider
would rather read a metadata file than have you type the fields, an administrator can fetch
one from C5 at `/api/v1/auth/saml/metadata`.

Then fill in the form:

| Field | What to put in it |
| --- | --- |
| Sign-on URL | Your provider's SAML 2.0 endpoint, from its metadata |
| Entity id | A name for C5 in your federation. C5 sends it as the Issuer and expects it back as the audience |
| Provider entity id | Your provider's `entityID`. **Set it** — see below |
| Signing certificate | The `<X509Certificate>` value from your provider's metadata, or a PEM block. Paste both during a key rollover |
| Audience | Only if your provider sends something other than the entity id |
| Admin group | The group or role value whose holders are C5 administrators. Empty means nobody is |
| Group attribute | Only if your provider puts groups somewhere unusual. Empty consults the well-known names |
| Service-provider key reference | Only if your provider needs signed requests or sends encrypted assertions. A keystore reference, never the key itself |

Press **Test connection**, then Save. The test checks the configuration you typed — the
sign-on URL is usable, the certificate is a certificate, the provider entity id is set. It
does not contact your provider, so a green result means "this is coherent", not "the provider
answered".

The signing certificate is **not a secret**. It is the public half of the key your provider
signs with, the same value it publishes in its own metadata, and it is stored as an ordinary
setting. The service-provider private key, if you use one, is the only SAML secret and is held
as a keystore reference like every other.

Leaving **Provider entity id** empty is the one field that quietly weakens things: without it,
an assertion from any issuer holding that certificate would be accepted. C5 warns about it in
the test and in the form.

### What C5 checks in an assertion

Every one of these has a test behind it that refuses a real, wrongly-formed assertion:

- The **signature covers the assertion itself**, not merely the envelope around it. A signed
  wrapper around an unsigned assertion is a known attack and is refused.
- The **issuer** is the provider you configured. A perfectly valid assertion from somebody
  else's tenant is still somebody else's.
- The **audience** is this C5. An assertion minted for another service in the same federation
  cannot be spent here.
- The **validity window** is current, allowing one minute of clock difference, and the
  assertion is no more than five minutes old whatever its own window says.
- It **answers a sign-in this C5 started**. Nothing else is accepted.
- The **assertion has not been seen before**, even under a fresh sign-in.
- It **names somebody**. An assertion with no subject identifies nobody, and nobody does not
  become an account.

### Two things SAML does not do here

**Sign-in started at your provider is not accepted.** If someone clicks a C5 tile in their
provider's application portal, nothing happens. This is deliberate. An assertion that arrives
unasked has nothing tying it to a sign-in C5 started, which removes the strongest of the checks
above and leaves a document anyone who captured one request could re-present. Start at C5's own
sign-in screen instead. Turning this on later would be a considered change, not a checkbox.

**Single logout is not implemented.** Signing out of C5 ends the C5 session and nothing else;
your provider still considers the person signed in, and so does every other application
federated to it. If your organisation relies on federated sign-out, this is not it yet.

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

Browser sign-in completes on the machine running C5, because the redirect goes to `localhost`.
People using C5 on their own machine are unaffected.

Reaching C5 by a corporate host name instead now has a supported path, because it changes how
passkeys are bound and needs to be done in the right order. See
[Reaching C5 by a corporate name](/c5/security/corporate-name). Two things are worth knowing
before you plan around it:

- It moves **passkeys**, not the sign-in flow. OpenID Connect and LDAP work over a corporate
  name without any of it.
- **SAML does not follow the name.** C5 registers `http://localhost:<port>/api/v1/auth/saml/acs`
  as its assertion consumer address and does not change it when you change the passkey name, so
  a deployment people reach over the network cannot yet take SAML assertions back. Use OpenID
  Connect, LDAP, or `growther login` on the server for that shape.
