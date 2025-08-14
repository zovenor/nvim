return {
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "isort" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				go = { "gofumpt", "goimports" },
				-- daml = { "hlint" },
				proto = { "buf", "protolint" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})
	end,
}
