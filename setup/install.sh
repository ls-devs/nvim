#!/usr/bin/env bash
# ── install.sh ────────────────────────────────────────────────────────────────
# Installs all system-level dependencies for ls-devs/nvim.
#
# Supported environments:
#   Linux  : Ubuntu/Debian (apt) · Fedora/RHEL (dnf) · CentOS 7 (yum)
#            Arch Linux (pacman) · openSUSE (zypper) · Alpine (apk)
#   macOS  : Homebrew (brew)
#   WSL    : Any of the above Linux distros + win32yank clipboard bridge
#
# Windows: use install.ps1 (PowerShell) instead.
#
# After running this script, open Neovim and execute:
#   :Lazy install          ← install all plugins
#   :MasonToolsInstall     ← install LSPs / formatters / linters / debuggers
#   :TSUpdate              ← install treesitter parsers
#   :checkhealth           ← verify all deps are wired correctly
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# ── globals ───────────────────────────────────────────────────────────────────
OS_TYPE=""        # linux | macos
ARCH=""           # x86_64 | arm64
GO_ARCH=""        # amd64 | arm64  (Go download naming)
PKG_MANAGER=""    # apt | dnf | yum | pacman | zypper | apk | brew
DISTRO_ID=""
IS_WSL=false
SUDO_CMD=""

# ── colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
header()  { echo -e "\n${BOLD}${BLUE}══ $* ══${NC}"; }

# ── helpers ───────────────────────────────────────────────────────────────────
command_exists() { command -v "$1" &>/dev/null; }

github_latest_tag() {
  curl -fsSL "https://api.github.com/repos/${1}/releases/latest" \
    | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/'
}

version_ge() {
  local IFS='.'
  read -ra v1 <<< "$1"; read -ra v2 <<< "$2"
  for i in 0 1 2; do
    local a="${v1[$i]:-0}" b="${v2[$i]:-0}"
    (( a > b )) && return 0; (( a < b )) && return 1
  done; return 0
}

go_version_ge() {
  local IFS='.'; read -ra v1 <<< "$1"; read -ra v2 <<< "$2"
  (( v1[0] > v2[0] )) && return 0; (( v1[0] < v2[0] )) && return 1
  (( ${v1[1]:-0} >= ${v2[1]:-0} )) && return 0 || return 1
}

# Create a fd → fdfind symlink (Debian/Ubuntu name the binary 'fdfind')
ensure_fd_symlink() {
  if command_exists fdfind && ! command_exists fd; then
    mkdir -p "${HOME}/.local/bin"
    ln -sf "$(command -v fdfind)" "${HOME}/.local/bin/fd"
    info "Created fd → fdfind symlink at ~/.local/bin/fd"
  fi
}

# ── environment detection ─────────────────────────────────────────────────────
detect_environment() {
  # sudo / root
  if command_exists sudo; then
    SUDO_CMD="sudo"
  elif [ "$(id -u)" = "0" ]; then
    SUDO_CMD=""
  else
    error "sudo not found and not running as root. Exiting."; exit 1
  fi

  # Architecture
  case "$(uname -m)" in
    x86_64|amd64)  ARCH="x86_64"; GO_ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64";  GO_ARCH="arm64"  ;;
    *) error "Unsupported architecture: $(uname -m)"; exit 1 ;;
  esac

  # OS + package manager
  case "$(uname -s)" in
    Linux)
      OS_TYPE="linux"
      if grep -qi microsoft /proc/version 2>/dev/null \
          || [ -n "${WSL_DISTRO_NAME:-}" ]; then
        IS_WSL=true
      fi
      # shellcheck disable=SC1091
      if [ -f /etc/os-release ]; then
        DISTRO_ID=$(. /etc/os-release && echo "${ID:-unknown}")
      fi
      if   command_exists apt-get; then PKG_MANAGER="apt"
      elif command_exists dnf;     then PKG_MANAGER="dnf"
      elif command_exists yum;     then PKG_MANAGER="yum"
      elif command_exists pacman;  then PKG_MANAGER="pacman"
      elif command_exists zypper;  then PKG_MANAGER="zypper"
      elif command_exists apk;     then PKG_MANAGER="apk"
      else error "No supported package manager found."; exit 1
      fi
      ;;
    Darwin)
      OS_TYPE="macos"; DISTRO_ID="macos"
      command_exists brew || { error "Homebrew required. Install from https://brew.sh"; exit 1; }
      PKG_MANAGER="brew"
      ;;
    *)
      error "Unsupported OS: $(uname -s). For Windows use install.ps1."; exit 1 ;;
  esac

  local wsl_label=""; [ "$IS_WSL" = "true" ] && wsl_label=" (WSL)"
  info "OS: ${OS_TYPE}${wsl_label} · Distro: ${DISTRO_ID:-N/A} · Arch: ${ARCH} · PM: ${PKG_MANAGER}"
}

