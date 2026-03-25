# ── Dockerfile ────────────────────────────────────────────────────────────────
# Full ls-devs/nvim development environment.
# Bundles all system tools, language runtimes, and pre-installs Neovim plugins.
#
# Build:  docker build -t ls-devs-nvim .
#         (or use docker-run.sh / docker-run.ps1 which build automatically)
#
# Run:
#   Linux/macOS : ./docker-run.sh
#   Windows     : .\docker-run.ps1
#
# On first run inside the container:
#   :MasonToolsInstall     ← LSPs / formatters / linters / debuggers
#   :TSUpdate              ← treesitter parsers
#   gh auth login          ← GitHub auth (then: gh extension install github/gh-copilot)
# ─────────────────────────────────────────────────────────────────────────────
FROM ubuntu:24.04

LABEL maintainer="ls-devs"
LABEL description="ls-devs/nvim — full IDE environment with all language tools"

# Prevent interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Tell options.lua the container is Docker → activates OSC 52 clipboard
ENV container=docker

# Terminal / colour settings
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Runtime PATH additions (set early so subsequent RUN commands can use them)
ENV PATH="/root/.cargo/bin:/usr/local/go/bin:${PATH}"

# ── 1. System packages ────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
      # Core utilities
      git curl wget unzip zip tar gzip xz-utils \
      ca-certificates gnupg lsb-release sudo \
      # Build toolchain (treesitter parsers, LuaSnip jsregexp, codelldb)
      build-essential gcc g++ make cmake ninja-build \
      libstdc++-dev pkg-config gettext \
      # Python (pyright, debugpy, neotest-python, pynvim)
      python3 python3-pip python3-venv \
      # Java (jdtls language server)
      default-jdk \
      # CLI tools used directly by plugins
      ripgrep fd-find fzf shellcheck \
      # Clipboard (OSC 52 for Docker, wl-clipboard for Wayland awareness)
      xclip wl-clipboard \
      # Plugin deps
      imagemagick   `# img-clip.nvim (paste images into CodeCompanion)` \
      xdg-utils     `# gx.nvim URL opener` \
      jq            `# JSON processing` \
      luarocks      `# luarocks.nvim → luautf8 for nvim-spider` \
      sqlite3 libsqlite3-dev `# vim-dadbod database UI` \
      # PHP (intelephense, php-cs-fixer, php-debug-adapter)
      php composer \
      # Shell
      zsh \
    # Create 'fd' symlink (Debian/Ubuntu installs binary as 'fdfind')
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ── 2. GitHub CLI (gh) ────────────────────────────────────────────────────────
# Required by: octo.nvim (PR/issue management), Copilot CLI extension
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
         > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ── 3. Node.js LTS ────────────────────────────────────────────────────────────
# Required by: ts_ls, eslint_d, copilot.lua (copilot_node_command), live-server,
#              jest/vitest, mcphub, and the Neovim Node.js remote plugin provider
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    # pnpm: live-server.nvim build step uses `pnpm add -g live-server`
    # neovim: Node.js remote plugin provider for Neovim
    && npm install -g pnpm neovim

# ── 4. Rust + Cargo ───────────────────────────────────────────────────────────
# blink.cmp runs `cargo build --release` at plugin install time.
# PATH for cargo already added via ENV above.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
      | sh -s -- -y --no-modify-path \
    && rustup component add rustfmt

# ── 5. Go ─────────────────────────────────────────────────────────────────────
# Some Mason-managed LSPs and tools require Go.
# PATH for go already added via ENV above.
RUN ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') \
    && GO_TAG=$(curl -fsSL "https://go.dev/dl/?mode=json" \
        | grep '"version"' | head -1 \
        | sed -E 's/.*"version": "([^"]+)".*/\1/') \
    && curl -fsSL "https://go.dev/dl/${GO_TAG}.linux-${ARCH}.tar.gz" \
         -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# ── 6. Neovim >= 0.12.0 ───────────────────────────────────────────────────────
