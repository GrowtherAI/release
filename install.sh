#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Growther.ai C5 installer  ·  curl -fsSL https://growther.ai/install.sh | bash
#
# Downloads the self-contained V8-bytecode binary for this OS/arch from GitHub
# Releases, verifies its SHA-256, installs it on PATH, and seeds ~/.growther with
# the signed build manifest. The app itself verifies that manifest's Ed25519
# signature at runtime (SOC 2 Change Management).
#
# Env overrides (all optional):
#   GROWTHER_VERSION        release tag to install (default: latest)
#   GROWTHER_INSTALL_DIR    where the binary goes    (default: ~/.local/bin)
#   GROWTHER_HOME           data dir                 (default: ~/.growther)
#   GROWTHER_RELEASE_BASE   release host base URL    (default: growtherai/release raw mirror)
#   GROWTHER_INSTALL_SERVICE=1   install a launchd/systemd user service
#   GROWTHER_NO_MODIFY_PATH=1    don't touch shell rc files
# ─────────────────────────────────────────────────────────────────────────────

# THIS FILE IS CANONICAL. growther.ai serves it (marketing repo, public/install.sh)
# and growtherai/release publishes it — both are mirrors checked against this
# copy by hash. There used to be three hand-maintained variants: the one people
# actually ran (growther.ai) had the signed-release pin but not the icon stamp;
# this one had the icon stamp but not the pin. One file now carries both.
BIN_NAME="growther"
INSTALL_DIR="${GROWTHER_INSTALL_DIR:-$HOME/.local/bin}"
GROWTHER_HOME="${GROWTHER_HOME:-$HOME/.growther}"
# Public distribution is the raw growtherai/release mirror (dist/c5/<tag>/<asset>),
# NOT the private source repo's GitHub Releases (which aren't anonymously downloadable).
DEFAULT_RELEASE_BASE="https://raw.githubusercontent.com/growtherai/release/main/dist/c5"
RELEASE_BASE="$DEFAULT_RELEASE_BASE"
# A custom mirror redirects BOTH the binary and its checksum, so it is the whole
# trust root for this install. Require an explicit second opt-in rather than
# letting a single exported variable silently repoint a `curl | bash`.
if [ -n "${GROWTHER_RELEASE_BASE:-}" ] && [ "${GROWTHER_RELEASE_BASE}" != "$DEFAULT_RELEASE_BASE" ]; then
  if [ "${GROWTHER_ALLOW_CUSTOM_MIRROR:-}" = "1" ]; then
    RELEASE_BASE="$GROWTHER_RELEASE_BASE"
  else
    printf '%s\n' "refusing GROWTHER_RELEASE_BASE=${GROWTHER_RELEASE_BASE}" >&2
    printf '%s\n' "a custom mirror supplies both the binary and its checksum; re-run with GROWTHER_ALLOW_CUSTOM_MIRROR=1 if you trust it" >&2
    exit 1
  fi
fi
VERSION="${GROWTHER_VERSION:-latest}"

# >>> GROWTHER_PINNED_RELEASE >>>
# Replaced at serve time by growther.ai with hashes taken from an Ed25519-VERIFIED
# release manifest. Verification happens on the server because Ed25519 is not
# reliably available in a portable shell (macOS ships LibreSSL, whose pkeyutl has
# no -rawin). Left as-is, this file is UNPINNED and says so before installing.
GROWTHER_PINNED_VERSION=""
GROWTHER_PINNED_ASSETS=""
# <<< GROWTHER_PINNED_RELEASE <<<

c_reset=$'\033[0m'; c_b=$'\033[1m'; c_g=$'\033[32m'; c_y=$'\033[33m'; c_r=$'\033[31m'
say()  { printf '%s\n' "$*"; }
info() { printf '%s➜%s %s\n' "$c_b" "$c_reset" "$*"; }
ok()   { printf '%s✓%s %s\n' "$c_g" "$c_reset" "$*"; }
warn() { printf '%s!%s %s\n' "$c_y" "$c_reset" "$*" >&2; }
die()  { printf '%s✗ %s%s\n' "$c_r" "$*" "$c_reset" >&2; exit 1; }

trap 'die "install failed on line $LINENO"' ERR

# ── Dependencies ─────────────────────────────────────────────────────────────
have() { command -v "$1" >/dev/null 2>&1; }
if have curl; then DL=(curl -fsSL -o); elif have wget; then DL=(wget -qO); else
  die "need curl or wget"; fi
