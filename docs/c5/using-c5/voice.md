---
title: Voice
description: Talk to C5 instead of typing, and have it read replies back to you.
order: 10
---

# Voice

You can talk to C5 instead of typing, and you can have it read replies out loud. Both
are optional. Neither does anything until you turn it on.

Look for the small microphone at the left of the box where you type. It appears in three
places:

- The **Chat** message box
- The prompt box when you create a **Schedule**
- The description box when you edit a **Task**

Hold the microphone button, say what you want, and let go. Your words appear in the box
as text, where you can read them and fix anything before you send.

> **Tip**
> The text stays in the box until you send it. That pause is deliberate — read it back
> before pressing enter, especially if you are asking for something you cannot undo.

## Turning it on

1. Go to **Settings**.
2. Open the **Voice** tab.
3. Turn on a provider under **Speech to text**, **Text to speech**, or both.

You have two kinds of choice, and they behave very differently.

### The built-in option

**Built-in (offline)** turns your speech into text using your own computer. Nothing is
sent anywhere. It works with no internet connection at all — it is the only option that
does.

It needs a one-time download of about 60 MB. C5 fetches it for you, or you can do it
yourself from a terminal:

```bash
growther voice pull
```

**Built-in (this browser)** reads replies aloud using a voice your computer already has.
Nothing leaves your machine, and it costs nothing.

> **Note**
> The offline option understands **English only**. If you speak another language, you
> will want one of the paid providers below, which all handle many languages.

### The paid options

OpenAI, Groq, xAI (Grok), OpenRouter and ElevenLabs all do a better job than the
built-in option, and all of them handle many languages. They are more accurate, and the
voices sound far more natural.

They work by sending your audio to that company. You will need an account with them.

## Adding a key for a paid provider

Voice keys live in your configuration file rather than being typed into the app:

```
~/.growther/config/c5.yaml
```

Open it in a text editor and add the key for the provider you want. The **Voice** tab
tells you the exact name to use for each one, and shows whether it is set yet.

Save the file, and the Voice tab updates on its own. You do not need to restart C5 or
reload the page.

See [Configuration files](/c5/configuration/config-files) for more about `c5.yaml`.

> **Warning**
> Treat an API key like a password. Anyone who has it can spend money on your account.

## What actually leaves your computer

This is worth being clear about, because the answer depends entirely on which option you
picked.

| Option                      | What leaves your computer                                   |
| --------------------------- | ----------------------------------------------------------- |
| **Built-in (offline)**      | Nothing at all                                               |
| **Built-in (this browser)** | Nothing at all                                               |
| Any paid provider           | The audio you recorded, or the text you asked to be read out |

Three things are true whichever you choose:

- **Your recordings are never saved.** C5 turns them into text and throws the audio
  away. It is not written to your database, your logs, or your disk.
- **Your keys never reach your browser.** C5 talks to providers from your own machine.
- **The words are never recorded anywhere.** C5 keeps track of which provider answered
  and how long it took, so you can see what things cost. What you actually said is not
  part of that.

If you use a paid provider, that company's own terms decide what they do with the audio
you send them. C5 cannot promise anything on their behalf. That is exactly why the
offline option exists.

## Keeping the cost down

Paid providers charge by the minute of audio, or by the number of characters they read
out. C5 works out what a request will cost **before** making it, and refuses if it would
take you over your monthly voice budget.

You set that budget in **Settings → Budget**. See [Budgets & costs](/c5/using-c5/ops).

Two things save you money without any effort:

- **Silence is never sent.** If you hold the button and say nothing, C5 notices and
  throws the recording away. There is nothing to pay for.
- **The offline option is free**, and it is never counted against your budget — even if
  you have used the rest of it up.

## Reading replies out loud

Hover over any reply and press the speaker button.

The built-in browser voice costs nothing and works offline, but it sounds like your
computer. A paid provider sounds far more natural and charges per character.

## Voice notes from Slack, Discord and Teams

If someone sends C5 a voice note on a chat platform you have connected, it is
transcribed the same way, using the same providers and the same budget. There is nothing
extra to set up.

You can turn this off for a specific platform in **Settings → Communications**, using the
**Voice/Audio** switch. When it is off, C5 does not download the voice note at all.

> **Note**
> A voice note has nobody to check it. When you dictate, you see the text and can fix it
> before sending — a voice note goes straight to your agent as though you had typed it.
> For anything important, dictate rather than sending a note.

## If something is not working

**There is no microphone button, or C5 says it needs a secure connection.**

Your browser only allows the microphone when the address bar shows `localhost` or an
`https://` address. If you reached C5 using an address like `192.168.1.50` or
`my-mac.local`, the browser blocks the microphone and there is nothing C5 can do about
it. Connect through an SSH tunnel and open `http://localhost` instead.

**C5 says no speech-to-text provider is set up.**

You have not turned on the offline option and have not added a key. Run
`growther voice pull` for the free one, or add a key to `c5.yaml`.

**Dictation keeps coming back empty.**

C5 throws away recordings that are too quiet to contain speech. Check that the right
microphone is selected and that it is not muted.

**Voice stopped working after an update.**

Run this and read both lines:

```bash
growther doctor
```

It tells you two separate things: whether the offline engine can run on your computer,
and whether the model has been downloaded. They are different problems with different
fixes.

**You want to remove the downloaded model.**

`growther uninstall --purge-data` removes it along with everything else C5 stores.
