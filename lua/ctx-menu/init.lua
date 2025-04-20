--- @class CtxMenuItem
--- @field name string
--- @field func? function
--- @field childred? CtxMenuItem[]

--- @class CtxMenuPopup
--- @field as_nui NuiPopup
--- @field parent? CtxMenuPopup
--- @field child? CtxMenuPopup

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

	line:append(txt)
	return line
end

--- @param items CtxMenuItem[]
--- @param parent_popup? CtxMenuPopup
--- @param parent_linern? number
--- @return CtxMenuPopup popup
local function render(items, parent_popup, parent_linern)
	--- @type CtxMenuPopup
	local popup
	--- @type NuiPopup
	local nui_popup
	local clicked = function(linenr)
		local item = items[linenr]
		if item.childred == nil or #item.childred == 0 then
			pcall(item.func)
		else
			render(item.childred, popup, linenr)
		end
	end
	if parent_popup ~= nil and parent_linern ~= nil then
		popup = {
			as_nui = markup.child(#items, parent_popup, parent_linern),
		}
		popup.parent = parent_popup
		parent_popup.child = popup
		mappings.map_child(popup, clicked)
	else
		popup = {
			as_nui = markup.root(#items),
		}
		mappings.map_root(popup, clicked)
	end

	event_handler.subscribe(popup)

	nui_popup = popup.as_nui
	nui_popup:mount()

	local lines = {}
	local max_length = nui_popup.win_config.width
	for _, node in ipairs(items) do
		table.insert(lines, build_line(node, max_length))
	end

	for i, line in ipairs(lines) do
		line:render(nui_popup.bufnr, -1, i, 0)
	end

	return popup
end

--- @param items CtxMenuItem[]
--- @return CtxMenuPopup | nil popup
function CtxMenu.show(items)
	if not check_deps() then
		return nil
	end

	return render(items)
end

--- @param popup CtxMenuPopup
function CtxMenu.close(popup)
	while popup ~= nil do
		popup.as_nui:unmount()
		popup = popup.child
	end
end

return CtxMenu
