vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Theme
vim.cmd([[colorscheme catppuccin]])

vim.diagnostic.config({
	virtual_text = {
		prefix = "✘",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
})

local function find_project_root()
	local current_file_dir = vim.fn.expand("%:p:h")
	local root = vim.fn.finddir(".git", current_file_dir .. ";")
	if root ~= "" and root ~= nil then
		return vim.fn.fnamemodify(root, ":h")
	end
	return vim.fn.getcwd()
end

local function grep_and_send_to_quickfix()
	vim.ui.input({ prompt = "Template for grep: " }, function(pattern)
		if not pattern or pattern == "" then
			print("Grep calceled: template not specified")
			return
		end

		local project_root = find_project_root()

		vim.ui.input({
			prompt = "Path to dirrectory: ",
			default = project_root,
			completion = "dir",
		}, function(path)
			if not path or path == "" then
				print("Grep canceled: path not specified")
				return
			end

			local cmd_parts = {
				"grep",
				"-rnH",
				"--binary-files=without-match",
				"--exclude-dir=.git",
				pattern,
				path,
			}

			print("Search is in progress...")

			local results = {}
			local job_id = vim.fn.jobstart(cmd_parts, {
				stdout_buffered = true,
				on_stdout = function(_, data)
					if data then
						for _, line in ipairs(data) do
							if line ~= "" then
								table.insert(results, line)
							end
						end
					end
				end,
				on_exit = function(_, code)
					vim.schedule(function()
						if code > 1 then
							print("Grep execution error! Error code: " .. code)
							print("Command: " .. table.concat(cmd_parts, " "))
							return
						end

						if #results == 0 then
							print("Nothing found for the template: '" .. pattern .. "' in dirrectory: " .. path)
							return
						end

						vim.fn.setqflist({}, "r", {
							title = "Grep results for '" .. pattern .. "'",
							lines = results,
						})

						print("Found " .. #results .. " results. Open in quickfix...")

						vim.cmd("copen")
					end)
				end,
			})

			if not job_id or job_id <= 0 then
				print("Failed to start grep process")
			end
		end)
	end)
end

vim.api.nvim_create_user_command("GrepToQuickfix", grep_and_send_to_quickfix, {
	nargs = 0,
	desc = "Execute grep in dirrectory and send to quickfix",
})
