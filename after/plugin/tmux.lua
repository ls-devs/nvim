local tmux = require("tmux")

if not tmux then
	return
end

tmux.setup({
	copy_sync = {
		enable = true,
	},
	navigation = {
		enable_default_keybindings = true,
	},
	resize = {
		enable_default_keybindings = true,
	},
})