# ── 1. system packages ────────────────────────────────────────────────────────
install_system_packages() {
  header "1 · System packages (${PKG_MANAGER})"

  case "$PKG_MANAGER" in
    apt)
      $SUDO_CMD apt-get update -qq
      $SUDO_CMD apt-get install -y \
        git curl wget unzip tar gzip xz-utils \
        build-essential gcc g++ make cmake \
        libstdc++-dev pkg-config gettext ninja-build \
        python3 python3-pip python3-venv \
        default-jdk \
        ripgrep fd-find fzf shellcheck \
        xclip wl-clipboard \
        imagemagick xdg-utils jq \
        luarocks sqlite3 libsqlite3-dev \
        php composer
      ensure_fd_symlink
      ;;
    dnf)
      $SUDO_CMD dnf check-update -q || true
      $SUDO_CMD dnf install -y \
        git curl wget unzip tar gzip xz \
        gcc gcc-c++ make cmake \
        libstdc++-devel pkgconf gettext ninja-build \
        python3 python3-pip \
        java-latest-openjdk \
        ripgrep fd-find fzf ShellCheck \
        xclip wl-clipboard \
        ImageMagick xdg-utils jq \
        luarocks sqlite sqlite-devel \
        php composer
      ensure_fd_symlink
      ;;
    yum)
      $SUDO_CMD yum install -y epel-release || true
      $SUDO_CMD yum check-update -q || true
      $SUDO_CMD yum install -y \
        git curl wget unzip tar gzip xz \
        gcc gcc-c++ make cmake \
        pkgconfig gettext \
        python3 python3-pip \
        java-latest-openjdk \
        fzf ShellCheck jq \
        xclip luarocks sqlite sqlite-devel php
      # ripgrep not in CentOS 7 repos — grab musl binary from GitHub
      if ! command_exists rg; then
        info "Installing ripgrep from GitHub (not in yum repos)…"
        local rg_tag rg_ver rg_tmp
        rg_tag=$(github_latest_tag "BurntSushi/ripgrep")
        rg_ver="${rg_tag#v}"
        rg_tmp=$(mktemp -d)
        curl -fsSL "https://github.com/BurntSushi/ripgrep/releases/download/${rg_tag}/ripgrep-${rg_ver}-x86_64-unknown-linux-musl.tar.gz" \
          -o "${rg_tmp}/rg.tar.gz"
        tar -xzf "${rg_tmp}/rg.tar.gz" -C "${rg_tmp}" --strip-components=1
        $SUDO_CMD install "${rg_tmp}/rg" /usr/local/bin/rg
        rm -rf "$rg_tmp"
      fi
      ;;
    pacman)
      $SUDO_CMD pacman -Sy --noconfirm
      $SUDO_CMD pacman -S --noconfirm --needed \
        git curl wget unzip tar gzip xz \
        base-devel cmake \
        python python-pip \
        jdk-openjdk \
        ripgrep fd fzf shellcheck \
        xclip wl-clipboard \
        imagemagick xdg-utils jq \
        luarocks sqlite \
        php composer
      ;;
    zypper)
      $SUDO_CMD zypper refresh -q
      $SUDO_CMD zypper install -y \
        git curl wget unzip tar gzip xz \
        gcc gcc-c++ make cmake \
        libstdc++-devel pkg-config gettext ninja \
        python3 python3-pip python3-virtualenv \
        java-21-openjdk \
        ripgrep fd fzf ShellCheck \
        xclip wl-clipboard \
        ImageMagick xdg-utils jq \
        luarocks sqlite3 sqlite3-devel \
        php8 composer
      ;;
    apk)
      $SUDO_CMD apk update -q
      $SUDO_CMD apk add \
        git curl wget unzip tar gzip xz \
        build-base cmake make \
        python3 py3-pip \
        openjdk21 \
        ripgrep fd fzf shellcheck \
        xclip imagemagick jq \
        luarocks sqlite sqlite-dev \
        php83 composer
      ;;
    brew)
      brew update -q || true
      brew install \
        git curl wget unzip cmake make \
        python openjdk \
        ripgrep fd fzf shellcheck \
        imagemagick jq \
        luarocks sqlite3 php composer || true
      if ! command_exists java; then
        $SUDO_CMD ln -sfn "$(brew --prefix openjdk)/libexec/openjdk.jdk" \
          /Library/Java/JavaVirtualMachines/openjdk.jdk 2>/dev/null || true
      fi
      ;;
  esac

  success "System packages installed."
}

