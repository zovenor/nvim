-- File: ~/.config/nvim/lua/plugins/haskell.lua

return {
	"mrcjkb/haskell-tools.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	ft = { "haskell", "lhaskell", "daml" },

	-- 'init' выполняется ДО загрузки плагина, что идеально для установки глобальной переменной
	init = function()
		-- Шаг 1: Настраиваем .daml файлы (как и раньше)
		vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
			pattern = "*.daml",
			callback = function()
				vim.bo.filetype = "haskell"
			end,
		})

		-- Шаг 2: Конфигурируем плагин через глобальную переменную vim.g.haskell_tools
		vim.g.haskell_tools = {
			-- Настройки для Haskell Language Server
			hls = {
				-- Указываем, что HLS должен работать с daml файлами
				filetypes = { "haskell", "lhaskell", "daml" },

				-- Здесь вы можете добавить другие настройки для HLS, например, on_attach
				on_attach = function(client, bufnr)
					-- Ваши настройки при подключении LSP: маппинги клавиш и т.д.
					-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
				end,
			},
			-- Сюда можно добавить другие опции из документации (dap, tools и т.д.)
			-- tools = { ... }
		}
	end,
}
