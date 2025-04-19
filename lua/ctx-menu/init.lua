--- @class CtxMenuItem
--- @field name string
--- @field func function
--- @field childred? CtxMenuItem[]

--- @class CtxMenu
local CtxMenu = {}
local markup = require("ctx-menu.markup")
local mappings = require("ctx-menu.mappings")
local event_handler = require("ctx-menu.event_handler")
local builder = require("ctx-menu.builder")

--- @return boolean ok
local function check_deps()
	local ok, _ = pcall(require, "nui.popup")
	if not ok then
		vim.notify("[CtxMenu] Missing dependency: 'nui'", vim.log.levels.ERROR)
	end
	return ok
end

--- @param item CtxMenuItem
--- @param max_length number
--- @return NuiLine line
local function build_line(item, max_length)
	local Line = require("nui.line")
	local line = Line()

	local txt = item.name
	if item.childred ~= nil and #item.childred > 0 then
		while txt:len() < max_length - 2 do
			txt = txt .. " "
		end
		txt = txt .. ">"
	end

	line:append(txt, "Normal")
	return line
end

--- @param items CtxMenuItem[]
--- @param parent_winid? number
local function render(items, parent_winid)
	local popup
	local clicked = function(linenr)
		local item = items[linenr]
		if item.childred == nil or #item.childred == 0 then
			vim.notify("single")
		else
			vim.notify("list")
		end
	end
	if parent_winid then
		popup = markup.child(#items, parent_winid)
		mappings.map_child(popup, clicked)
	else
		popup = markup.root(#items)
		mappings.map_child(popup, clicked)
	end

	event_handler.subscribe(popup)

	popup:mount()

	local lines = {}
	local max_length = popup.win_config.width
	for _, node in ipairs(items) do
		table.insert(lines, build_line(node, max_length))
	end

	for i, line in ipairs(lines) do
		line:render(popup.bufnr, -1, i, 0)
	end
end

--- @param items CtxMenuItem[]
function CtxMenu.show(items)
	if not check_deps() then
		return
	end

	render(items)
end

return CtxMenu