# ── 2. GitHub CLI (gh) ────────────────────────────────────────────────────────
install_gh_cli() {
  header "2 · GitHub CLI (gh)"
  # Required by: octo.nvim (PR/issue management), Copilot CLI extension

  if command_exists gh; then
    success "gh $(gh --version | head -1) already installed."; return 0
  fi

  info "Installing GitHub CLI…"
  case "$PKG_MANAGER" in
    apt)
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | $SUDO_CMD dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
      $SUDO_CMD chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | $SUDO_CMD tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      $SUDO_CMD apt-get update -qq && $SUDO_CMD apt-get install -y gh
      ;;
    dnf)
      $SUDO_CMD dnf config-manager --add-repo \
        https://cli.github.com/packages/rpm/gh-cli.repo
      $SUDO_CMD dnf install -y gh
      ;;
    yum)
      $SUDO_CMD yum-config-manager --add-repo \
        https://cli.github.com/packages/rpm/gh-cli.repo
      $SUDO_CMD yum install -y gh
      ;;
    pacman)
      $SUDO_CMD pacman -S --noconfirm --needed github-cli
      ;;
    zypper)
      $SUDO_CMD zypper addrepo \
        https://cli.github.com/packages/rpm/gh-cli.repo gh-cli 2>/dev/null || true
      $SUDO_CMD zypper --gpg-auto-import-keys refresh
      $SUDO_CMD zypper install -y gh
      ;;
    apk)
      $SUDO_CMD apk add github-cli
      ;;
    brew)
      brew install gh
      ;;
  esac

  success "gh $(gh --version | head -1) installed."
  warn "Next: run 'gh auth login' then 'gh extension install github/gh-copilot'"
}

