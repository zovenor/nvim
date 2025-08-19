vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Theme
vim.cmd([[colorscheme spacecamp]])

-- Quickfix Telescope
vim.api.nvim_create_user_command("TelescopeQF", function()
	require("telescope.builtin").git_files({
		attach_mappings = function(_, map)
			map("i", "<C-q>", function(prompt_bufnr)
				require("telescope.actions").send_to_qflist(prompt_bufnr)
				vim.cmd("copen")
			end)
			return true
		end,
	})
end, {})

vim.diagnostic.config({
	virtual_text = {
		prefix = "✘",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
})
