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

-------------------- Trouble --------------------
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=true<cr>", { desc = "Symbols (Trouble)" })

-------------------- Quickfix --------------------

-- Grep search
map("n", "<leader><leader>", "<CMD>GrepToQuickfix<CR>")

--Convert LSP diagnostics severity to quickfix type
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

-------------------- Gitsigns --------------------
map("n", "F", "<CMD>Gitsigns preview_hunk<CR>", { desc = "Open git preview hunk" })
map("n", "<leader>F", "<CMD>Gitsigns setqflist<CR>", { desc = "Open git quickfix" })

-------------------- Workspaces --------------------
local workspaces = require("workspaces")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event
map("n", "<leader>wo", "<CMD>WorkspacesOpen<CR>", { desc = "Open workspace" })
map("n", "<leader>wa", "<CMD>WorkspacesAdd<CR>", { desc = "Add workspace" })
map("n", "<leader>wA", "<CMD>WorkspacesAddDir<CR>", { desc = "Add workspaces from dir" })
map("n", "<leader>wr", "<CMD>WorkspacesRemove<CR>", { desc = "Remove workspace" })
map("n", "<leader>wR", "<CMD>WorkspacesRemoveDir<CR>", { desc = "Remove workspaces from current dir" })
map("n", "<leader>wl", function()
	--- Step 1: Fetch ALL entries from workspaces.nvim.
	-- This single list contains both your projects and the root directories you added with :WorkspacesAddDir.
	local all_entries = workspaces.get()

	-- Defensive check
	if not all_entries or vim.tbl_isempty(all_entries) then
		vim.notify("No workspaces found.", vim.log.levels.WARN)
		return
	end

	--- Step 2: Programmatically identify which entries are the root directories.
	-- A directory is a "root" if its path is a prefix of another entry's path.
	local root_dirs = {}
	local root_dir_paths = {} -- Use a set for quick lookups
	for _, potential_root in ipairs(all_entries) do
		for _, other_entry in ipairs(all_entries) do
			if
				potential_root.path ~= other_entry.path
				and string.find(other_entry.path, potential_root.path, 1, true) == 1
			then
				-- We found that `potential_root` is a parent of `other_entry`.
				-- Mark it as a root directory and break the inner loop.
				if not root_dir_paths[potential_root.path] then
					table.insert(root_dirs, potential_root)
					root_dir_paths[potential_root.path] = true
				end
				break
			end
		end
	end

	--- Step 3: Group the projects under their identified root directories.
	local grouped_workspaces = {}
	local standalone_group_key = "Standalone Projects"
	-- Initialize groups for all identified root directories to ensure they appear in the menu.
	for _, dir in ipairs(root_dirs) do
		grouped_workspaces[dir.path] = {}
	end
	grouped_workspaces[standalone_group_key] = {}

	-- Now, iterate through all entries again and assign the projects to their groups.
	for _, project in ipairs(all_entries) do
		-- We only want to list projects, not the root directories themselves.
		if not root_dir_paths[project.path] then
			local longest_match_path = nil
			local max_len = 0

			-- Find the best (longest) root directory that this project belongs to.
			for _, root in ipairs(root_dirs) do
				if string.find(project.path, root.path, 1, true) == 1 and #root.path > max_len then
					max_len = #root.path
					longest_match_path = root.path
				end
			end

			if longest_match_path then
				table.insert(grouped_workspaces[longest_match_path], project)
			else
				table.insert(grouped_workspaces[standalone_group_key], project)
			end
		end
	end

	--- Step 4: Prepare the lines for the NuiMenu (sorting, formatting).
	local menu_lines = {}
	local group_keys = {}
	-- Create a lookup map from path to the root directory's name for prettier separators.
	local path_to_name_map = {}
	for _, dir in ipairs(root_dirs) do
		path_to_name_map[dir.path] = dir.name
	end

	for path, workspaces_in_group in pairs(grouped_workspaces) do
		if not vim.tbl_isempty(workspaces_in_group) then
			table.insert(group_keys, path)
		end
	end
	table.sort(group_keys)

	for _, group_path in ipairs(group_keys) do
		local separator_name = path_to_name_map[group_path] or standalone_group_key
		table.insert(menu_lines, Menu.separator(separator_name))

		local workspaces_in_group = grouped_workspaces[group_path]
		table.sort(workspaces_in_group, function(a, b)
			return a.name < b.name
		end)

		for _, ws in ipairs(workspaces_in_group) do
			table.insert(menu_lines, Menu.item(ws.name, { data = ws }))
		end
	end

	--- Step 5: Create and display the menu.
	local menu = Menu({
		position = "50%",
		size = {
			width = 60,
			height = #menu_lines + 2,
		},
		border = { style = "rounded", text = { top = "[ Choose Workspace ]", top_align = "center" } },
		win_options = { winhighlight = "Normal:Normal,FloatBorder:Normal" },
	}, {
		lines = menu_lines,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_submit = function(item)
			if item and item.data and item.data.name then
				workspaces.open(item.data.name)
				require("nvim-tree.api").tree.open({
					path = item.data.path,
				})
			end
		end,
	})

	menu:mount()
end, { desc = "Open grouped workspaces menu (correct logic)" })