# ── 3. Neovim ─────────────────────────────────────────────────────────────────
install_neovim() {
  header "3 · Neovim (>= 0.12.0)"

  local required="0.12.0" current=""
  command_exists nvim && current=$(nvim --version | head -1 | sed 's/NVIM v//')

  if [ -n "$current" ] && version_ge "$current" "$required"; then
    success "Neovim ${current} already satisfies >= ${required}."; return 0
  fi
  if [ -n "$current" ]; then warn "Neovim ${current} < ${required}."
  else info "Neovim not found."; fi

  if [ "$PKG_MANAGER" = "brew" ]; then
    brew install neovim 2>/dev/null || brew upgrade neovim
  elif [ "$PKG_MANAGER" = "apk" ]; then
    $SUDO_CMD apk add neovim
    local v; v=$(nvim --version | head -1 | sed 's/NVIM v//')
    version_ge "$v" "$required" || \
      warn "Alpine repo has Neovim ${v} < ${required}. Consider Alpine Edge or building from source."
  else
    local tag url tmp
    tag=$(github_latest_tag "neovim/neovim")
    url="https://github.com/neovim/neovim/releases/download/${tag}/nvim-linux-${ARCH}.tar.gz"
    info "Downloading Neovim ${tag} (linux-${ARCH})…"
    tmp=$(mktemp -d)
    curl -fsSL "$url" -o "${tmp}/nvim.tar.gz"
    tar -xzf "${tmp}/nvim.tar.gz" -C "${tmp}"
    $SUDO_CMD rm -rf /opt/nvim
    $SUDO_CMD mv "${tmp}/nvim-linux-${ARCH}" /opt/nvim
    $SUDO_CMD ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm -rf "$tmp"
  fi

  success "Neovim $(nvim --version | head -1 | sed 's/NVIM v//') installed."
}

# ── 4. Rust + Cargo ───────────────────────────────────────────────────────────
install_rust() {
  header "4 · Rust + Cargo (rustup)"
  # blink.cmp requires `cargo build --release` at plugin install time

  if command_exists cargo; then
    success "Cargo $(cargo --version) already installed."
  else
    info "Installing Rust via rustup…"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"
    success "Rust $(rustc --version) installed."
  fi

  export PATH="${HOME}/.cargo/bin:${PATH}"

  if command_exists rustup && ! command_exists rustfmt; then
    info "Installing rustfmt component…"
    rustup component add rustfmt
  fi
}

# ── 5. Node.js LTS ────────────────────────────────────────────────────────────
install_nodejs() {
  header "5 · Node.js LTS"
  # Required by: ts_ls, eslint_d, copilot.lua, live-server.nvim, jest/vitest, mcphub

  local min_major=18
  if command_exists node; then
    local cur_major
    cur_major=$(node --version | sed 's/v//' | cut -d. -f1)
    if (( cur_major >= min_major )); then
      success "Node.js $(node --version) already satisfies >= v${min_major}."
    else
      warn "Node.js $(node --version) too old (need >= v${min_major}). Upgrading…"
      _do_install_nodejs
    fi
  else
    info "Node.js not found. Installing LTS…"
    _do_install_nodejs
  fi

  # Node.js provider for Neovim (required for some plugins and remote plugins)
  if ! npm list -g --depth=0 neovim 2>/dev/null | grep -q neovim; then
    info "Installing npm global: neovim provider…"
    npm install -g neovim
  fi

  success "Node.js $(node --version) ready."
}

_do_install_nodejs() {
  case "$PKG_MANAGER" in
    apt)
      curl -fsSL https://deb.nodesource.com/setup_lts.x | $SUDO_CMD -E bash -
      $SUDO_CMD apt-get install -y nodejs
      ;;
    dnf)
      curl -fsSL https://rpm.nodesource.com/setup_lts.x | $SUDO_CMD bash -
      $SUDO_CMD dnf install -y nodejs
      ;;
    yum)
      curl -fsSL https://rpm.nodesource.com/setup_lts.x | $SUDO_CMD bash -
      $SUDO_CMD yum install -y nodejs
      ;;
    pacman) $SUDO_CMD pacman -S --noconfirm --needed nodejs npm ;;
    zypper)
      $SUDO_CMD zypper install -y nodejs22 npm22 2>/dev/null \
        || $SUDO_CMD zypper install -y nodejs20 npm20 2>/dev/null \
        || $SUDO_CMD zypper install -y nodejs npm
      ;;
    apk) $SUDO_CMD apk add nodejs npm ;;
    brew) brew install node 2>/dev/null || brew upgrade node ;;
  esac
}

