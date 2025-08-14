local map = vim.keymap.set

-------------------- Base --------------------

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map("n", "|", "<CMD>vsplit<CR>")
map("n", "-", "<CMD>split<CR>")
map("n", "<leader>e", "<CMD>:NvimTreeToggle<CR>")
map("n", "<S-u>", "<C-r>")
map("n", "<S-u>", "<C-r>")
map("n", "<leader>h", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>j", "<C-w>j", { desc = "Go to botton window" })
map("n", "<leader>k", "<C-w>k", { desc = "Go to top window" })
map("n", "<leader>l", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>d", "<C-w>c", { desc = "Close current window" })
map("n", "<leader>w", "<CMD>cclose<CR>", { desc = "Close quickfix" })
map("n", "<Tab>", "<cmd>cnext<CR>")
map("n", "<S-Tab>", "<cmd>cprev<CR>")
map("n", "E", vim.diagnostic.open_float, { desc = "Open floating diagnostic" })

-------------------- Codeium --------------------
vim.keymap.set("i", "ff", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })

-------------------- Telescope --------------------

local builtin = require("telescope.builtin")

local telescope_opts = {
	previewer = false,
	layout_config = {
		height = 0.4,
		width = 0.9,
		prompt_position = "top",
	},
	border = true,
	sorting_strategy = "ascending",
}

map("n", "<leader><leader>", function()
	builtin.live_grep(vim.tbl_extend("force", telescope_opts, {
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local action_state = require("telescope.actions.state")
				local picker = action_state.get_current_picker(prompt_bufnr)
				local manager = picker.manager

				local results = {}
				for entry in manager:iter() do
					table.insert(results, {
						filename = entry.filename,
						lnum = entry.lnum,
						col = entry.col or 1,
						text = entry.text or entry.value,
					})
				end

				vim.fn.setqflist({}, "r", {
					title = "Telescope Live Grep",
					items = results,
				})
				require("telescope.actions").close(prompt_bufnr)
				vim.cmd("copen")
			end)
			return true
		end,
	}))
end, { desc = "Live grep → quickfix" })

map("n", "<leader>ff", function()
	builtin.find_files(telescope_opts)
end, { desc = "Find files" })

map("n", "<leader>fb", function()
	builtin.buffers(vim.tbl_extend("force", telescope_opts, {
		attach_mappings = function(_, map)
			map("i", "<C-d>", function(prompt_bufnr)
				local action_state = require("telescope.actions.state")
				local entry = action_state.get_selected_entry()
				vim.api.nvim_buf_delete(entry.bufnr, { force = true })
				require("telescope.actions").close(prompt_bufnr)
			end)
			return true
		end,
	}))
end, { desc = "List buffers" })

-------------------- Trouble --------------------
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=true<cr>", { desc = "Symbols (Trouble)" })

-------------------- Quickfix --------------------

--convert LSP diagnostics severity to quickfix type
local function severityToType(severity)
	local types = { "E", "W", "I", "N" }
	return types[severity] or "I"
end
local function TypeToSeverity(type)
	local severity = {
		E = 0,
		W = 1,
		I = 2,
		N = 3,
	}
	return severity[type] or "I"
end
-- Function to collect LSP diagnostics and put them in quickfix
function LspToQf()
	local diagnostics = vim.diagnostic.get(nil)
	local qf_items = {}
	for _, diagnostic in ipairs(diagnostics) do
		table.insert(qf_items, {
			filename = vim.api.nvim_buf_get_name(diagnostic.bufnr),
			lnum = diagnostic.lnum + 1, -- LSP uses 0-based, quickfix uses 1-based
			col = diagnostic.col + 1, -- LSP uses 0-based, quickfix uses 1-based
			text = diagnostic.message,
			type = severityToType(diagnostic.severity),
		})
	end
	table.sort(qf_items, function(a, b)
		local a_type = TypeToSeverity(a.type)
		local b_type = TypeToSeverity(b.type)
		return a_type < b_type
	end)
	vim.fn.setqflist(qf_items, "r")
	vim.cmd(":copen")
	return #qf_items
end

map("n", "<leader>E", LspToQf, { desc = "LSP diagnostics to quickfix" })

-------------------- DAP ------------------
local dap = require("dap")
local dapui = require("dapui")

map("n", "<F5>", function()
	dap.continue()
end)
map("n", "<F10>", function()
	dap.step_over()
end)
map("n", "<F11>", function()
	dap.step_into()
end)
map("n", "<F12>", function()
	dap.step_out()
end)
map("n", "<leader>b", function()
	dap.toggle_breakpoint()
end)
map("n", "<leader>dr", function()
	dap.repl.toggle()
end)
map("n", "<leader>de", function()
	dapui.eval()
end)
map("n", "<leader>dn", "<CMD>DapNew<Cr>")

-------------------- ToDo comments --------------------
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

map("n", "<leader>T", ":TodoQuickFix<CR>", { desc = "Toggle todo comment" })

-------------------- Diffview --------------------
map("n", "<leader>gd", "<CMD>DiffviewOpen<CR>", { desc = "Open diff" })
map("n", "<leader>gc", "<CMD>DiffviewClose<CR>", { desc = "Close diff" })
map("n", "<leader>gh", "<CMD>DiffviewFileHistory<CR>", { desc = "File history" })
