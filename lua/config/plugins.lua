---------- Telescope ----------
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		layout_strategy = "bottom_pane",
		layout_config = {
			height = 0.8,
			width = 0.8,
			prompt_position = "bottom",
			preview_cutoff = 1,
		},
		sorting_strategy = "ascending",
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<CR>"] = actions.select_default + actions.center,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
			},
		},
	},
	pickers = {
		live_grep = {
			theme = "dropdown", -- или "ivy" для минималистичного вида
			layout_config = {
				height = 15,
				width = 0.9,
			},
		},
	},
})