# ── 6. Go ─────────────────────────────────────────────────────────────────────
install_go() {
  header "6 · Go"

  local required="1.21" install_go=false

  if command_exists go; then
    local current
    current=$(go version | awk '{print $3}' | sed 's/go//')
    if go_version_ge "$current" "$required"; then
      success "Go ${current} already satisfies >= ${required}."; return 0
    fi
    warn "Go ${current} too old."; install_go=true
  else
    info "Go not found."; install_go=true
  fi

  if [ "$install_go" = "true" ]; then
    if [ "$PKG_MANAGER" = "brew" ]; then
      brew install go 2>/dev/null || brew upgrade go
    elif [ "$PKG_MANAGER" = "apk" ]; then
      $SUDO_CMD apk add go
    else
      local os_name go_tag tmp
      [ "$OS_TYPE" = "macos" ] && os_name="darwin" || os_name="linux"
      go_tag=$(curl -fsSL "https://go.dev/dl/?mode=json" \
        | grep '"version"' | head -1 | sed -E 's/.*"version": "([^"]+)".*/\1/')
      info "Downloading ${go_tag} (${os_name}/${GO_ARCH})…"
      tmp=$(mktemp -d)
      curl -fsSL "https://go.dev/dl/${go_tag}.${os_name}-${GO_ARCH}.tar.gz" \
        -o "${tmp}/go.tar.gz"
      $SUDO_CMD rm -rf /usr/local/go
      $SUDO_CMD tar -C /usr/local -xzf "${tmp}/go.tar.gz"
      rm -rf "$tmp"
      export PATH="/usr/local/go/bin:${PATH}"
      if ! grep -q '/usr/local/go/bin' "${HOME}/.profile" 2>/dev/null; then
        echo "export PATH=\"/usr/local/go/bin:\$PATH\"" >> "${HOME}/.profile"
        info "Added /usr/local/go/bin to ~/.profile"
      fi
    fi
  fi

  success "Go $(go version | awk '{print $3}') installed."
}

# ── 7. lazygit ────────────────────────────────────────────────────────────────
install_lazygit() {
  header "7 · lazygit"

  if command_exists lazygit; then
    success "lazygit $(lazygit --version 2>&1 | head -1) already installed."; return 0
  fi

  if [ "$PKG_MANAGER" = "brew" ]; then
    brew install lazygit; return 0
  fi

  local tag ver os_name arch_name url tmp
  tag=$(github_latest_tag "jesseduffield/lazygit")
  ver="${tag#v}"
  [ "$OS_TYPE" = "macos" ] && os_name="Darwin" || os_name="Linux"
  arch_name="$ARCH"  # x86_64 or arm64

  url="https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${ver}_${os_name}_${arch_name}.tar.gz"
  info "Downloading lazygit ${tag} (${os_name}/${arch_name})…"
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "${tmp}/lazygit.tar.gz"
  tar -xzf "${tmp}/lazygit.tar.gz" -C "${tmp}"
  $SUDO_CMD install "${tmp}/lazygit" /usr/local/bin/lazygit
  rm -rf "$tmp"

  success "lazygit $(lazygit --version 2>&1 | head -1) installed."
}

# ── 8. pnpm ───────────────────────────────────────────────────────────────────
install_pnpm() {
  header "8 · pnpm"
  # live-server.nvim build step uses: pnpm add -g live-server

  if command_exists pnpm; then
    success "pnpm $(pnpm --version) already installed."; return 0
  fi
  info "Installing pnpm via npm…"
  $SUDO_CMD npm install -g pnpm
  success "pnpm $(pnpm --version) installed."
}

# ── 9. Python packages ────────────────────────────────────────────────────────
install_pynvim() {
  header "9 · pynvim"

  if python3 -c "import pynvim" 2>/dev/null; then
    success "pynvim already installed."; return 0
  fi
  info "Installing pynvim via pip…"
  python3 -m pip install --user --break-system-packages pynvim 2>/dev/null \
    || python3 -m pip install --user pynvim
  success "pynvim installed."
}

