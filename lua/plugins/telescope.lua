return {
	"nvim-telescope/telescope.nvim",
	opts = {
		defaults = {
			-- Полностью отключаем preview и результаты
			layout_config = {
				height = 1, -- Только строка ввода
				width = 0.9,
				preview_cutoff = 0, -- Отключаем preview
				prompt_position = "top", -- Строка сверху
			},
			sorting_strategy = "ascending",
			border = true,
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		},
		pickers = {
			live_grep = {
				theme = "cursor", -- Минималистичный вид
				only_sort_text = true,
				disable_coordinates = true,
			},
		},
	},
}
