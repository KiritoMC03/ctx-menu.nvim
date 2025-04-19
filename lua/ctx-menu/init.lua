--- @class CtxMenu
local CtxMenu = {}
local markup = require("ctx-menu.markup")

--- @return boolean ok
local function check_deps()
	local ok, _ = pcall(require, "nui.popup")
	if not ok then
		vim.notify("[CtxMenu] Missing dependency: 'nui'", vim.log.levels.ERROR)
	end
	return ok
end

--- @param items Item[]
--- @param parent_winid? number
local function render(items, parent_winid)
	local Popup = require("nui.popup")
	local Line = require("nui.line")
	local event = require("nui.utils.autocmd").event

	local popup
	if parent_winid then
		popup = markup.child(#items, parent_winid)
	else
		popup = markup.root(#items)
	end

	popup:mount()

	local is_root = parent_winid == nil
	-- local has_children = nodes.
	local lines = {}

	for _, node in ipairs(items) do
		local line = Line()
		line:append(node.name, "Normal")
		table.insert(lines, line)
	end

	for i, line in ipairs(lines) do
		line:render(popup.bufnr, -1, i, 0)
	end

	popup:map("n", "q", function()
		popup:unmount()
	end)
	popup:map("n", "<Esc>", function()
		popup:unmount()
	end)
	popup:map("n", "<CR>", function ()
		if is_root then
			
		end
	end)
	popup:on({ event.BufLeave }, function()
		popup:unmount()
	end, { once = true })
end

--- @param items Item[]
function CtxMenu.show(items)
	if not check_deps() then
		return
	end

	render(items)
end

return CtxMenu
