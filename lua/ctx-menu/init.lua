--- @class CtxMenu
local CtxMenu = {}
local markup = require("ctx-menu.markup")
local mappings = require("ctx-menu.mappings")
local event_handler = require("ctx-menu.event_handler")

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
	local Line = require("nui.line")

	local popup
	if parent_winid then
		popup = markup.child(#items, parent_winid)
		mappings.map_child(popup, function(linenr) end)
	else
		popup = markup.root(#items)
		mappings.map_child(popup, function(linenr) end)
	end

	event_handler.subscribe(popup)

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
end

--- @param items Item[]
function CtxMenu.show(items)
	if not check_deps() then
		return
	end

	render(items)
end

return CtxMenu
