#!/usr/bin/env bash
# ── install-zsh.sh ────────────────────────────────────────────────────────────
# Installs zsh, oh-my-zsh, spaceship-prompt and plugins for ls-devs/nvim.
#
# Supported environments:
#   Linux  : Ubuntu/Debian (apt) · Fedora/RHEL (dnf) · CentOS 7 (yum)
#            Arch Linux (pacman) · openSUSE (zypper) · Alpine (apk)
#   macOS  : Homebrew (brew)
#   WSL    : Any of the above Linux distros
#
# Windows: use install-zsh.ps1 (PowerShell) instead.
#
# Usage:
#   bash install-zsh.sh            # install everything + set zsh as default shell
#   bash install-zsh.sh --no-chsh  # skip changing the default shell
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

# ── flags ─────────────────────────────────────────────────────────────────────
NO_CHSH=false
for arg in "$@"; do [[ "$arg" == "--no-chsh" ]] && NO_CHSH=true; done

# ── globals ───────────────────────────────────────────────────────────────────
OS_TYPE=""
PKG_MANAGER=""
SUDO_CMD=""

# ── colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
header()  { echo -e "\n${BOLD}${BLUE}══ $* ══${NC}"; }

command_exists() { command -v "$1" &>/dev/null; }

# ── detect environment ────────────────────────────────────────────────────────
detect_environment() {
  if command_exists sudo; then
    SUDO_CMD="sudo"
  elif [ "$(id -u)" = "0" ]; then
    SUDO_CMD=""
  else
    error "sudo not found and not running as root. Exiting."; exit 1
  fi

  case "$(uname -s)" in
    Linux)
      OS_TYPE="linux"
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
      OS_TYPE="macos"
      command_exists brew || { error "Homebrew required. Install from https://brew.sh"; exit 1; }
      PKG_MANAGER="brew"
      ;;
    *)
      error "Unsupported OS: $(uname -s). On Windows use install-zsh.ps1."
      exit 1
      ;;
  esac

  info "OS: ${OS_TYPE} · PM: ${PKG_MANAGER}"
}

# ── 1. zsh ────────────────────────────────────────────────────────────────────
install_zsh() {
  header "1 · zsh"

  if command_exists zsh; then
    success "zsh $(zsh --version) already installed."; return 0
  fi

  info "Installing zsh…"
  case "$PKG_MANAGER" in
    apt)    $SUDO_CMD apt-get update -qq && $SUDO_CMD apt-get install -y zsh ;;
    dnf)    $SUDO_CMD dnf install -y zsh ;;
    yum)    $SUDO_CMD yum install -y zsh ;;
    pacman) $SUDO_CMD pacman -S --noconfirm --needed zsh ;;
    zypper) $SUDO_CMD zypper install -y zsh ;;
    apk)    $SUDO_CMD apk add zsh ;;
    brew)   brew install zsh ;;
  esac

  success "zsh $(zsh --version) installed."
}

# ── 2. oh-my-zsh ─────────────────────────────────────────────────────────────
install_omz() {
  header "2 · oh-my-zsh"

  if [ -d "$HOME/.oh-my-zsh" ]; then
    success "oh-my-zsh already installed at ~/.oh-my-zsh."; return 0
  fi

  info "Installing oh-my-zsh…"
  # RUNZSH=no   → don't launch zsh after install (keep running this script)
  # CHSH=no     → we handle the default shell ourselves in set_default_shell()
  # KEEP_ZSHRC=yes → don't overwrite ~/.zshrc (we deploy ours in deploy_zshrc)
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  success "oh-my-zsh installed."
}

# ── 3. zsh-autosuggestions ────────────────────────────────────────────────────
install_autosuggestions() {
  header "3 · zsh-autosuggestions"

  local target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  if [ -d "$target" ]; then
    success "zsh-autosuggestions already installed."; return 0
  fi

  info "Cloning zsh-autosuggestions…"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$target"
  success "zsh-autosuggestions installed."
}

# ── 4. zsh-syntax-highlighting ────────────────────────────────────────────────
install_syntax_highlighting() {
  header "4 · zsh-syntax-highlighting"

  local target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  if [ -d "$target" ]; then
    success "zsh-syntax-highlighting already installed."; return 0
  fi

  info "Cloning zsh-syntax-highlighting…"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$target"
  success "zsh-syntax-highlighting installed."
}

