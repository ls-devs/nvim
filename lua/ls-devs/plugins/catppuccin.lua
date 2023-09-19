local M = {}

M.config = function()
  require("catppuccin").setup({
    flavour = "mocha", -- Can be one of: latte, frappe, macchiato, mocha
    background = { light = "latte", dark = "mocha" },
    dim_inactive = {
      enabled = false,
      -- Dim inactive splits/windows/buffers.
      -- NOT recommended if you use old palette (a.k.a., mocha).
      shade = "dark",
      percentage = 0.15,
    },
    transparent_background = true,
    show_end_of_buffer = true, -- show the '~' characters after the end of buffers
    term_colors = true,
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    styles = {
      comments = { "bold" },
      properties = { "italic" },
      functions = { "italic", "bold" },
      keywords = { "italic" },
      operators = { "bold" },
      conditionals = { "bold" },
      loops = { "bold" },
      booleans = { "bold", "italic" },
      numbers = {},
      types = { "italic" },
      strings = {},
      variables = { "bold" },
    },
    integrations = {
      window_picker = false,
      rainbow_delimiters = true,
      alpha = false,
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      aerial = false,
      barbar = false,
      beacon = false,
      cmp = true,
      coc_nvim = false,
      dap = { enabled = true, enable_ui = true },
      dashboard = false,
      fern = false,
      fidget = true,
      gitgutter = false,
      gitsigns = true,
      harpoon = false,
      hop = true,
      illuminate = true,
      indent_blankline = { enabled = true, colored_indent_levels = true },
      leap = true,
      lightspeed = false,
      lsp_saga = true,
      lsp_trouble = true,
      markdown = true,
      mason = true,
      mini = true,
      navic = { enabled = false },
      neogit = false,
      neotest = false,
      neotree = { enabled = true, show_root = true, transparent_panel = true },
      noice = true,
      notify = true,
      nvimtree = true,
      overseer = false,
      pounce = false,
      semantic_tokens = true,
      symbols_outline = true,
      telekasten = false,
      telescope = {
        enabled = true,
      },
      treesitter_context = true,
      ts_rainbow = true,
      vim_sneak = false,
      vimwiki = false,
      which_key = true,
    },
    color_overrides = {
      -- mocha = {
      --   rosewater = "#F5E0DC",
      --   flamingo = "#F2CDCD",
      --   mauve = "#DDB6F2",
      --   pink = "#F5C2E7",
      --   red = "#F28FAD",
      --   maroon = "#E8A2AF",
      --   peach = "#F8BD96",
      --   yellow = "#FAE3B0",
      --   green = "#ABE9B3",
      --   blue = "#96CDFB",
      --   sky = "#89DCEB",
      --   teal = "#B5E8E0",
      --   lavender = "#C9CBFF",
      --
      --   text = "#D9E0EE",
      --   subtext1 = "#BAC2DE",
      --   subtext0 = "#A6ADC8",
      --   overlay2 = "#C3BAC6",
      --   overlay1 = "#988BA2",
      --   overlay0 = "#6E6C7E",
      --   surface2 = "#6E6C7E",
      --   surface1 = "#575268",
      --   surface0 = "#302D41",
      --
      --   base = "#1E1E2E",
      --   mantle = "#1A1826",
      --   crust = "#161320",
      -- },
    },
    highlight_overrides = {
      mocha = function(cp)
        return {
          -- For base configs.
          Normal = { bg = cp.none },
          CursorLine = { bg = cp.none },
          NormalFloat = { fg = cp.text, bg = true and cp.none or cp.base },
          CursorLineNr = { fg = cp.pink, bg = cp.none },
          LineNr = { fg = cp.lavender },
          Search = { bg = cp.surface0, fg = cp.pink, style = { "bold" } },
          IncSearch = { bg = cp.pink, fg = cp.surface1 },
          Keyword = { fg = cp.pink },
          Type = { fg = cp.blue },
          Typedef = { fg = cp.yellow },
          StorageClass = { fg = cp.red, style = { "italic" } },
          LspInlayHint = { bg = cp.none, fg = cp.overlay1 },
          ColorColumn = { bg = cp.none },
          Visual = { bg = "#1877F2", fg = "#FFFFFF", style = { "bold" } },
          -- For native lsp configs.
          DiagnosticVirtualTextError = { bg = cp.none },
          DiagnosticVirtualTextWarn = { bg = cp.none },
          DiagnosticVirtualTextInfo = { bg = cp.none },
          DiagnosticVirtualTextHint = { fg = cp.rosewater, bg = cp.none },
          DiagnosticHint = { fg = cp.rosewater },
          LspDiagnosticsDefaultHint = { fg = cp.rosewater },
          LspDiagnosticsHint = { fg = cp.rosewater },
          LspDiagnosticsVirtualTextHint = { fg = cp.rosewater },
          LspDiagnosticsUnderlineHint = { sp = cp.rosewater },
          -- For fidget.
          FidgetTitle = { fg = cp.blue, style = { "bold" } },
          -- For trouble.nvim
          TroubleNormal = { bg = cp.base },
          -- Mason
          MasonHeader = { fg = cp.base, bg = cp.peach },
          MasonHeaderSecondary = { fg = cp.base, bg = cp.pink },
          MasonHighlight = { fg = cp.pink },
          MasonHighlightBlock = { bg = cp.pink, fg = cp.base },
          MasonHighlightBlockBold = { bg = cp.pink, fg = cp.base, bold = true },
          MasonHighlightSecondary = { fg = cp.red },
          MasonHighlightBlockSecondary = { bg = cp.red, fg = cp.base },
          MasonHighlightBlockBoldSecondary = { bg = cp.red, fg = cp.base, bold = true },
          MasonLink = { fg = cp.rosewater },
          MasonMuted = { fg = cp.overlay1 },
          MasonMutedBlock = { bg = cp.surface0, fg = cp.text },
          MasonMutedBlockBold = { bg = cp.surface0, fg = cp.overlay1, bold = true },
          MasonError = { fg = cp.red },
          MasonHeading = { bold = true },
          -- Lazy
          LazyButtonActive = { bold = true, fg = cp.base, bg = cp.pink },
          LazyButton = { fg = cp.text, bold = true },
          LazyH1 = { bold = true, fg = cp.base, bg = cp.peach },
          LazyH2 = { fg = cp.text, bold = true },
          LazySpecial = { fg = cp.lavender, bold = true },
          LazyProgressTodo = { fg = cp.none, bg = cp.none, bold = true },
          LazyProgressDone = { fg = cp.pink, bg = cp.none, bold = true },
          LazyReasonEvent = { fg = cp.peach, bold = true },
          -- Leap
          LeapBackdrop = { fg = cp.none },
          LeapLabelPrimary = { bg = cp.green, fg = cp.base, style = { "bold" and "underline" } },
          LeapLabelSecondary = { bg = cp.sapphire, fg = cp.base, style = { "bold" and "underline" } },
          -- IndentScope
          MiniIndentscopeSymbol = { fg = cp.peach },
          -- UFO
          UfoPreviewSbar = { fg = cp.red, bg = cp.blue },
          -- Keywords
          UfoFoldedEllipsis = { fg = cp.mauve, bg = cp.blue, style = { "bold" } },
          CustomContextVt = { fg = cp.overlay2, style = { "bold" and "italic" } },
          FidgetTask = { fg = cp.text, style = { "bold" } },
          -- Gitsigns
          GitSignsCurrentLineBlame = { fg = cp.text, style = { "bold" and "italic" } },
          -- Keywords
          ["@type"] = { fg = cp.yellow },
          ["@variable"] = { fg = cp.text, style = { "bold" } },
          ["@keyword.return"] = { fg = cp.mauve, style = { "bold" } },
          ["@comment"] = { fg = cp.overlay2, bold = true },
        }
      end,
    },
  })
  vim.cmd([[colorscheme catppuccin]])
end

return M
