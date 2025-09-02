local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.default_capabilities()

local on_attach = function(client, bufnr)
	local buf_map = function(mode, lhs, rhs, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	buf_map("n", "gd", vim.lsp.buf.definition)
	buf_map("n", "K", vim.lsp.buf.hover)
	buf_map("n", "gr", vim.lsp.buf.references)
	buf_map("n", "<leader>rn", vim.lsp.buf.rename)
	buf_map("n", "<leader>ca", vim.lsp.buf.code_action)
	buf_map("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end)

	buf_map("n", "<leader>d", vim.diagnostic.open_float)
	buf_map("n", "[d", vim.diagnostic.goto_prev)
	buf_map("n", "]d", vim.diagnostic.goto_next)
end

-- lspconfig.gopls.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })

lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
