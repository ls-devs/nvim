return {
	"epwalsh/obsidian.nvim",
	lazy = true,
	ft = "markdown",
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/notes/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/notes/**.md",
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	opts = {
		workspaces = {
			{
				name = "Personal",
				path = "~/notes/personal",
			},
			{
				name = "Work",
				path = "~/notes/work",
			},
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,

		wiki_link_func = function(opts)
			if opts.id == nil then
				return string.format("[[%s]]", opts.label)
			elseif opts.label ~= opts.id then
				return string.format("[[%s|%s]]", opts.id, opts.label)
			else
				return string.format("[[%s]]", opts.id)
			end
		end,

		markdown_link_func = function(opts)
			return string.format("[%s](%s)", opts.label, opts.path)
		end,

		preferred_link_style = "wiki",

		image_name_func = function()
			return string.format("%s-", os.time())
		end,

		disable_frontmatter = false,

		note_frontmatter_func = function(note)
			if note.title then
				note:add_alias(note.title)
			end

			local out = { id = note.id, aliases = note.aliases, tags = note.tags }

			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,

		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			substitutions = {},
		},

		backlinks = {
			height = 10,
			wrap = true,
		},

		tags = {
			height = 10,
			wrap = true,
		},

		follow_url_func = function(url)
			vim.fn.jobstart({ "xdg-open", url })
		end,

		use_advanced_uri = false,

		open_app_foreground = false,

		picker = {
			name = "telescope.nvim",
			mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
		},

		sort_by = "modified",
		sort_reversed = true,

		open_notes_in = "current",

		ui = {
			enable = true,
			update_debounce = 200,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			hl_groups = {
				ObsidianTodo = { bold = true, fg = "#f78c6c" },
				ObsidianDone = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde = { bold = true, fg = "#ff5370" },
				ObsidianBullet = { bold = true, fg = "#89ddff" },
				ObsidianRefText = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},

		attachments = {
			img_folder = "assets/imgs",
			img_text_func = function(client, path)
				local link_path
				local vault_relative_path = client:vault_relative_path(path)
				if vault_relative_path ~= nil then
					link_path = vault_relative_path
				else
					link_path = tostring(path)
				end
				local display_name = vim.fs.basename(link_path)
				return string.format("![%s](%s)", display_name, link_path)
			end,
		},

		yaml_parser = "native",
	},
}