RUN ARCH=$(uname -m | sed 's/aarch64/arm64/') \
    && NVIM_TAG=$(curl -fsSL \
        "https://api.github.com/repos/neovim/neovim/releases/latest" \
        | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/') \
    && curl -fsSL \
        "https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-linux-${ARCH}.tar.gz" \
        -o /tmp/nvim.tar.gz \
    && tar -xzf /tmp/nvim.tar.gz -C /tmp \
    && mv /tmp/nvim-linux-${ARCH} /opt/nvim \
    && ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && rm /tmp/nvim.tar.gz

# ── 7. lazygit ────────────────────────────────────────────────────────────────
# snacks.lazygit floating git UI
RUN ARCH=$(uname -m | sed 's/aarch64/arm64/') \
    && TAG=$(curl -fsSL \
        "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/') \
    && VER="${TAG#v}" \
    && curl -fsSL \
        "https://github.com/jesseduffield/lazygit/releases/download/${TAG}/lazygit_${VER}_Linux_${ARCH}.tar.gz" \
        -o /tmp/lazygit.tar.gz \
    && tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit \
    && install /tmp/lazygit /usr/local/bin/lazygit \
    && rm -f /tmp/lazygit.tar.gz /tmp/lazygit

# ── 8. Python packages ────────────────────────────────────────────────────────
RUN python3 -m pip install --break-system-packages pynvim

# ── 9. Zsh + oh-my-zsh + spaceship-prompt + plugins ──────────────────────────
# RUNZSH=no   → don't launch zsh after install (keep the build running)
# CHSH=no     → CMD below handles the default shell
# KEEP_ZSHRC=yes → we deploy our own .zshrc after COPY
ENV ZSH="/root/.oh-my-zsh"
ENV ZSH_CUSTOM="/root/.oh-my-zsh/custom"
RUN RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone --depth=1 \
         https://github.com/zsh-users/zsh-autosuggestions \
         /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone --depth=1 \
         https://github.com/zsh-users/zsh-syntax-highlighting \
         /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && git clone --depth=1 \
         https://github.com/spaceship-prompt/spaceship-prompt.git \
         /root/.oh-my-zsh/custom/themes/spaceship-prompt \
    && ln -sf /root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme \
              /root/.oh-my-zsh/custom/themes/spaceship.zsh-theme \
    && chsh -s "$(which zsh)"

# ── 10. Neovim config + pre-installed plugins ─────────────────────────────────
# Build context is the repo root (passed via -f setup/Dockerfile from docker-run scripts).
# COPY . copies the full config directory into the container.
RUN mkdir -p /root/.config
COPY . /root/.config/nvim/

# Deploy the portable .zshrc (spaceship config + oh-my-zsh + conditional loaders)
RUN cp /root/.config/nvim/setup/zshrc /root/.zshrc

# Pre-install Lazy.nvim plugins (runs `cargo build --release` for blink.cmp).
# Two passes: first installs, second ensures all build hooks complete.
RUN nvim --headless "+Lazy! install" +qa 2>&1; \
    nvim --headless "+Lazy! install" +qa 2>&1 || true

# Install all Mason tools (LSPs, formatters, linters, debuggers).
# MasonToolsInstallSync blocks until every package is installed.
# Note: adds ~15-30 min to build time and ~2 GB to image size.
RUN nvim --headless "+MasonToolsInstallSync" +qa 2>&1 | \
      grep -E "installed|updated|failed|error" || true

# Install treesitter parsers
RUN nvim --headless "+TSUpdate" +qa 2>&1 || true

WORKDIR /root

# ── Entrypoint ────────────────────────────────────────────────────────────────
# Default: drop into zsh (with spaceship prompt + oh-my-zsh).
# The run scripts override this to open nvim directly.
#   docker-run.sh          → opens nvim
#   docker-run.sh zsh      → drops into zsh shell
#   docker-run.sh bash     → drops into bash shell (fallback)
CMD ["/bin/zsh"]
