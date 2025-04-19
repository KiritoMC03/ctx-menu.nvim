local CtxMenu = {}

--- @return boolean ok
local function check_deps()
	local ok, _ = pcall(require, "nui.popup")
	if not ok then
		vim.notify("[CtxMenu] Missing dependency: 'nui'", vim.log.levels.ERROR)
	end
	return ok
end

function CtxMenu.show()
	if not check_deps() then
		return
	end

	local Popup = require("nui.popup")
end

return CtxMenu
