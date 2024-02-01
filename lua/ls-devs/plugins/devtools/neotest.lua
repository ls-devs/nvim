return {
  "nvim-neotest/neotest",
  config = function()
    require("neotest").setup({
      output = {
        enabled = true,
        open_on_run = true,
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },

      library = { plugins = { "neotest" }, types = true },
      adapters = {
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-vitest"),
        require("neotest-rust")({
          args = { "--no-capture" },
          dap_adapter = "lldb",
        }),
        require("neotest-gtest").setup({}),
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        }),
        require("neotest-vim-test")({ ignore_filetypes = { "jest", "rust", "c", "cpp" } }),
      },
      discovery = {
        filter_dir = function(name, rel_path, root)
          return name ~= "node_modules"
        end,
      },
    })
  end,
  keys = {
    {
      "<leader>nr",
      function()
        require("neotest").run.run()
      end,
      desc = "NeoTest Run",
      silent = true,
      noremap = true,
    },
    {
      "<leader>nc",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "NeoTest Run Current File",
      silent = true,
      noremap = true,
    },
    {
      "<leader>nd",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "NeoTest Debug Nearest Test",
      silent = true,
      noremap = true,
    },
    {
      "<leader>ns",
      function()
        require("neotest").run.stop()
      end,
      desc = "NeoTest Stop",
      silent = true,
      noremap = true,
    },
    {
      "<leader>ns",
      function()
        require("neotest").run.attach()
      end,
      desc = "NeoTest Attach Nearest Test",
      silent = true,
      noremap = true,
    },
    {
      "<leader>ns",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "NeoTest Summary Toggle",
      silent = true,
      noremap = true,
    },
    {
      "<leader>no",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "NeoTest Output Open",
      silent = true,
      noremap = true,
    },
    {
      "<leader>np",
      function()
        require("neotest").output_panel.open()
      end,
      desc = "NeoTest Panel Open",
      silent = true,
      noremap = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "rouge8/neotest-rust",
    "alfaix/neotest-gtest",
    "rcasia/neotest-bash",
    "thenbe/neotest-playwright",
    {
      "nvim-neotest/neotest-vim-test",
      dependencies = {
        "vim-test/vim-test",
      },
    },
    {
      "folke/neodev.nvim",
      opts = {
        {
          library = {
            enabled = true,
            runtime = true,
            types = true,
            plugins = true,
          },
          setup_jsonls = true,
          override = function(root_dir, options) end,
          lspconfig = true,
          pathStrict = true,
        },
      },
    },
  },
}
