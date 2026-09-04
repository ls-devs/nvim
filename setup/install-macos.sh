#!/usr/bin/env bash
# ── install-macos.sh ──────────────────────────────────────────────────────────
# One-command bootstrap of ls-devs/nvim on a fresh macOS machine
# (Apple Silicon and Intel).
#
# Unlike install.sh, this script assumes *nothing* is installed: it brings up
# the Xcode Command Line Tools, Homebrew, the config itself, a Neovim built
# from source, and the zsh / oh-my-zsh / spaceship environment.
#
# Run it straight from a fresh machine:
#
#   curl -fsSL https://raw.githubusercontent.com/ls-devs/nvim/main/setup/install-macos.sh | bash
#
# or, if the repo is already cloned:
#
#   bash ~/.config/nvim/setup/install-macos.sh
#
# Options:
#   --nvim=source|brew   Neovim from git (default) or the Homebrew bottle.
#                        Homebrew currently ships 0.12.5, which is too old for
#                        this config — see the note in build_neovim().
#   --nvim-ref=REF       git ref to build (default: master)
#   --skip-nvim          Do not touch Neovim at all
#   --skip-zsh           Do not install zsh / oh-my-zsh / spaceship
#   --no-chsh            Install zsh but do not make it the default shell
#   --skip-headless      Do not run :Lazy / :MasonToolsInstallSync / :TSUpdate
#   --skip-github        Do not run `gh auth login` / install the Copilot CLI
#   --terminal=NAME      Optionally install a terminal emulator cask
#                        (ghostty | wezterm | kitty | iterm2 | none — default none).
#                        Terminal.app is fine for everything except inline
#                        images: it implements neither the Kitty graphics
#                        protocol nor Sixel, so snacks.image stays disabled.
#                        Truecolor does work in Terminal.app since macOS 26.
#
# Windows: use install.ps1. Linux/WSL: use install.sh.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# ── flags ─────────────────────────────────────────────────────────────────────
NVIM_MODE="source"
NVIM_REF="master"
SKIP_NVIM=false
SKIP_ZSH=false
NO_CHSH=false
SKIP_HEADLESS=false
SKIP_GITHUB=false
TERMINAL_APP="none"

for arg in "$@"; do
  case "$arg" in
    --nvim=*)      NVIM_MODE="${arg#*=}" ;;
    --nvim-ref=*)  NVIM_REF="${arg#*=}" ;;
    --skip-nvim)   SKIP_NVIM=true ;;
    --skip-zsh)    SKIP_ZSH=true ;;
    --no-chsh)     NO_CHSH=true ;;
    --skip-headless) SKIP_HEADLESS=true ;;
    --skip-github) SKIP_GITHUB=true ;;
    --terminal=*)  TERMINAL_APP="${arg#*=}" ;;
    -h|--help)     sed -n '2,33p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg (try --help)" >&2; exit 1 ;;
  esac
done

# ── globals ───────────────────────────────────────────────────────────────────
ARCH=""
BREW_PREFIX=""
CONFIG_DIR="${HOME}/.config/nvim"
REPO_URL="https://github.com/ls-devs/nvim.git"
NVIM_SRC="${HOME}/Utils/neovim"

# ── colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
header()  { echo -e "\n${BOLD}${BLUE}══ $* ══${NC}"; }

command_exists() { command -v "$1" &>/dev/null; }

version_ge() {
  local IFS='.'
  read -ra v1 <<< "$1"; read -ra v2 <<< "$2"
  for i in 0 1 2; do
    local a="${v1[$i]:-0}" b="${v2[$i]:-0}"
    a="${a%%-*}"; b="${b%%-*}"
    (( a > b )) && return 0; (( a < b )) && return 1
  done; return 0
}

