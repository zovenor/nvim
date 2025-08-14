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
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	{ "datsfilipe/vesper.nvim" },
	{ "arturgoms/moonbow.nvim" },
	{
		"ficcdaf/ashen.nvim",
		lazy = false,
		opts = {
			transparent = true,
		},
	},
}
