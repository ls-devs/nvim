local M = {}

M.config = function()
  vim.g.gitblame_highlight_group = "Blame"
  vim.g.gitblame_message_template = "|   <author> • <date> • <summary>"
  vim.g.gitblame_message_when_not_committed = "|   Not commited Yet"
  vim.g.gitblame_date_format = "%x"
  vim.g.gitblame_delay = 1000
  require("gitblame").setup({
    enabled = true,
  })
end

return M
