return {
	{
		"ViViDboarder/wombat.nvim",
		dependencies = { { "rktjmp/lush.nvim" } },
		opts = {
			-- You can optionally specify the name of the ansi colors you wish to use
			-- This defaults to nil and will use the default ansi colors for the theme
			ansi_colors_name = nil,
		},
	},
	{
		"ViViDboarder/wombat.nvim",
		dependencies = { { "rktjmp/lush.nvim" } },
		opts = {
			ansi_colors_name = nil,
		},
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		config = function()
			require("github-theme").setup({
				options = {
					-- Compiled file's destination location
					compile_path = vim.fn.stdpath("cache") .. "/github-theme",
					compile_file_suffix = "_compiled", -- Compiled file suffix
					hide_end_of_buffer = true, -- Hide the '~' character at the end of the buffer for a cleaner look
					hide_nc_statusline = true, -- Override the underline style for non-active statuslines
					transparent = true, -- Disable setting bg (make neovim's background transparent)
					terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
					dim_inactive = false, -- Non focused panes set to alternative background
					module_default = true, -- Default enable value for modules
					styles = { -- Style to be applied to different syntax groups
						comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
						functions = "NONE",
						keywords = "NONE",
						variables = "NONE",
						conditionals = "NONE",
						constants = "NONE",
						numbers = "NONE",
						operators = "NONE",
						strings = "NONE",
						types = "NONE",
					},
					inverse = { -- Inverse highlight for different types
						match_paren = false,
						visual = false,
						search = false,
					},
					darken = { -- Darken floating windows and sidebar-like windows
						floats = true,
						sidebars = {
							enable = true,
							list = {}, -- Apply dark background to specific windows
						},
					},
					modules = { -- List of various plugins and additional options
						-- ...
					},
				},
				palettes = {},
				specs = {},
				groups = {},
			})
		end,
	},
	{ "datsfilipe/vesper.nvim" },
	{ "arturgoms/moonbow.nvim" },
	{
		"ficcdaf/ashen.nvim",
		lazy = false,
		opts = {
			transparent = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = {},
	},
	{ "rebelot/kanagawa.nvim" },
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			transparent_background = true,
		},
	},
	{ "jaredgorski/spacecamp" },
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			term_colors = true,
			transparent_background = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#000000",
				},
			},
			integrations = {
				dropbar = {
					enabled = true,
					color_mode = true,
				},
			},
		},
	},
}
