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
--- @param parent_winid number
function markup.child(height, parent_winid)
	local Popup = require("nui.popup")
	return Popup(extend(
		"force",
		default_popup(height),
		{
			relative = {
				type = "win",
				winid = parent_winid,
			},
			position = 0,
		}
	))
end

return markup
