local mappings = {}

--- @param popup CtxMenu.Popup
--- @param clicked function<number>
function mappings.map_defaults(popup, clicked)
	local nui_popup = popup.as_nui
	nui_popup:map("n", "q", function()
		nui_popup:unmount()
	end)
	nui_popup:map("n", "<Esc>", function()
		nui_popup:unmount()
	end)
	nui_popup:map("n", "<BS>", function()
		nui_popup:unmount()
	end)
	nui_popup:map("n", "<CR>", function()
		local row, _ = unpack(vim.api.nvim_win_get_cursor(nui_popup.winid))
		clicked(row)
	end)
end

--- @param popup CtxMenu.Popup
--- @param clicked function<number>
function mappings.map_root(popup, clicked)
	mappings.map_defaults(popup, clicked)
end

--- @param popup CtxMenu.Popup
--- @param clicked function<number>
function mappings.map_child(popup, clicked)
	mappings.map_defaults(popup, clicked)
end

return mappings