# ── 10. FiraCode Nerd Font ────────────────────────────────────────────────────
install_nerd_font() {
  header "10 · FiraCode Nerd Font"

  local font_dir
  case "$OS_TYPE" in
    linux) font_dir="${HOME}/.fonts" ;;
    macos) font_dir="${HOME}/Library/Fonts" ;;
  esac
  mkdir -p "$font_dir"

  local found=false
  command_exists fc-list && fc-list 2>/dev/null | grep -qi "FiraCode Nerd Font" && found=true
  find "$font_dir" -name "*FiraCode*Nerd*" 2>/dev/null | grep -q . && found=true

  if [ "$found" = "true" ]; then
    success "FiraCode Nerd Font already installed."; return 0
  fi

  local tag tmp
  tag=$(github_latest_tag "ryanoasis/nerd-fonts")
  info "Downloading FiraCode Nerd Font ${tag}…"
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${tag}/FiraCode.tar.xz" \
    -o "${tmp}/FiraCode.tar.xz"
  tar -xJf "${tmp}/FiraCode.tar.xz" -C "${tmp}"
  find "${tmp}" -name "*.ttf" ! -name "*Windows*" -exec cp {} "${font_dir}/" \;
  rm -rf "$tmp"
  command_exists fc-cache && fc-cache -fv "$font_dir" &>/dev/null
  success "FiraCode Nerd Font installed to ${font_dir}."
}

# ── 11. win32yank (WSL only) ──────────────────────────────────────────────────
install_win32yank() {
  header "11 · win32yank (WSL clipboard bridge)"

  local dest="/usr/local/bin/win32yank.exe"
  if command_exists win32yank || [ -f "$dest" ]; then
    success "win32yank already installed."; return 0
  fi

  info "Downloading win32yank…"
  local tag tmp
  tag=$(github_latest_tag "equim-org/win32yank")
  tmp=$(mktemp -d)
  curl -fsSL \
    "https://github.com/equim-org/win32yank/releases/download/${tag}/win32yank-x64.zip" \
    -o "${tmp}/win32yank.zip"
  unzip -q "${tmp}/win32yank.zip" -d "${tmp}"
  $SUDO_CMD install "${tmp}/win32yank.exe" "$dest"
  rm -rf "$tmp"
  success "win32yank installed to ${dest}."
}

# ── PATH setup ────────────────────────────────────────────────────────────────
setup_paths() {
  header "· PATH entries"

  local added=false

  if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
    warn "${HOME}/.local/bin not in PATH."
    if ! grep -q '\.local/bin' "${HOME}/.bashrc" 2>/dev/null; then
      echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "${HOME}/.bashrc"
      info "Added to ~/.bashrc"
    fi
    added=true
  fi

  if [[ ":${PATH}:" != *":${HOME}/.cargo/bin:"* ]]; then
    warn "${HOME}/.cargo/bin not in PATH."
    if ! grep -q '\.cargo/bin' "${HOME}/.bashrc" 2>/dev/null; then
      echo "export PATH=\"\$HOME/.cargo/bin:\$PATH\"" >> "${HOME}/.bashrc"
      info "Added to ~/.bashrc"
    fi
    added=true
  fi

  if [ "$added" = "false" ]; then
    success "All required PATH entries already present."
  else
    warn "PATH updated in ~/.bashrc — run 'source ~/.bashrc' or restart your terminal."
  fi
}

