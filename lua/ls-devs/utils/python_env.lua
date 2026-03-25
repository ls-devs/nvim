--- python_env.lua
-- Python environment detection helper for DAP and REPL config.
-- Usage: require('ls-devs.utils.python_env').get_python_path()

local M = {}

--- Returns the best Python interpreter path for the current environment.
---@return string
function M.get_python_path()
  local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if venv then
    return venv .. "/bin/python"
  end
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return M