# ── 5. spaceship-prompt ───────────────────────────────────────────────────────
install_spaceship() {
  header "5 · spaceship-prompt"

  local target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
  local link="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"

  if [ -d "$target" ]; then
    success "spaceship-prompt already installed."; return 0
  fi

  info "Cloning spaceship-prompt…"
  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$target"
  ln -sf "$target/spaceship.zsh-theme" "$link"
  success "spaceship-prompt installed."
}

# ── 6. deploy .zshrc ─────────────────────────────────────────────────────────
deploy_zshrc() {
  header "6 · .zshrc"

  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local src="$script_dir/zshrc"

  if [ ! -f "$src" ]; then
    warn "Could not find $src — skipping .zshrc deploy."
    warn "Copy setup/zshrc to ~/.zshrc manually."
    return 0
  fi

  if [ -f "$HOME/.zshrc" ]; then
    local backup
    backup="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
    warn "Existing ~/.zshrc backed up to ${backup}"
    cp "$HOME/.zshrc" "$backup"
  fi

  cp "$src" "$HOME/.zshrc"
  success ".zshrc deployed to ~/.zshrc"
}

# ── 7. set default shell ──────────────────────────────────────────────────────
set_default_shell() {
  header "7 · Default shell"

  if [ "$NO_CHSH" = "true" ]; then
    info "Skipping default shell change (--no-chsh passed)."; return 0
  fi

  local zsh_path
  zsh_path="$(command -v zsh)"

  local current_shell
  current_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 \
    || dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}' \
    || echo "")"

  if [ "$current_shell" = "$zsh_path" ]; then
    success "Default shell is already zsh ($zsh_path)."; return 0
  fi

  # Ensure zsh is listed in /etc/shells
  if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
    info "Adding $zsh_path to /etc/shells…"
    echo "$zsh_path" | $SUDO_CMD tee -a /etc/shells > /dev/null
  fi

  info "Setting zsh as default shell for ${USER}…"
  chsh -s "$zsh_path" \
    || warn "chsh failed — set it manually: chsh -s $zsh_path"

  success "Default shell set to zsh. Log out and back in for it to take effect."
}

# ── summary ───────────────────────────────────────────────────────────────────
print_summary() {
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  echo ""
  echo -e "${BOLD}${GREEN}══ Zsh setup complete! ══${NC}"
  echo ""
  command_exists zsh && \
    echo -e "  ${GREEN}✓${NC} zsh                    $(zsh --version)"
  [ -d "$HOME/.oh-my-zsh" ] && \
    echo -e "  ${GREEN}✓${NC} oh-my-zsh              installed"
  [ -d "${zsh_custom}/plugins/zsh-autosuggestions" ] && \
    echo -e "  ${GREEN}✓${NC} zsh-autosuggestions    installed"
  [ -d "${zsh_custom}/plugins/zsh-syntax-highlighting" ] && \
    echo -e "  ${GREEN}✓${NC} zsh-syntax-highlighting installed"
  [ -d "${zsh_custom}/themes/spaceship-prompt" ] && \
    echo -e "  ${GREEN}✓${NC} spaceship-prompt        installed"
  [ -f "$HOME/.zshrc" ] && \
    echo -e "  ${GREEN}✓${NC} ~/.zshrc                deployed"
  echo ""
  echo -e "  ${YELLOW}Next:${NC} Open a new terminal (or run: exec zsh) to start using zsh."
  echo ""
}

# ── banner ────────────────────────────────────────────────────────────────────
echo -e "${BOLD}${BLUE}"
echo "  ███████╗███████╗██╗  ██╗"
echo "  ╚══███╔╝██╔════╝██║  ██║"
echo "    ███╔╝ ███████╗███████║"
echo "   ███╔╝  ╚════██║██╔══██║"
echo "  ███████╗███████║██║  ██║"
echo "  ╚══════╝╚══════╝╚═╝  ╚═╝"
echo -e "  Zsh + oh-my-zsh + spaceship Installer  (Linux / macOS)${NC}\n"

# ── main ──────────────────────────────────────────────────────────────────────
detect_environment
install_zsh
install_omz
install_autosuggestions
install_syntax_highlighting
install_spaceship
deploy_zshrc
set_default_shell
print_summary
