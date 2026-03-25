# ── install.ps1 ───────────────────────────────────────────────────────────────
# Installs all system-level dependencies for ls-devs/nvim on Windows.
#
# Requirements:
#   - Windows 10 1809+ or Windows 11
#   - PowerShell 5.1+ (built-in) or PowerShell 7+
#   - winget  (comes with "App Installer" from the Microsoft Store)
#
# Run in PowerShell (no admin required for most steps):
#   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#   .\install.ps1
#
# After running, open Neovim and execute:
#   :Lazy install | :MasonToolsInstall | :TSUpdate | :checkhealth
# ─────────────────────────────────────────────────────────────────────────────

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── helpers ───────────────────────────────────────────────────────────────────
function Write-Info    { param($msg) Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Ok      { param($msg) Write-Host "[OK]    $msg" -ForegroundColor Green }
function Write-Warn    { param($msg) Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-Err     { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }
function Write-Header  { param($msg) Write-Host "`n== $msg ==" -ForegroundColor Blue }

function Command-Exists { param($cmd) return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

# Refresh the current session's PATH from the machine + user env variables
function Refresh-Path {
    $machine = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $user    = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
}

# Fetch the latest release tag for a GitHub repo (e.g. "v0.12.0")
function Get-GithubLatestTag {
    param([string]$Repo)
    $resp = Invoke-RestMethod "https://api.github.com/repos/$Repo/releases/latest"
    return $resp.tag_name
}

# Install a package with winget, skipping if already installed
function Install-Winget {
    param([string]$Id, [string]$Label)
    Write-Info "Installing $Label ($Id)…"
    winget install --id $Id -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    Write-Ok "$Label installed."
}

# ── check prerequisites ───────────────────────────────────────────────────────
Write-Host "`n  ls-devs/nvim — Windows Installer`n" -ForegroundColor Blue

# winget check
if (-not (Command-Exists winget)) {
    Write-Err "winget not found."
    Write-Host "  Install 'App Installer' from the Microsoft Store, then re-run this script."
    Write-Host "  Direct link: https://apps.microsoft.com/detail/9nblggh4nns1"
    exit 1
}
Write-Ok "winget $(winget --version) found."

# Admin check (informational only — most installs work without it)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warn "Not running as Administrator — some installers may prompt for UAC elevation."
}

# ── 1. Core tools ─────────────────────────────────────────────────────────────
Write-Header "1 · Core tools"

$corePackages = @(
    @{ Id = "Git.Git";             Label = "Git"           },
    @{ Id = "Neovim.Neovim";       Label = "Neovim"        },
    @{ Id = "Kitware.CMake";       Label = "CMake"         },
    @{ Id = "GnuWin32.Make";       Label = "make"          },
    @{ Id = "LLVM.LLVM";           Label = "LLVM/Clang"    },  # clangd, clang-format
    @{ Id = "SQLite.SQLite";       Label = "SQLite"        }
)

foreach ($pkg in $corePackages) {
    Install-Winget -Id $pkg.Id -Label $pkg.Label
}

# ── 2. Language runtimes ──────────────────────────────────────────────────────
Write-Header "2 · Language runtimes"

Install-Winget -Id "OpenJS.NodeJS.LTS"            -Label "Node.js LTS"
Install-Winget -Id "Python.Python.3"              -Label "Python 3"
Install-Winget -Id "GoLang.Go"                    -Label "Go"
Install-Winget -Id "EclipseAdoptium.Temurin.21.JDK" -Label "Java 21 (Temurin)"

Refresh-Path

# ── 3. CLI tools ──────────────────────────────────────────────────────────────
Write-Header "3 · CLI tools"

$cliPackages = @(
    @{ Id = "BurntSushi.ripgrep.MSVC"; Label = "ripgrep"            },
    @{ Id = "sharkdp.fd";              Label = "fd"                  },
    @{ Id = "junegunn.fzf";            Label = "fzf"                 },
    @{ Id = "JesseDuffield.lazygit";   Label = "lazygit"             },
    @{ Id = "koalaman.shellcheck";     Label = "shellcheck"          },
    @{ Id = "GitHub.cli";              Label = "GitHub CLI (gh)"     },
    @{ Id = "ImageMagick.ImageMagick"; Label = "ImageMagick"         },
    @{ Id = "jqlang.jq";               Label = "jq"                  }
)

foreach ($pkg in $cliPackages) {
    Install-Winget -Id $pkg.Id -Label $pkg.Label
}

Refresh-Path

# ── 4. Rust ───────────────────────────────────────────────────────────────────
Write-Header "4 · Rust + Cargo"
# blink.cmp requires `cargo build --release`

if (Command-Exists cargo) {
    Write-Ok "Cargo $(cargo --version) already installed."
} else {
    Write-Info "Installing Rust via rustup…"
    Install-Winget -Id "Rustlang.Rustup" -Label "Rustup"
    Refresh-Path
    # rustup installs the stable toolchain by default; ensure rustfmt is present
    if (Command-Exists rustup) {
        rustup component add rustfmt 2>&1 | Out-Null
    }
    Write-Ok "Rust installed."
}

# ── 5. pnpm + Node.js global packages ────────────────────────────────────────
Write-Header "5 · pnpm + npm globals"
# live-server.nvim build step: `pnpm add -g live-server`
# neovim npm package: Node.js remote plugin provider for Neovim

if (Command-Exists pnpm) {
    Write-Ok "pnpm $(pnpm --version) already installed."
} else {
    Write-Info "Installing pnpm via npm…"
    npm install -g pnpm 2>&1 | Out-Null
    Write-Ok "pnpm installed."
}

Write-Info "Installing npm global: neovim provider…"
npm install -g neovim 2>&1 | Out-Null
Write-Ok "neovim npm provider installed."

# ── 6. Python packages ────────────────────────────────────────────────────────
Write-Header "6 · Python packages"

$pynvimCheck = python -c "import pynvim" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Ok "pynvim already installed."
} else {
    Write-Info "Installing pynvim…"
    python -m pip install --user pynvim 2>&1 | Out-Null
    Write-Ok "pynvim installed."
}

# ── 7. win32yank (clipboard for WSL users) ────────────────────────────────────
Write-Header "7 · win32yank (clipboard bridge for WSL)"
# When using Neovim inside WSL, win32yank.exe on the Windows side bridges the
# clipboard. The Neovim config checks /mnt/c/tools/win32yank.exe from WSL.

$win32yankDir  = "C:\tools"
$win32yankPath = "$win32yankDir\win32yank.exe"

if (Test-Path $win32yankPath) {
    Write-Ok "win32yank already installed at $win32yankPath."
} else {
    Write-Info "Downloading win32yank…"
    try {
        $tag = Get-GithubLatestTag "equim-org/win32yank"
        $url = "https://github.com/equim-org/win32yank/releases/download/$tag/win32yank-x64.zip"
        $tmp = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory $_ }
        Invoke-WebRequest $url -OutFile "$tmp\win32yank.zip" -UseBasicParsing
        Expand-Archive "$tmp\win32yank.zip" -DestinationPath $tmp -Force
        if (-not (Test-Path $win32yankDir)) { New-Item -ItemType Directory -Path $win32yankDir | Out-Null }
        Copy-Item "$tmp\win32yank.exe" $win32yankPath -Force
        Remove-Item $tmp -Recurse -Force
        Write-Ok "win32yank installed to $win32yankPath"
        Write-Info "In WSL, the config will find it at /mnt/c/tools/win32yank.exe"

        # Add C:\tools to User PATH if not already there
        $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*C:\tools*") {
            [System.Environment]::SetEnvironmentVariable("Path", "$userPath;C:\tools", "User")
            Write-Info "Added C:\tools to user PATH."
        }
    } catch {
        Write-Warn "Could not download win32yank: $_"
        Write-Warn "Download manually from: https://github.com/equim-org/win32yank/releases"
    }
}