# ── 0 · preflight ─────────────────────────────────────────────────────────────
preflight() {
  header "0 · Preflight"

  [ "$(uname -s)" = "Darwin" ] || {
    error "This script is macOS-only. Use install.sh on Linux/WSL, install.ps1 on Windows."
    exit 1
  }

  case "$(uname -m)" in
    arm64) ARCH="arm64" ;;
    x86_64) ARCH="x86_64" ;;
    *) error "Unsupported architecture: $(uname -m)"; exit 1 ;;
  esac

  case "$NVIM_MODE" in source|brew) ;; *)
    error "--nvim must be 'source' or 'brew' (got '${NVIM_MODE}')."; exit 1 ;;
  esac

  info "macOS $(sw_vers -productVersion) · ${ARCH} · Neovim: ${NVIM_MODE}"

  # Ask for sudo up-front so the long build does not stall on a password
  # prompt half an hour in, then keep the timestamp warm.
  info "Requesting administrator rights (needed for 'make install' and /etc/shells)…"
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
}

# ── 1 · Xcode Command Line Tools ──────────────────────────────────────────────
install_xcode_clt() {
  header "1 · Xcode Command Line Tools"

  if xcode-select -p &>/dev/null; then
    success "Already installed ($(xcode-select -p))."
    return 0
  fi

  info "Opening the Command Line Tools installer…"
  xcode-select --install 2>/dev/null || true
  warn "A macOS dialog just opened — click Install and wait for it to finish."

  local waited=0
  until xcode-select -p &>/dev/null; do
    sleep 10; waited=$(( waited + 10 ))
    (( waited % 60 == 0 )) && info "Still waiting… (${waited}s elapsed)"
    (( waited >= 1800 )) && {
      error "Timed out. Run 'xcode-select --install' manually, then re-run this script."
      exit 1
    }
  done

  success "Command Line Tools installed."
}

# ── 2 · Homebrew ──────────────────────────────────────────────────────────────
locate_brew() {
  local p
  for p in /opt/homebrew /usr/local; do
    if [ -x "${p}/bin/brew" ]; then BREW_PREFIX="$p"; return 0; fi
  done
  return 1
}

install_homebrew() {
  header "2 · Homebrew"

  if ! locate_brew; then
    info "Installing Homebrew…"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    locate_brew || { error "Homebrew installed but 'brew' was not found."; exit 1; }
  fi

  # Apple Silicon installs to /opt/homebrew, which is NOT on the default PATH.
  # Load it into this shell, and persist it for future login shells.
  eval "$("${BREW_PREFIX}/bin/brew" shellenv)"

  local line="eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""
  if ! grep -qsF "brew shellenv" "${HOME}/.zprofile"; then
    echo "$line" >> "${HOME}/.zprofile"
    info "Added 'brew shellenv' to ~/.zprofile"
  fi

  success "Homebrew $(brew --version | head -1) at ${BREW_PREFIX}."
}

# ── 3 · the Neovim configuration itself ───────────────────────────────────────
clone_config() {
  header "3 · Neovim configuration"

  if [ -f "${CONFIG_DIR}/init.lua" ]; then
    success "Config already present at ${CONFIG_DIR}."
    return 0
  fi

  if [ -e "$CONFIG_DIR" ]; then
    local backup
    backup="${CONFIG_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
    warn "Existing ${CONFIG_DIR} moved to ${backup}"
    mv "$CONFIG_DIR" "$backup"
  fi

  info "Cloning ${REPO_URL}…"
  mkdir -p "$(dirname "$CONFIG_DIR")"
  git clone "$REPO_URL" "$CONFIG_DIR"
  success "Config cloned to ${CONFIG_DIR}."
}

