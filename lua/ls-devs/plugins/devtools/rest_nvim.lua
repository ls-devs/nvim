return {
  "rest-nvim/rest.nvim",
  ft = "http",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    result_split_horizontal = false,
    result_split_in_place = false,
    skip_ssl_verification = false,
    encode_url = true,
    highlight = {
      enabled = true,
      timeout = 150,
    },
    result = {
      show_url = true,
      show_http_info = true,
      show_headers = true,
      formatters = {
        json = "jq",
        html = function(body)
          return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
        end,
      },
    },

    jump_to_request = false,
    env_file = ".env",
    custom_dynamic_variables = {},
    yank_dry_run = true,
  },
  keys = {
    {
      "<leader>rh",
      function()
        require("rest-nvim").run()
      end,
      desc = "RestNvim",
      noremap = true,
      silent = true,
    },
    {
      "<leader>rl",
      function()
        require("rest-nvim").last()
      end,
      desc = "RestNvimLast",
      noremap = true,
      silent = true,
    },
    {
      "<leader>rp",
      function()
        require("rest-nvim").run(true)
      end,
      desc = "RestNvimPreview",
      noremap = true,
      silent = true,
    },
  },
}
