local markup = {}

--- @type function
local extend = vim.tbl_deep_extend

--- @param height number
--- @return table
local function default_popup(height)
	return {
		border = {
			style = "rounded",
		},
		size = {
			width = 25,
			height = height,
		},
		enter = true,
		focusable = true,
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	}
end

--- @param height number
function markup.root(height)
	local Popup = require("nui.popup")
	return Popup(extend(
		"force",
		default_popup(height),
		{
			relative = "cursor",
			position = 0,
		}
	))
end

--- @param height number
--- @param parent_popup CtxMenu.Popup
--- @param parent_linern number
function markup.child(height, parent_popup, parent_linern)
	local Popup = require("nui.popup")
	return Popup(extend(
		"force",
		default_popup(height),
		{
			relative = {
				type = "win",
				winid = parent_popup.as_nui.winid,
			},
			position = {
				row = parent_linern - 2,
				col = parent_popup.as_nui.win_config.width,
			},
		}
	))
end

return markup
