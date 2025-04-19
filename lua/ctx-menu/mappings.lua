local mappings = {}

--- @param popup NuiPopup
--- @param clicked function<number>
function mappings.map_defaults(popup, clicked)
	popup:map("n", "q", function()
		popup:unmount()
	end)
	popup:map("n", "<Esc>", function()
		popup:unmount()
	end)
	popup:map("n", "<CR>", function()
		local row, _ = vim.api.nvim_win_get_cursor(popup.winid)
		clicked(row)
	end)
end

--- @param popup NuiPopup
--- @param clicked function<number>
function mappings.map_root(popup, clicked)
	mappings.map_defaults(popup, clicked)
end

--- @param popup NuiPopup
--- @param clicked function<number>
function mappings.map_child(popup, clicked)
	mappings.map_defaults(popup, clicked)
end

return mappings
