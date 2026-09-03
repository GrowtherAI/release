# ─────────────────────────────────────────────────────────────────────────────
# Growther.ai C5 installer (Windows)  ·  irm https://growther.ai/install.ps1 | iex
#
# Downloads the self-contained V8-bytecode binary for this arch from GitHub
# Releases, verifies SHA-256, installs it on PATH, and seeds %USERPROFILE%\.growther
# with the signed build manifest (verified at runtime).
#
# Env overrides: GROWTHER_VERSION, GROWTHER_INSTALL_DIR, GROWTHER_HOME,
#                GROWTHER_RELEASE_BASE, GROWTHER_NO_MODIFY_PATH=1
# ─────────────────────────────────────────────────────────────────────────────
#Requires -Version 5
$ErrorActionPreference = "Stop"

$Version      = if ($env:GROWTHER_VERSION)      { $env:GROWTHER_VERSION }      else { "latest" }
$InstallDir   = if ($env:GROWTHER_INSTALL_DIR)  { $env:GROWTHER_INSTALL_DIR }  else { "$env:LOCALAPPDATA\Growther\bin" }
$GrowtherHome = if ($env:GROWTHER_HOME)         { $env:GROWTHER_HOME }         else { "$env:USERPROFILE\.growther" }
# THIS FILE IS CANONICAL. growther.ai serves it and growtherai/release publishes
# it — both are mirrors checked against this copy by hash. It used to exist as
# three divergent variants (this repo, the release repo, growther.ai's fork);
# only the fork had the signed-release pin. One file now carries everything.
#
# Public distribution is the raw growtherai/release mirror (dist/c5/<tag>/<asset>),
# NOT the private source repo's GitHub Releases (not anonymously downloadable).
$DefaultReleaseBase = "https://raw.githubusercontent.com/growtherai/release/main/dist/c5"
$ReleaseBase  = $DefaultReleaseBase
# A custom mirror supplies BOTH the binary and its checksum, so it is the whole
# trust root. Require an explicit second opt-in rather than letting one env var
# silently repoint an `irm | iex`.
if ($env:GROWTHER_RELEASE_BASE -and $env:GROWTHER_RELEASE_BASE -ne $DefaultReleaseBase) {
  if ($env:GROWTHER_ALLOW_CUSTOM_MIRROR -eq "1") {
    $ReleaseBase = $env:GROWTHER_RELEASE_BASE
  } else {
    Write-Error "refusing GROWTHER_RELEASE_BASE=$($env:GROWTHER_RELEASE_BASE) — a custom mirror supplies both the binary and its checksum; re-run with GROWTHER_ALLOW_CUSTOM_MIRROR=1 if you trust it"
    exit 1
  }
}

# >>> GROWTHER_PINNED_RELEASE >>>
# Replaced at serve time by growther.ai with hashes from an Ed25519-VERIFIED
# release manifest. Left as-is, this file is UNPINNED and says so before installing.
$GrowtherPinnedVersion = ""
$GrowtherPinnedAssets = ""
# <<< GROWTHER_PINNED_RELEASE <<<

# Arch detection (handles ARM64 under x64 emulation).
$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64" -or $env:PROCESSOR_ARCHITEW6432 -eq "ARM64") { "arm64" } else { "x64" }
$asset = "growther-node22-win-$arch.zip"
# Resolve the release tag (raw layout: <base>/<tag>/<asset>). 'latest' reads the
# catalog's .stable.version; an explicit version is normalized to a v-prefixed tag.
if ($Version -eq "latest") {
  # raw.githubusercontent.com serves releases.json as text/plain, which
  # Invoke-RestMethod does NOT auto-deserialize — parse the string ourselves.
  $cat = Invoke-RestMethod -Uri "$ReleaseBase/releases.json" -UseBasicParsing
  if ($cat -is [string]) { $cat = $cat | ConvertFrom-Json }
  $ver = $cat.stable.version
  if (-not $ver) { throw "could not read .stable.version from $ReleaseBase/releases.json" }
  $tag = "v" + ($ver -replace '^v','')
} else {
  $tag = "v" + ($Version -replace '^v','')
}
$url = "$ReleaseBase/$tag/$asset"
Write-Host "➜ target: win-$arch · version: $Version"

$tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ("growther-" + [guid]::NewGuid()))
try {
  Write-Host "➜ downloading $asset"
  Invoke-WebRequest -Uri $url -OutFile "$tmp\$asset" -UseBasicParsing

  # Fetch the checksum separately so a genuine MISMATCH hard-fails (only a missing
  # sidecar is tolerated, and only with the explicit opt-out).
  $haveChecksum = $false
  try {
    Invoke-WebRequest -Uri "$url.sha256" -OutFile "$tmp\$asset.sha256" -UseBasicParsing
    $haveChecksum = Test-Path "$tmp\$asset.sha256"
  } catch { $haveChecksum = $false }

  # The PINNED hash wins when present: it came from a signature-verified manifest,
  # whereas the .sha256 sidecar is unsigned and served from the SAME origin as the
  # binary, so it proves transit integrity and not authenticity.
  $pinnedSha = ""
  if ($GrowtherPinnedAssets) {
    foreach ($line in ($GrowtherPinnedAssets -split "`n")) {
      $parts = $line.Trim() -split '\s+'
      if ($parts.Length -ge 3 -and $parts[0] -eq "win-$arch") { $pinnedSha = $parts[2].ToLower(); break }
    }
  }

  $actual = (Get-FileHash "$tmp\$asset" -Algorithm SHA256).Hash.ToLower()

  if ($pinnedSha) {
    Write-Host "➜ verifying SHA-256 (pinned to the signed release manifest for $GrowtherPinnedVersion)"
    if ($pinnedSha -ne $actual) {
      throw "checksum mismatch against the SIGNED release manifest: expected $pinnedSha got $actual — do not run this file"
    }
    Write-Host "✓ checksum verified against the signed release manifest"
    if ($haveChecksum) {
      $side = ((Get-Content "$tmp\$asset.sha256") -split '\s+')[0].ToLower()
      if ($side -ne $pinnedSha) {
        Write-Warning "the published .sha256 disagrees with the signed manifest — using the signed value"
      }
    }
  } elseif ($haveChecksum) {
    # Unpinned: not served by growther.ai (saved copy, mirror, or a preview
    # without the verification key). Say what the sidecar does and does not prove.
    Write-Warning "unpinned installer — the checksum below is unsigned and comes from the same host as the download"
    $expected = ((Get-Content "$tmp\$asset.sha256") -split '\s+')[0].ToLower()
    if ($expected -ne $actual) { throw "checksum mismatch: expected $expected got $actual" }
    Write-Host "✓ checksum verified (unsigned sidecar)"
    Write-Host "  Run 'growther verify' after installing for a signature-backed check."
  } elseif ($env:GROWTHER_INSECURE_SKIP_CHECKSUM -eq "1") {
    Write-Warning "no checksum for $asset and GROWTHER_INSECURE_SKIP_CHECKSUM=1 — installing UNVERIFIED"
  } else {
    throw "no published checksum for $asset — refusing to install unverified (set GROWTHER_INSECURE_SKIP_CHECKSUM=1 to override)"
  }

  Expand-Archive -Path "$tmp\$asset" -DestinationPath "$tmp\x" -Force
  $bin = Get-ChildItem -Path "$tmp\x" -Recurse -Filter "growther-c5-win-$arch*.exe" | Select-Object -First 1
  if (-not $bin) { $bin = Get-ChildItem -Path "$tmp\x" -Recurse -Filter "growther-c5-*.exe" | Select-Object -First 1 }
  if (-not $bin) { throw "binary not found in archive" }

  New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
  Copy-Item $bin.FullName "$InstallDir\growther.exe" -Force
  Write-Host "✓ installed $InstallDir\growther.exe"

  Set-Content -Path "$InstallDir\growther.cmd" -Value "@echo off`r`n`"%~dp0growther.exe`" %*`r`n" -Encoding ASCII
  Set-Content -Path "$InstallDir\growther" -Value "#!/bin/sh`nexec `"`$(dirname `"`$0`")/growther.exe`" `"`$@`"`n" -Encoding ASCII

  New-Item -ItemType Directory -Force -Path $GrowtherHome | Out-Null
  $manifest = Get-ChildItem -Path "$tmp\x" -Recurse -Filter "build_manifest.json" | Select-Object -First 1
  if ($manifest) { Copy-Item $manifest.FullName "$GrowtherHome\build_manifest.json" -Force; Write-Host "✓ seeded $GrowtherHome\build_manifest.json" }

  if ($env:GROWTHER_NO_MODIFY_PATH -ne "1") {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not $userPath) { $userPath = "" }
    $entries = $userPath -split ';' | Where-Object { $_.Trim() -ne '' }
    $normTarget = $InstallDir.TrimEnd('\', '/')
    $alreadyOnPath = $false
    foreach ($e in $entries) {
      if ($e.Trim().Trim('"').TrimEnd('\', '/') -eq $normTarget) {
        $alreadyOnPath = $true
        break
      }
    }
    if (-not $alreadyOnPath) {
      $newPath = if ($userPath.Trim()) { "$InstallDir;$userPath" } else { $InstallDir }
      [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
      Write-Host "✓ added $InstallDir to PATH (restart your terminal)"
    }
  }

  # ── Optional managed startup (auto-start at sign-in + keep-alive) ───────────
  # Registered through the binary itself (one definition — a per-user Task
  # Scheduler task with a LogonTrigger + restart-on-failure). No admin required;
  # a clean quit stays down, only a crash restarts. Activates at next sign-in.
  if ($env:GROWTHER_INSTALL_SERVICE -eq "1") {
    & "$InstallDir\growther.exe" service install | Out-Null
    if ($LASTEXITCODE -eq 0) {
      Write-Host "✓ managed startup enabled (auto-start + keep-alive) — manage in Settings > System"
    } else {
      Write-Host "⚠ could not enable managed startup (run 'growther service install' to retry)" -ForegroundColor Yellow
    }
  }

  Write-Host ""
  Write-Host "✓ Growther.ai C5 installed." -ForegroundColor Green
  Write-Host ""
  Write-Host "Next steps:"
  Write-Host "  1. Start it:  growther   (opens your browser to activate - sign in, then start a trial or pick a plan)"
  Write-Host "     Or activate explicitly:  growther activate"
  Write-Host "  2. Update later:  growther update"
  Write-Host ""
  Write-Host "  Air-gapped / manual seed:  Add-Content `"$GrowtherHome\.env`" 'GROWTHER_C5_LICENSE_SEED=<your-seed>'"
} finally {
  Remove-Item -Recurse -Force $tmp
}
