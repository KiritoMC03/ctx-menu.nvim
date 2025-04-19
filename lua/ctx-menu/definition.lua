--- @class Item
--- @field name string
--- @field childred? Item[]

--- @class CtxMenu.Definition
local definition = {}

--- @param items Item[]
--- @return number number
function definition.count_childred(items)
	local names_num = 0
	for _, item in ipairs(items) do
		if item.name ~= nil then
			names_num = names_num + 1
		end
	end
	return names_num
end

--- @param value Item | Item[]
--- @return boolean is_single_item
function definition.is_single_item(value)
	return value.name ~= nil and definition.count_childred(value) == 0
end

--- @param value Item | Item[]
--- @return boolean @is_items_list
function definition.is_items_list(value)
	return value.name == nil and definition.count_childred(value) == #value
end

--- @param name string
--- @param child? Item | Item[]
--- @return Item Item
function definition.create(name, child)
	return {
		name = name,
		childred = child == nil or definition.is_single_item(child) and { child } or child
	}
end

--- @param parent Item
--- @param child? Item | Item[]
function definition.set_child(parent, child)
	if child ~= nil and definition.is_items_list(child) then
		parent.childred = child
	else
		parent.childred = { child }
	end
end

--- @param parent Item
--- @param child Item | Item[]
function definition.append_child(parent, child)
	if definition.is_items_list(child) then
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

return definition
