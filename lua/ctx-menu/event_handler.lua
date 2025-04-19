local event_handler = {}
local event = require("nui.utils.autocmd").event

--- @param popup CtxMenuPopup
--- @return boolean win_exist
local function parent_exist(popup)
	return popup.parent ~= nil
		and popup.parent.as_nui ~= nil
		and type(popup.parent.as_nui.winid) == "number"
		and vim.api.nvim_win_is_valid(popup.parent.as_nui.winid)
end

--- @param popup CtxMenuPopup
--- @return boolean win_exist
local function child_exist(popup)
	return popup.child ~= nil
		and popup.child.as_nui ~= nil
		and type(popup.child.as_nui.winid) == "number"
		and vim.api.nvim_win_is_valid(popup.child.as_nui.winid)
end

--- @param popup CtxMenuPopup
function event_handler.subscribe(popup)
	local nui_popup = popup.as_nui
	nui_popup:on({ event.BufLeave }, function()
		if not child_exist(popup) then
			nui_popup:unmount()
		end
		if parent_exist(popup) then
			vim.api.nvim_set_current_win(popup.parent.as_nui.winid)
		end
	end, { once = true })
end

return event_handler
