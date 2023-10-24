local M = {}

M.config = function()
  local banned_messages = { "No information available" }
  vim.notify = function(msg, ...)
    for _, banned in ipairs(banned_messages) do
      if msg == banned then
        return
      end
    end
    return require("notify")(msg, ...)
  end
  require("notify").setup({
    background_colour = "#000000",
    top_down = false,
  })
end

return M