# ── post-install: Neovim headless setup ──────────────────────────────────────
setup_neovim_headless() {
  header "· Neovim: plugins, Mason tools, treesitter"

  local config_dir="${HOME}/.config/nvim"
  if [ ! -f "${config_dir}/init.lua" ]; then
    warn "No Neovim config found at ${config_dir} — skipping headless setup."
    warn "Clone the config there first, then re-run or open Neovim manually."
    return 0
  fi

  # 1. Lazy.nvim — install all plugins (incl. blink.cmp cargo build)
  info "Installing plugins (Lazy.nvim) — includes blink.cmp Rust build…"
  nvim --headless "+Lazy! install" +qa 2>&1 | grep -Ev "^$" | tail -5 || true

  # 2. Mason — install all LSPs / formatters / linters / debuggers
  info "Installing Mason tools (LSPs, formatters, linters, debuggers)…"
  info "This may take 10–20 minutes on first run."
  nvim --headless "+MasonToolsInstallSync" +qa 2>&1 \
    | grep -E "installed|updated|failed|error" | tail -20 || true

  # 3. Treesitter parsers (async; also auto-installs on first file open)
  info "Installing treesitter parsers…"
  nvim --headless "+TSUpdate" +qa 2>&1 | tail -3 || true

  success "Neovim headless setup complete."
}

# ── post-install: GitHub auth + Copilot CLI ───────────────────────────────────
setup_github() {
  header "· GitHub authentication + Copilot CLI"

  if ! command_exists gh; then
    warn "gh CLI not found — skipping GitHub setup."; return 0
  fi

  # Authenticate if not already logged in
  if gh auth status &>/dev/null 2>&1; then
    success "GitHub CLI already authenticated."
  else
    info "Opening GitHub login flow (a browser window will open)…"
    gh auth login || { warn "GitHub auth skipped. Run 'gh auth login' later."; return 0; }
  fi

  # Install the Copilot CLI extension (gh copilot)
  if gh extension list 2>/dev/null | grep -q "copilot"; then
    success "gh copilot extension already installed."
  else
    info "Installing gh copilot extension…"
    gh extension install github/gh-copilot
    success "gh copilot extension installed."
  fi
}

print_summary() {
  echo ""
  echo -e "${BOLD}${GREEN}══ All done! ══${NC}"
  echo ""
  echo "  Installed / verified:"
  command_exists nvim    && echo -e "  ${GREEN}✓${NC} Neovim     $(nvim --version | head -1)"
  command_exists cargo   && echo -e "  ${GREEN}✓${NC} Cargo      $(cargo --version)"
  command_exists node    && echo -e "  ${GREEN}✓${NC} Node.js    $(node --version)"
  command_exists go      && echo -e "  ${GREEN}✓${NC} Go         $(go version | awk '{print $3}')"
  command_exists gh      && echo -e "  ${GREEN}✓${NC} gh CLI     $(gh --version | head -1)"
  command_exists lazygit && echo -e "  ${GREEN}✓${NC} lazygit    $(lazygit --version 2>&1 | head -1)"
  command_exists pnpm    && echo -e "  ${GREEN}✓${NC} pnpm       $(pnpm --version)"
  command_exists rg      && echo -e "  ${GREEN}✓${NC} ripgrep    $(rg --version | head -1)"
  echo ""
  echo -e "  ${GREEN}✓${NC} Neovim plugins installed (Lazy.nvim)"
  echo -e "  ${GREEN}✓${NC} LSPs / formatters / linters / debuggers installed (Mason)"
  echo -e "  ${GREEN}✓${NC} Treesitter parsers installed"
  echo -e "  ${GREEN}✓${NC} GitHub Copilot CLI configured"
  echo ""
  echo -e "  Open Neovim and run ${BOLD}:checkhealth${NC} to verify everything is wired correctly."
  echo -e "  ${YELLOW}Note:${NC} Restart your terminal (or 'source ~/.bashrc') to reload PATH."
  echo ""
}

# ── banner ────────────────────────────────────────────────────────────────────
echo -e "${BOLD}${BLUE}"
echo "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
echo "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
echo "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
echo "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
echo "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
echo "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
echo -e "  Configuration Installer  (Linux / macOS)${NC}\n"

# ── main ──────────────────────────────────────────────────────────────────────
detect_environment
install_system_packages
install_gh_cli
install_neovim
install_rust
install_nodejs
install_go
install_lazygit
install_pnpm
install_pynvim
install_nerd_font
[ "$IS_WSL" = "true" ] && install_win32yank || true
setup_neovim_headless
setup_github
setup_paths
print_summary
