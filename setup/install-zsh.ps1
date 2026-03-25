# ── install-zsh.ps1 ──────────────────────────────────────────────────────────
# Installs zsh, oh-my-zsh, spaceship-prompt and plugins on Windows.
#
# Strategy (in order):
#   1. WSL (recommended) — runs install-zsh.sh inside the default WSL distro.
#   2. Scoop (native)    — installs zsh via Scoop for MSYS2/native use.
#
# Requirements:
#   - PowerShell 5.1+ (built-in) or PowerShell 7+
#   - WSL with a Linux distro  (preferred)  OR  Scoop  (https://scoop.sh)
#
# Run in PowerShell:
#   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#   .\install-zsh.ps1
#   .\install-zsh.ps1 --no-chsh    # skip setting zsh as default shell in WSL
# ─────────────────────────────────────────────────────────────────────────────

param(
    [switch]$NoChsh
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── helpers ───────────────────────────────────────────────────────────────────
function Write-Info   { param($msg) Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Ok     { param($msg) Write-Host "[OK]    $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-Err    { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }
function Write-Header { param($msg) Write-Host "`n== $msg ==" -ForegroundColor Blue }

function Command-Exists { param($cmd) return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

# Convert a Windows absolute path to a WSL /mnt/<drive>/... path
function ConvertTo-WslPath {
    param([string]$WinPath)
    $drive = $WinPath.Substring(0, 1).ToLower()
    $rest  = $WinPath.Substring(2) -replace '\\', '/'
    return "/mnt/$drive$rest"
}

# ── banner ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ███████╗███████╗██╗  ██╗" -ForegroundColor Blue
Write-Host "  ╚══███╔╝██╔════╝██║  ██║" -ForegroundColor Blue
Write-Host "    ███╔╝ ███████╗███████║" -ForegroundColor Blue
Write-Host "   ███╔╝  ╚════██║██╔══██║" -ForegroundColor Blue
Write-Host "  ███████╗███████║██║  ██║" -ForegroundColor Blue
Write-Host "  ╚══════╝╚══════╝╚═╝  ╚═╝" -ForegroundColor Blue
Write-Host "  Zsh + oh-my-zsh + spaceship Installer  (Windows)`n" -ForegroundColor Blue

$scriptDir = $PSScriptRoot

# ── Strategy 1: WSL ──────────────────────────────────────────────────────────
Write-Header "Checking for WSL"

if (Command-Exists wsl) {
    $distros = (wsl --list --quiet 2>$null) -join "" -replace "`0", ""
    if ($LASTEXITCODE -eq 0 -and $distros.Trim()) {
        Write-Ok "WSL detected. Delegating to install-zsh.sh inside WSL."
        Write-Info "This is the recommended path — full Linux zsh environment."

        $shScript = Join-Path $scriptDir "install-zsh.sh"
        $zshrcSrc = Join-Path $scriptDir "zshrc"

        if (-not (Test-Path $shScript)) {
            Write-Err "install-zsh.sh not found at $shScript"
            Write-Err "Make sure you are running this from the setup/ directory."
            exit 1
        }

        $wslScript = ConvertTo-WslPath $shScript
        $wslZshrc  = ConvertTo-WslPath $zshrcSrc

        $chshFlag = if ($NoChsh) { "--no-chsh" } else { "" }

        Write-Info "Running: wsl bash `"$wslScript`" $chshFlag"
        wsl bash "$wslScript" $chshFlag

        if ($LASTEXITCODE -eq 0) {
            Write-Ok "Zsh setup complete inside WSL."
            Write-Host ""
            Write-Host "  Open your WSL terminal to start using zsh + spaceship." -ForegroundColor Green
            Write-Host "  Or launch: wsl" -ForegroundColor White
        } else {
            Write-Err "install-zsh.sh exited with code $LASTEXITCODE. Check output above."
            exit $LASTEXITCODE
        }
        exit 0
    } else {
        Write-Warn "wsl.exe found but no Linux distro is registered."
        Write-Info "Install a distro from the Microsoft Store (e.g. Ubuntu), then re-run."
    }
} else {
    Write-Warn "WSL not found."
}

# ── Strategy 2: Scoop (native Windows zsh) ───────────────────────────────────
Write-Header "Falling back to Scoop (native Windows zsh)"
Write-Warn "Native Windows zsh is limited. WSL is strongly recommended for the full experience."

# Install Scoop if missing
if (-not (Command-Exists scoop)) {
    Write-Info "Scoop not found. Installing Scoop…"
    try {
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        # Reload PATH so scoop is available
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + $env:Path
    } catch {
        Write-Err "Failed to install Scoop: $_"
        Write-Host ""
        Write-Host "  Manual options:" -ForegroundColor Yellow
        Write-Host "  1. Install WSL:  https://learn.microsoft.com/en-us/windows/wsl/install"
        Write-Host "  2. Install Scoop: https://scoop.sh"
        Write-Host "  3. Then re-run this script."
        exit 1
    }
}

Write-Ok "Scoop $(scoop --version 2>&1 | Select-Object -First 1) found."

# ── Install zsh via Scoop ─────────────────────────────────────────────────────
Write-Header "1 · zsh"

$zshCheck = scoop list zsh 2>&1
if ($zshCheck -match "zsh") {
    Write-Ok "zsh already installed via Scoop."
} else {
    Write-Info "Installing zsh via Scoop…"
    scoop install zsh
    Write-Ok "zsh installed."
}

# Add Scoop shims to PATH for this session
$scoopShims = "$env:USERPROFILE\scoop\shims"
if (Test-Path $scoopShims) {
    $env:Path = "$scoopShims;$env:Path"
}

# ── Locate zsh binary ─────────────────────────────────────────────────────────
$zshBin = (Get-Command zsh -ErrorAction SilentlyContinue)?.Source
if (-not $zshBin) {
    $zshBin = "$env:USERPROFILE\scoop\shims\zsh.exe"
}

if (-not (Test-Path $zshBin)) {
    Write-Err "zsh binary not found after Scoop install. Exiting."
    exit 1
}

Write-Ok "zsh binary: $zshBin"

# ── Install oh-my-zsh, plugins, spaceship inside zsh ─────────────────────────
Write-Header "2-5 · oh-my-zsh + plugins + spaceship"

$omzDir = "$env:USERPROFILE\.oh-my-zsh"

if (Test-Path $omzDir) {
    Write-Ok "oh-my-zsh already installed at $omzDir"
} else {
    Write-Info "Installing oh-my-zsh…"
    $omzScript = [System.IO.Path]::GetTempFileName() + ".sh"
    Invoke-WebRequest `
        "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" `
        -OutFile $omzScript -UseBasicParsing
    & $zshBin -c "RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh '$($omzScript -replace '\\','/')'"
    Remove-Item $omzScript -ErrorAction SilentlyContinue
    Write-Ok "oh-my-zsh installed."
}

$zshCustom = "$omzDir\custom"

# zsh-autosuggestions
$target = "$zshCustom\plugins\zsh-autosuggestions"
if (Test-Path $target) {
    Write-Ok "zsh-autosuggestions already installed."
} else {
    Write-Info "Cloning zsh-autosuggestions…"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $target
    Write-Ok "zsh-autosuggestions installed."
}

# zsh-syntax-highlighting
$target = "$zshCustom\plugins\zsh-syntax-highlighting"
if (Test-Path $target) {
    Write-Ok "zsh-syntax-highlighting already installed."
} else {
    Write-Info "Cloning zsh-syntax-highlighting…"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting $target
    Write-Ok "zsh-syntax-highlighting installed."
}

# spaceship-prompt
$spaceshipDir  = "$zshCustom\themes\spaceship-prompt"
$spaceshipLink = "$zshCustom\themes\spaceship.zsh-theme"
if (Test-Path $spaceshipDir) {
    Write-Ok "spaceship-prompt already installed."
} else {
    Write-Info "Cloning spaceship-prompt…"
    git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git $spaceshipDir
    # On Windows we copy instead of symlink to avoid privilege requirements
    $spaceSrc = "$spaceshipDir\spaceship.zsh-theme"
    if (Test-Path $spaceSrc) {
        Copy-Item $spaceSrc $spaceshipLink -Force
    }
    Write-Ok "spaceship-prompt installed."
}

# ── Deploy .zshrc ─────────────────────────────────────────────────────────────
Write-Header "6 · .zshrc"

$zshrcSrc = Join-Path $scriptDir "zshrc"
$zshrcDst = "$env:USERPROFILE\.zshrc"

if (-not (Test-Path $zshrcSrc)) {
    Write-Warn "setup\zshrc not found — skipping .zshrc deploy."
    Write-Warn "Copy setup\zshrc to $zshrcDst manually."
} else {
    if (Test-Path $zshrcDst) {
        $ts = Get-Date -Format "yyyyMMdd_HHmmss"
        $backup = "$zshrcDst.bak.$ts"
        Copy-Item $zshrcDst $backup
        Write-Warn "Existing .zshrc backed up to $backup"
    }
    Copy-Item $zshrcSrc $zshrcDst -Force
    Write-Ok ".zshrc deployed to $zshrcDst"
}

# ── Summary ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "== Zsh setup complete! ==" -ForegroundColor Green
Write-Host ""
Write-Host "  Installed / verified:" -ForegroundColor White
if (Command-Exists zsh)             { Write-Host "  [OK] zsh                    installed" -ForegroundColor Green }
if (Test-Path $omzDir)              { Write-Host "  [OK] oh-my-zsh              installed" -ForegroundColor Green }
if (Test-Path "$zshCustom\plugins\zsh-autosuggestions") {
    Write-Host "  [OK] zsh-autosuggestions    installed" -ForegroundColor Green }
if (Test-Path "$zshCustom\plugins\zsh-syntax-highlighting") {
    Write-Host "  [OK] zsh-syntax-highlighting installed" -ForegroundColor Green }
if (Test-Path "$zshCustom\themes\spaceship-prompt") {
    Write-Host "  [OK] spaceship-prompt        installed" -ForegroundColor Green }
if (Test-Path $zshrcDst) {
    Write-Host "  [OK] $zshrcDst deployed" -ForegroundColor Green }
Write-Host ""
Write-Host "  Run 'zsh' to start your new shell." -ForegroundColor White
Write-Host ""
Write-Host "  Note: For the best experience, use WSL instead:" -ForegroundColor Yellow
Write-Host "    https://learn.microsoft.com/en-us/windows/wsl/install" -ForegroundColor White
Write-Host ""