have tar || die "need tar"

# ── OS / arch detection ──────────────────────────────────────────────────────
case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *) die "unsupported OS: $(uname -s) (this installer covers macOS/Linux; use install.ps1 on Windows)";;
esac
case "$(uname -m)" in
  arm64|aarch64) ARCH=arm64 ;;
  x86_64|amd64)  ARCH=x64 ;;
  *) die "unsupported architecture: $(uname -m)";;
esac
ASSET="growther-node22-${OS}-${ARCH}.tar.gz"
info "target: ${c_b}${OS}-${ARCH}${c_reset} · version: ${c_b}${VERSION}${c_reset}"

# ── Resolve the release tag + URL (raw mirror layout: <base>/<tag>/<asset>) ───
# 'latest' reads the published catalog's .stable.version; an explicit version is
# normalized to a v-prefixed tag (accepts "2026.7.16-v42" or "v2026.7.16-v42").
if [ "$VERSION" = "latest" ]; then
  cat_tmp="$(mktemp)"
  "${DL[@]}" "$cat_tmp" "${RELEASE_BASE}/releases.json" 2>/dev/null && [ -s "$cat_tmp" ] \
    || die "cannot fetch release catalog: ${RELEASE_BASE}/releases.json"
  if have jq; then ver="$(jq -r '.stable.version' "$cat_tmp")";
  elif have python3; then ver="$(python3 -c "import json,sys;print(json.load(open(sys.argv[1]))['stable']['version'])" "$cat_tmp")";
  else
    # Last-resort parse with no JSON tool present. Scope to the "stable" block
    # first (sed) so we never pick up a delta/beta channel's "version" — the
    # entry lists "version" before its "assets", so the first match after
    # "stable": is the stable version. `|| true` keeps `set -e` from aborting
    # before the friendly guard below fires on an empty result.
    ver="$(sed -n '/"stable"[[:space:]]*:/,/}/p' "$cat_tmp" \
      | grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' \
      | head -1 | sed -E 's/.*"([^"]*)"$/\1/' || true)"
  fi
  rm -f "$cat_tmp"
  [ -n "$ver" ] && [ "$ver" != "null" ] || die "could not read .stable.version from ${RELEASE_BASE}/releases.json — install jq or python3, or re-run with an explicit version (e.g. GROWTHER_VERSION=2026.7.17)"
  TAG="v${ver#v}"
else
  TAG="v${VERSION#v}"
fi
URL="${RELEASE_BASE}/${TAG}/${ASSET}"
info "resolved ${c_b}${TAG}${c_reset}"

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"; ' EXIT
info "downloading ${ASSET}"
"${DL[@]}" "$TMP/$ASSET" "$URL" || die "download failed: $URL"
# The PINNED hash wins when present. It came from a signature-verified manifest,
# whereas <asset>.sha256 is unsigned and served from the SAME origin as the
# binary — so the sidecar proves transit integrity, not authenticity.
pinned_sha=""
if [ -n "$GROWTHER_PINNED_ASSETS" ]; then
  pinned_sha="$(printf '%s\n' "$GROWTHER_PINNED_ASSETS" \
    | awk -v k="${OS}-${ARCH}" '$1 == k { print $3; exit }')"
fi

file_sha() {
  if have sha256sum; then sha256sum "$1" | awk '{print $1}'
  else shasum -a 256 "$1" | awk '{print $1}'; fi
}

if [ -n "$pinned_sha" ]; then
  info "verifying SHA-256 (pinned to the signed release manifest for ${GROWTHER_PINNED_VERSION:-?})"
  actual="$(file_sha "$TMP/$ASSET")"
  [ "$pinned_sha" = "$actual" ] \
    || die "checksum mismatch against the SIGNED release manifest: expected $pinned_sha got $actual — do not run this file"
  ok "checksum verified against the signed release manifest"
  # A sidecar that disagrees with the signed manifest means the download path is
  # serving something other than what was signed. Report it; the pin already won.
  if "${DL[@]}" "$TMP/$ASSET.sha256" "${URL}.sha256" 2>/dev/null && [ -s "$TMP/$ASSET.sha256" ]; then
    side="$(awk '{print $1}' "$TMP/$ASSET.sha256")"
    [ "$side" = "$pinned_sha" ] || warn "the published .sha256 disagrees with the signed manifest — using the signed value"
  fi
elif "${DL[@]}" "$TMP/$ASSET.sha256" "${URL}.sha256" 2>/dev/null && [ -s "$TMP/$ASSET.sha256" ]; then
  # Unpinned: this installer was not served by growther.ai (saved copy, mirror,
  # or a preview without the verification key). The sidecar is same-origin and
  # unsigned, so say what it does and does not prove.
  warn "unpinned installer — the checksum below is unsigned and comes from the same host as the download"
  info "verifying SHA-256"
  expected="$(awk '{print $1}' "$TMP/$ASSET.sha256")"
  actual="$(file_sha "$TMP/$ASSET")"
  [ "$expected" = "$actual" ] || die "checksum mismatch: expected $expected got $actual"
  ok "checksum verified (unsigned sidecar)"
  say "  Run ${c_b}growther verify${c_reset} after installing for a signature-backed check."
else
  # No per-asset checksum → refuse to run unverified bytes (the runtime attestation
  # does NOT hash the binary). Explicit opt-out for air-gapped/local installs.
  if [ "${GROWTHER_INSECURE_SKIP_CHECKSUM:-0}" = "1" ]; then
    warn "no checksum for $ASSET and GROWTHER_INSECURE_SKIP_CHECKSUM=1 — installing UNVERIFIED"
  else
    die "no published checksum for $ASSET — refusing to install unverified (set GROWTHER_INSECURE_SKIP_CHECKSUM=1 to override)"
  fi
fi

# ── Extract ──────────────────────────────────────────────────────────────────
info "extracting"
if tar -tzf "$TMP/$ASSET" | grep -Eq '(^/|(^|/)\.\./)'; then
  die "refusing archive: contains absolute or parent-relative paths"
fi
tar -xzf "$TMP/$ASSET" -C "$TMP" --no-same-owner
BIN_SRC="$(find "$TMP" -maxdepth 2 -type f -name "growther-c5-${OS}-${ARCH}*" | head -1)"
[ -n "$BIN_SRC" ] || BIN_SRC="$(find "$TMP" -maxdepth 2 -type f -name 'growther-c5-*' ! -name '*.json' ! -name '*.sha256' ! -name '*.tar.gz' | head -1)"
[ -n "$BIN_SRC" ] && [ -f "$BIN_SRC" ] || die "binary not found in archive"

# ── Install binary ───────────────────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
install -m 0755 "$BIN_SRC" "$INSTALL_DIR/$BIN_NAME"
ok "installed ${c_b}${INSTALL_DIR}/${BIN_NAME}${c_reset}"

# ── Icon on the UNIX EXECUTABLE ──────────────────────────────────────────────
# This is the icon that matters most: `growther` in ~/.local/bin is what people
# actually run, and the .app launches with no terminal attached, so it is a poor
# home for a server that logs to stdout.
#
# A Mach-O has no icon slot — unlike a Windows .exe, where the icon is embedded
# in the PE and travels with the file. On macOS the icon is a RESOURCE FORK, and
# a fork survives no copy, archive, or artifact upload (`install -m 0755` above
# copies bytes, so it cannot carry one). It has to be written here, on this
# machine, against the file that was just installed.
#
# The .icns ships in the macOS tarball beside the binary, so this needs no
# network and no assumptions about what else is on disk. (It used to be pulled
# out of a Growther C5.app; that bundle is gone — it cost a second full copy of
# the binary to deliver an icon on something LaunchServices starts with no
# terminal attached. The icon belongs on the CLI, which is what people run.)
# Best-effort throughout: `swift` only exists with the Xcode command line tools,
# and C5 re-attempts this on boot (applyDarwinIcon in
# server/src/cli/selfInstall.ts), so a miss here is a delay, never a failure.
if [ "$OS" = "macos" ]; then
  ICNS_SRC="$(find "$TMP" -maxdepth 5 -type f -name 'logo-c5.icns' | head -1)"
  if [ -n "$ICNS_SRC" ]; then
    applied=0
    if have osascript; then
      if osascript -l JavaScript -e "
ObjC.import('Cocoa');
var img = $.NSImage.alloc.initWithContentsOfFile('$ICNS_SRC');
if (!img.isNil()) {
  var ok = $.NSWorkspace.sharedWorkspace.setIconForFileOptions(img, '$INSTALL_DIR/$BIN_NAME', 0);
  if (!ok) $.exit(1);
} else {
  $.exit(1);
}" >/dev/null 2>&1; then
        applied=1
      fi
    fi
    if [ "$applied" -eq 0 ] && have swift; then
      if swift -e "
import Cocoa
if let img = NSImage(contentsOfFile: \"$ICNS_SRC\") {
  if !NSWorkspace.shared.setIcon(img, forFile: \"$INSTALL_DIR/$BIN_NAME\", options: []) { exit(1) }
} else { exit(1) }" >/dev/null 2>&1; then
        applied=1
      fi
    fi
    if [ "$applied" -eq 1 ]; then
      ok "applied the C5 icon to ${c_b}${INSTALL_DIR}/${BIN_NAME}${c_reset}"
    else
      info "could not stamp the binary icon (C5 will retry on first run)"
    fi
  else
    info "skipping binary icon (logo-c5.icns not found in archive; C5 will retry on first run)"
  fi
fi

# ── Seed ~/.growther + drop the signed build manifest (Installer method) ─────
mkdir -p "$GROWTHER_HOME"
chmod 0700 "$GROWTHER_HOME" 2>/dev/null || true
MANIFEST_SRC="$(find "$TMP" -maxdepth 2 -type f -name 'build_manifest.json' | head -1 || true)"
if [ -n "$MANIFEST_SRC" ]; then
  cp "$MANIFEST_SRC" "$GROWTHER_HOME/build_manifest.json"
  ok "seeded ${GROWTHER_HOME}/build_manifest.json (signed attestation)"
fi

# ── PATH ─────────────────────────────────────────────────────────────────────
case ":$PATH:" in
  *":$INSTALL_DIR:"*) : ;;
  *)
    if [ "${GROWTHER_NO_MODIFY_PATH:-0}" != "1" ]; then
      rc=""
      case "${SHELL##*/}" in zsh) rc="$HOME/.zshrc";; bash) rc="$HOME/.bashrc";; fish) rc="$HOME/.config/fish/config.fish";; esac
      if [ -n "$rc" ]; then
        line="export PATH=\"$INSTALL_DIR:\$PATH\""
        [ "${SHELL##*/}" = "fish" ] && line="fish_add_path $INSTALL_DIR"
        mkdir -p "$(dirname "$rc")" 2>/dev/null || true   # fish: ~/.config/fish may not exist
        if ! grep -qF "$INSTALL_DIR" "$rc" 2>/dev/null; then
          if printf '\n# Growther.ai C5\n%s\n' "$line" >> "$rc" 2>/dev/null; then
            ok "added $INSTALL_DIR to PATH in $rc (restart your shell)"
          else
            warn "could not update PATH in $rc — add $INSTALL_DIR to your PATH manually"
          fi
        fi
      fi
    else
      warn "$INSTALL_DIR is not on PATH — add it manually"
    fi
    ;;
