--- @class CtxMenu.Builder
local builder = {}

--- @param items CtxMenu.Item[]
--- @return number number
local function count_items(items)
	local names_num = 0
	for _, item in ipairs(items) do
		if item.name ~= nil then
			names_num = names_num + 1
		end
	end
	return names_num
end

--- @param value CtxMenu.Item | CtxMenu.Item[]
--- @return boolean is_single_item
local function is_single_item(value)
	return value.name ~= nil and count_items(value) == 0
end

--- @param value CtxMenu.Item | CtxMenu.Item[]
--- @return boolean @is_items_list
local function is_items_list(value)
	return value.name == nil and count_items(value) == #value
end

--- @param name string
--- @param func function
--- @return CtxMenu.Item Item
function builder.create(name, func)
	return {
		name = name,
		func = func,
		childred = nil,
	}
end

--- @param name string
--- @param child CtxMenu.Item | CtxMenu.Item[]
--- @return CtxMenu.Item Item
function builder.create_dropdown(name, child)
	if child ~= nil and is_single_item(child) then
		child = { child }
	end
	return {
		name = name,
		func = nil,
		childred = child,
	}
end

--- @param parent CtxMenu.Item
--- @param child? CtxMenu.Item | CtxMenu.Item[]
function builder.set_child(parent, child)
	if child ~= nil and is_items_list(child) then
		parent.childred = child
	else
		parent.childred = { child }
	end
end

--- @param parent CtxMenu.Item
--- @param child CtxMenu.Item | CtxMenu.Item[]
function builder.append_child(parent, child)
	if is_items_list(child) then
		if parent.childred == nil then
			parent.childred = { child }
		else
			for _, c in ipairs(child) do
				table.insert(parent.childred, c)
			end
		end
	elseif parent.childred == nil then
		parent.childred = { child }
	else
		table.insert(parent.childred, child)
	end
end

return builder
