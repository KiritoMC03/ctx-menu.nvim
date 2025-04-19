local CtxMenu = {}

--- @return boolean ok
local function check_deps()
	local ok, nui = pcall(require, "nui.popup")
	if not ok then
		vim.notify("[CtxMenu] Missing dependency: 'nui'", vim.log.levels.ERROR)
	end
	return ok
end

function CtxMenu.init()
	vim.notify("init")
end

function CtxMenu.show()
	vim.notify("Hello")
end

return CtxMenu
