local event_handler = {}
local event = require("nui.utils.autocmd").event

--- @param popup NuiPopup
function event_handler.subscribe(popup)
	popup:on({ event.BufLeave }, function()
		popup:unmount()
	end, { once = true })
end

return event_handler