esac

# ── Optional user service ────────────────────────────────────────────────────
# Register managed startup (auto-start at sign-in + keep-alive) through the
# binary itself so there is ONE definition — see
# server/src/services/serviceManager.ts — with the correct exit-code contract:
# a clean `growther stop` / the in-app Quit exits 0 and STAYS down; only a crash
# (non-zero exit) is restarted. Covers macOS (launchd), Linux (systemd --user,
# with an autostart fallback), and Windows (Task Scheduler). No admin required.
# Activates at the next sign-in; run `growther` now to start it immediately.
if [ "${GROWTHER_INSTALL_SERVICE:-0}" = "1" ]; then
  if "$INSTALL_DIR/$BIN_NAME" service install >/dev/null 2>&1; then
    ok "managed startup enabled (auto-start + keep-alive) — manage in Settings › System › Startup & Reliability"
  else
    warn "could not enable managed startup (run '$BIN_NAME service install' to retry)"
  fi
fi

# ── Done ─────────────────────────────────────────────────────────────────────
say ""
ok "${c_b}Growther.ai C5 installed.${c_reset}"
say ""
say "Next steps:"
say "  1. Start it:  ${c_b}${BIN_NAME}${c_reset}  — opens your browser to activate (sign in, then start a trial or pick a plan)."
say "       Or activate explicitly:  ${c_b}${BIN_NAME} activate${c_reset}    (set GROWTHER_INSTALL_SERVICE=1 to run as a service)"
say "  2. Update later:  ${c_b}${BIN_NAME} update${c_reset}"
say ""
say "  Installing offline or air-gapped? See ${c_b}https://docs.growther.ai/c5/getting-started/installation${c_reset}"
say ""