# ── 4 · Homebrew packages ─────────────────────────────────────────────────────
install_brew_packages() {
  header "4 · Homebrew packages"

  brew update -q || true

  # Neovim build dependencies (see neovim/BUILD.md § macOS / Homebrew)
  local build_deps=(ninja cmake gettext curl git pkg-config)

  # Runtime + tooling required by the config
  local tools=(
    wget unzip jq
    ripgrep fd fzf shellcheck
    imagemagick
    luarocks sqlite
    tree-sitter          # nvim-treesitter `main` needs the CLI >= 0.26.1
    lazygit gh
    node go openjdk
    php composer
  )

  info "Installing ${#build_deps[@]} build deps and ${#tools[@]} tools…"

  # One bulk call is much faster, but a single bad formula (network blip, an
  # unavailable bottle) aborts the whole invocation and would leave the rest
  # uninstalled. So: bulk first, then verify and retry only what is missing.
  brew install "${build_deps[@]}" "${tools[@]}" || true

  local missing_required=() missing_optional=() f
  for f in "${build_deps[@]}" "${tools[@]}"; do
    brew list --versions "$f" >/dev/null 2>&1 && continue
    info "Retrying ${f}…"
    brew install "$f" >/dev/null 2>&1 || true
    if ! brew list --versions "$f" >/dev/null 2>&1; then
      if printf '%s\n' "${build_deps[@]}" | grep -qx "$f"; then
        missing_required+=("$f")
      else
        missing_optional+=("$f")
      fi
    fi
  done

  # Build deps are fatal only when we actually build Neovim from source.
  if [ ${#missing_required[@]} -gt 0 ]; then
    if [ "$NVIM_MODE" = "source" ] && [ "$SKIP_NVIM" != "true" ]; then
      error "Missing build dependencies: ${missing_required[*]}"
      error "Neovim cannot be compiled without them. Fix Homebrew and re-run,"
      error "or use --nvim=brew / --skip-nvim."
      exit 1
    fi
    warn "Missing build dependencies: ${missing_required[*]}"
  fi
  [ ${#missing_optional[@]} -gt 0 ] && \
    warn "These tools failed to install: ${missing_optional[*]} — install them later with 'brew install <name>'."

  # `tree-sitter` is the single most common cause of "no syntax highlighting":
  # nvim-treesitter's `main` branch shells out to the CLI and fails silently
  # when it is missing or older than 0.26.1.
  if command_exists tree-sitter; then
    local ts_ver; ts_ver="$(tree-sitter --version | awk '{print $2}')"
    if version_ge "$ts_ver" "0.26.1"; then
      success "tree-sitter CLI ${ts_ver} (>= 0.26.1)."
    else
      warn "tree-sitter CLI ${ts_ver} is older than 0.26.1 — parsers will fail to"
      warn "build and you will get no syntax highlighting. Run 'brew upgrade tree-sitter'."
    fi
  else
    warn "tree-sitter CLI is NOT installed — nvim-treesitter will silently install"
    warn "zero parsers and you will get no syntax highlighting anywhere."
    warn "Fix with: brew install tree-sitter   (or: cargo install tree-sitter-cli)"
  fi

  # openjdk is keg-only; jdtls needs it visible as a system JVM.
  local jdk_prefix; jdk_prefix="$(brew --prefix openjdk 2>/dev/null || true)"
  if [ -n "$jdk_prefix" ] && [ -d "${jdk_prefix}/libexec/openjdk.jdk" ]; then
    sudo ln -sfn "${jdk_prefix}/libexec/openjdk.jdk" \
      /Library/Java/JavaVirtualMachines/openjdk.jdk 2>/dev/null || true
  fi

  if [ ${#missing_required[@]} -eq 0 ] && [ ${#missing_optional[@]} -eq 0 ]; then
    success "Homebrew packages installed."
  else
    warn "Homebrew finished with missing packages (see above)."
  fi
}

# ── 5 · Neovim ────────────────────────────────────────────────────────────────
build_neovim() {
  header "5 · Neovim"

  if [ "$SKIP_NVIM" = "true" ]; then
    info "Skipping Neovim (--skip-nvim)."; return 0
  fi

  if [ "$NVIM_MODE" = "brew" ]; then
    warn "Homebrew ships Neovim 0.12.5. This config uses 'vim.hl.hl_op()' and"
    warn "'scrolloffpad', both of which only exist in 0.13-dev. Expect errors."
    brew install neovim 2>/dev/null || brew upgrade neovim || true
    success "Neovim $(nvim --version | head -1 | sed 's/NVIM v//') installed via Homebrew."
    return 0
  fi

  if [ -d "${NVIM_SRC}/.git" ]; then
    info "Updating existing checkout at ${NVIM_SRC}…"
    git -C "$NVIM_SRC" fetch --prune origin
    git -C "$NVIM_SRC" checkout "$NVIM_REF"
    git -C "$NVIM_SRC" pull --ff-only origin "$NVIM_REF" 2>/dev/null || true
  else
    info "Cloning neovim/neovim into ${NVIM_SRC}…"
    mkdir -p "$(dirname "$NVIM_SRC")"
    git clone https://github.com/neovim/neovim.git "$NVIM_SRC"
    git -C "$NVIM_SRC" checkout "$NVIM_REF"
  fi

  info "Building Neovim ($(git -C "$NVIM_SRC" rev-parse --short HEAD)) — 5–15 min…"
  (
    cd "$NVIM_SRC"
    [ -d build ] && make distclean >/dev/null 2>&1 || true
    make CMAKE_BUILD_TYPE="Release"
    sudo make install
  )

  hash -r
  success "Neovim $(nvim --version | head -1 | sed 's/NVIM v//') built and installed."
}

# ── 6 · Rust ──────────────────────────────────────────────────────────────────
install_rust() {
  header "6 · Rust + Cargo"
  # blink.cmp runs `cargo build --release` at plugin install time.

  if command_exists cargo; then
    success "Cargo $(cargo --version | awk '{print $2}') already installed."
  else
    info "Installing Rust via rustup…"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    # shellcheck source=/dev/null
    [ -f "${HOME}/.cargo/env" ] && source "${HOME}/.cargo/env"
  fi

  export PATH="${HOME}/.cargo/bin:${PATH}"
  if command_exists rustup && ! command_exists rustfmt; then
    rustup component add rustfmt || true
  fi
  success "Cargo $(cargo --version | awk '{print $2}') ready."
}

# ── 7 · Node.js tooling ───────────────────────────────────────────────────────
install_node_tooling() {
  header "7 · Node.js tooling"
  # node itself comes from Homebrew (step 4).

  command_exists npm || { warn "npm not found — skipping."; return 0; }

  if ! npm list -g --depth=0 neovim &>/dev/null; then
    info "Installing the npm 'neovim' provider…"
    npm install -g neovim || warn "npm install -g neovim failed."
  fi

  if ! command_exists pnpm; then
    info "Installing pnpm…"   # live-server.nvim's build step uses it
    npm install -g pnpm || warn "npm install -g pnpm failed."
  fi

  success "Node $(node --version) · npm $(npm --version)$(command_exists pnpm && echo " · pnpm $(pnpm --version)")"
}

# ── 8 · pynvim ────────────────────────────────────────────────────────────────
install_pynvim() {
  header "8 · pynvim"

  if python3 -c "import pynvim" 2>/dev/null; then
    success "pynvim already importable."; return 0
  fi

  # Homebrew's Python is PEP 668 "externally managed", so a plain
  # `pip install` is refused. Try the least invasive option first.
  info "Installing pynvim…"
  if python3 -m pip install --user --break-system-packages pynvim 2>/dev/null \
     || python3 -m pip install --break-system-packages pynvim 2>/dev/null; then
    success "pynvim installed."
    return 0
  fi

  local venv="${HOME}/.local/share/nvim/venv"
  warn "pip refused to install into the Homebrew Python — using a venv instead."
  python3 -m venv "$venv"
  "${venv}/bin/pip" install --quiet --upgrade pip pynvim
  warn "Add this to your config so Neovim finds it:"
  warn "  vim.g.python3_host_prog = \"${venv}/bin/python3\""
  success "pynvim installed in ${venv}."
}

# ── 9 · FiraCode Nerd Font ────────────────────────────────────────────────────
install_nerd_font() {
  header "9 · FiraCode Nerd Font"

  if find "${HOME}/Library/Fonts" /Library/Fonts -iname "*FiraCode*Nerd*" \
       2>/dev/null | grep -q .; then
    success "FiraCode Nerd Font already installed."; return 0
  fi

  info "Installing font-fira-code-nerd-font…"
  brew install --cask font-fira-code-nerd-font \
    || warn "Cask install failed — install the font manually from nerdfonts.com."
  success "FiraCode Nerd Font installed."
}

# ── 10 · terminal emulator (optional) ─────────────────────────────────────────
install_terminal() {
  [ "$TERMINAL_APP" = "none" ] && return 0
  header "10 · Terminal emulator"

  case "$TERMINAL_APP" in
    ghostty|wezterm|kitty|iterm2)
      if [ -d "/Applications/${TERMINAL_APP}.app" ]; then
        success "${TERMINAL_APP} already installed."; return 0
      fi
      info "Installing ${TERMINAL_APP}…"
      brew install --cask "$TERMINAL_APP" || warn "Cask install failed."
      success "${TERMINAL_APP} installed."
      ;;
    *)
      warn "Unknown --terminal=${TERMINAL_APP} — skipping."
      ;;
  esac
}

# ── 11 · zsh + oh-my-zsh + spaceship ──────────────────────────────────────────
install_shell() {
  header "11 · zsh + oh-my-zsh + spaceship"

  if [ "$SKIP_ZSH" = "true" ]; then
    info "Skipping shell setup (--skip-zsh)."; return 0
  fi

  local script="${CONFIG_DIR}/setup/install-zsh.sh"
  if [ ! -f "$script" ]; then
    warn "${script} not found — skipping shell setup."; return 0
  fi

  # install-zsh.sh handles oh-my-zsh, zsh-autosuggestions,
  # zsh-syntax-highlighting, spaceship-prompt and deploys setup/zshrc.
  # macOS still ships bash 3.2, where expanding an empty array under `set -u`
  # aborts the script ("args[@]: unbound variable"). The ${a[@]+"${a[@]}"}
  # guard is the portable way to expand "zero or more" arguments.
  local args=()
  [ "$NO_CHSH" = "true" ] && args+=(--no-chsh)
  bash "$script" ${args[@]+"${args[@]}"}
}

# ── post · Neovim headless setup ──────────────────────────────────────────────
setup_neovim_headless() {
  header "· Neovim: plugins, Mason tools, treesitter"

  if [ "$SKIP_HEADLESS" = "true" ]; then
    info "Skipping headless setup (--skip-headless)."; return 0
  fi
  if ! command_exists nvim; then
    warn "nvim not on PATH — skipping headless setup."; return 0
  fi
  if [ ! -f "${CONFIG_DIR}/init.lua" ]; then
    warn "No config at ${CONFIG_DIR} — skipping headless setup."; return 0
  fi

  # shellcheck source=/dev/null
  [ -f "${HOME}/.cargo/env" ] && source "${HOME}/.cargo/env"
  export PATH="${HOME}/.cargo/bin:${PATH}"

  info "Installing plugins (Lazy.nvim) — includes the blink.cmp Rust build…"
  nvim --headless "+Lazy! install" +qa 2>&1 | grep -Ev "^$" | tail -5 || true

  local blink_dir="${HOME}/.local/share/nvim/lazy/blink.cmp"
  if [ -d "$blink_dir" ] && [ ! -d "${blink_dir}/target/release" ] && command_exists cargo; then
    info "blink.cmp native artefact missing — building manually…"
    ( cd "$blink_dir" && cargo build --release ) \
      || warn "blink.cmp build failed — run 'cd ${blink_dir} && cargo build --release'."
  fi

  info "Installing Mason tools (LSPs, formatters, linters, debuggers) — 10–20 min…"
  nvim --headless "+MasonToolsInstallSync" +qa 2>&1 \
    | grep -E "installed|updated|failed|error" | tail -20 || true

  info "Installing treesitter parsers…"
  nvim --headless "+TSUpdate" +qa 2>&1 | tail -3 || true

  success "Neovim headless setup complete."
}

# ── post · GitHub auth + Copilot CLI ──────────────────────────────────────────
setup_github() {
  header "· GitHub authentication + Copilot CLI"

  if [ "$SKIP_GITHUB" = "true" ]; then
    info "Skipping GitHub setup (--skip-github)."; return 0
  fi
  command_exists gh || { warn "gh not found — skipping."; return 0; }

  if gh auth status &>/dev/null; then
    success "GitHub CLI already authenticated."
  else
    info "Opening the GitHub login flow (a browser window will open)…"
    gh auth login || { warn "Auth skipped. Run 'gh auth login' later."; return 0; }
  fi

  if gh extension list 2>/dev/null | grep -q copilot; then
    success "gh copilot extension already installed."
  else
    gh extension install github/gh-copilot && success "gh copilot extension installed."
  fi
}

# ── summary ───────────────────────────────────────────────────────────────────
print_summary() {
  echo ""
  echo -e "${BOLD}${GREEN}══ All done! ══${NC}"
  echo ""
  command_exists nvim        && echo -e "  ${GREEN}✓${NC} Neovim       $(nvim --version | head -1)"
  command_exists brew        && echo -e "  ${GREEN}✓${NC} Homebrew     ${BREW_PREFIX}"
  command_exists cargo       && echo -e "  ${GREEN}✓${NC} Cargo        $(cargo --version | awk '{print $2}')"
  command_exists node        && echo -e "  ${GREEN}✓${NC} Node.js      $(node --version)"
  command_exists go          && echo -e "  ${GREEN}✓${NC} Go           $(go version | awk '{print $3}')"
  command_exists tree-sitter && echo -e "  ${GREEN}✓${NC} tree-sitter  $(tree-sitter --version | awk '{print $2}')"
  command_exists gh          && echo -e "  ${GREEN}✓${NC} gh CLI       $(gh --version | head -1)"
  command_exists lazygit     && echo -e "  ${GREEN}✓${NC} lazygit      $(lazygit --version 2>&1 | head -1)"
  [ -d "${HOME}/.oh-my-zsh" ] && echo -e "  ${GREEN}✓${NC} oh-my-zsh    + spaceship prompt"
  echo ""
  echo -e "  Open a new terminal, then run ${BOLD}nvim${NC} and ${BOLD}:checkhealth${NC}."
  echo -e "  ${YELLOW}Note:${NC} set your terminal font to ${BOLD}FiraCode Nerd Font${NC} or icons will be broken."
  if [ "$TERMINAL_APP" = "none" ]; then
    echo -e "  ${YELLOW}Note:${NC} inline images in Neovim (previews, neo-tree, markdown) need the"
    echo -e "         Kitty graphics protocol, which Terminal.app does not implement."
    echo -e "         snacks.image disables itself automatically — everything else works."
    echo -e "         Re-run with ${BOLD}--terminal=ghostty${NC} if you ever want them."
  fi
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
echo -e "  Configuration Installer  (macOS)${NC}\n"

# ── main ──────────────────────────────────────────────────────────────────────
preflight
install_xcode_clt
install_homebrew
clone_config
install_brew_packages
build_neovim
install_rust
install_node_tooling
install_pynvim
install_nerd_font
install_terminal
install_shell
setup_neovim_headless
setup_github
print_summary