# ── 8. FiraCode Nerd Font ─────────────────────────────────────────────────────
Write-Header "8 · FiraCode Nerd Font"

$fontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
$fontCheck = Get-ChildItem $fontDir -Filter "*FiraCode*Nerd*" -ErrorAction SilentlyContinue
if ($fontCheck) {
    Write-Ok "FiraCode Nerd Font already installed."
} else {
    Write-Info "Downloading FiraCode Nerd Font…"
    try {
        $tag = Get-GithubLatestTag "ryanoasis/nerd-fonts"
        $url = "https://github.com/ryanoasis/nerd-fonts/releases/download/$tag/FiraCode.tar.xz"
        $tmp = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory $_ }

        Write-Info "Downloading from $url…"
        Invoke-WebRequest $url -OutFile "$tmp\FiraCode.tar.xz" -UseBasicParsing

        # PowerShell doesn't natively extract .tar.xz — use tar.exe (available on Win10 1803+)
        tar -xJf "$tmp\FiraCode.tar.xz" -C "$tmp" 2>&1 | Out-Null

        if (-not (Test-Path $fontDir)) { New-Item -ItemType Directory -Path $fontDir | Out-Null }

        # Copy fonts (skip Windows-specific variants)
        Get-ChildItem "$tmp" -Filter "*.ttf" -Recurse |
            Where-Object { $_.Name -notmatch "Windows" } |
            ForEach-Object {
                Copy-Item $_.FullName "$fontDir\" -Force
            }

        # Register each font in the user registry so Windows recognises it
        $regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        Get-ChildItem "$fontDir" -Filter "*FiraCode*Nerd*.ttf" |
            ForEach-Object {
                $name = $_.BaseName + " (TrueType)"
                New-ItemProperty -Path $regPath -Name $name -Value $_.Name `
                    -PropertyType String -Force | Out-Null
            }

        Remove-Item $tmp -Recurse -Force
        Write-Ok "FiraCode Nerd Font installed to $fontDir"
        Write-Info "Set your terminal font to 'FiraCode Nerd Font' to see icons."
    } catch {
        Write-Warn "Could not install FiraCode Nerd Font: $_"
        Write-Warn "Download manually from: https://www.nerdfonts.com/font-downloads"
    }
}

# ── post-install: Neovim headless setup ──────────────────────────────────────
Write-Header "· Neovim: plugins, Mason tools, treesitter"

# On Windows, Neovim config lives at %LOCALAPPDATA%\nvim
$nvimConfigPath = "$env:LOCALAPPDATA\nvim\init.lua"

if (Test-Path $nvimConfigPath) {
    Refresh-Path

    Write-Info "Installing plugins (Lazy.nvim) — includes blink.cmp Rust build…"
    nvim --headless "+Lazy! install" +qa 2>&1 | Select-Object -Last 5

    Write-Info "Installing Mason tools (LSPs, formatters, linters, debuggers)…"
    Write-Info "This may take 10-20 minutes on first run."
    nvim --headless "+MasonToolsInstallSync" +qa 2>&1 |
        Where-Object { $_ -match "installed|updated|failed|error" } |
        Select-Object -Last 20

    Write-Info "Installing treesitter parsers…"
    nvim --headless "+TSUpdate" +qa 2>&1 | Select-Object -Last 3

    Write-Ok "Neovim headless setup complete."
} else {
    Write-Warn "Neovim config not found at $env:LOCALAPPDATA\nvim — skipping headless setup."
    Write-Warn "Clone the config there, then re-run or open Neovim manually."
}

# ── post-install: GitHub auth + Copilot CLI ───────────────────────────────────
Write-Header "· GitHub authentication + Copilot CLI"

if (Command-Exists gh) {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Ok "GitHub CLI already authenticated."
    } else {
        Write-Info "Opening GitHub login flow (a browser window will open)…"
        try {
            gh auth login
        } catch {
            Write-Warn "GitHub auth skipped. Run 'gh auth login' later."
        }
    }

    # Install Copilot CLI extension
    $extensions = gh extension list 2>$null
    if ($extensions -match "copilot") {
        Write-Ok "gh copilot extension already installed."
    } else {
        Write-Info "Installing gh copilot extension…"
        gh extension install github/gh-copilot
        Write-Ok "gh copilot extension installed."
    }
} else {
    Write-Warn "gh CLI not found — skipping GitHub setup."
}

# ── summary ───────────────────────────────────────────────────────────────────
Refresh-Path
Write-Host ""
Write-Host "== All done! ==" -ForegroundColor Green
Write-Host ""
Write-Host "  Installed / verified:"
if (Command-Exists nvim)    { Write-Host "  [OK] Neovim     $(nvim --version | Select-Object -First 1)" -ForegroundColor Green }
if (Command-Exists cargo)   { Write-Host "  [OK] Cargo      $(cargo --version)" -ForegroundColor Green }
if (Command-Exists node)    { Write-Host "  [OK] Node.js    $(node --version)" -ForegroundColor Green }
if (Command-Exists go)      { Write-Host "  [OK] Go         $(go version | ForEach-Object { $_ -replace '.*go(\S+).*','$1' })" -ForegroundColor Green }
if (Command-Exists gh)      { Write-Host "  [OK] gh CLI     $(gh --version | Select-Object -First 1)" -ForegroundColor Green }
if (Command-Exists lazygit) { Write-Host "  [OK] lazygit    $(lazygit --version 2>&1 | Select-Object -First 1)" -ForegroundColor Green }
if (Command-Exists pnpm)    { Write-Host "  [OK] pnpm       $(pnpm --version)" -ForegroundColor Green }
if (Command-Exists rg)      { Write-Host "  [OK] ripgrep    $(rg --version | Select-Object -First 1)" -ForegroundColor Green }
Write-Host ""
Write-Host "  [OK] Neovim plugins installed (Lazy.nvim)" -ForegroundColor Green
Write-Host "  [OK] LSPs / formatters / linters / debuggers installed (Mason)" -ForegroundColor Green
Write-Host "  [OK] Treesitter parsers installed" -ForegroundColor Green
Write-Host "  [OK] GitHub Copilot CLI configured" -ForegroundColor Green
Write-Host ""
Write-Host "  Open Neovim and run :checkhealth to verify everything is wired correctly." -ForegroundColor White
Write-Host ""
Write-Host "  Note: Restart your terminal to reload PATH." -ForegroundColor Yellow
Write-Host ""
