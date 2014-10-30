Class = {}

-- default (empty) constructor
function Class:init(...) end

-- create a subclass
function Class:extend(obj)
	local obj = obj or {}

	local function copyTable(table, destination)
		local table = table or {}
		local result = destination or {}

		for k, v in pairs(table) do
			if not result[k] then
				if type(v) == "table" and k ~= "__index" and k ~= "__newindex" then
					result[k] = copyTable(v)
				else
					result[k] = v
				end
			end
		end

		return result
	end

	copyTable(self, obj)

	obj._ = obj._ or {}

	local mt = {}

	-- create new objects directly, like o = Object()
	mt.__call = function(self, ...)
		return self:new(...)
	end

	-- allow for getters and setters
	mt.__index = function(table, key)
		local val = rawget(table._, key)
		if val and type(val) == "table" and (val.get or val.value) then
			if val.get then
				if type(val.get) == "function" then
					return val.get(table, val.value)
				else
					return val.get
				end
			elseif val.value then
				return val.value
			end
		else
			return val
		end
	end

	mt.__newindex = function(table, key, value)
		if type(value) == "table" and (value.value or value.get or value.set) then
			-- dumb hack so we can override static setters
			-- with a new setter without calling
			-- the superclass setter
			table._[key] = value
			return
		end

		local val = rawget(table._, key)
		if val and type(val) == "table" and (val.set or val.value) then
			local v = value
			if val.set then
				if type(val.set) == "function" then
					v = val.set(table, value, val.value)
				else
					v = val.set
				end
			end
			val.value = v
			if val and val.afterSet then val.afterSet(table, v) end
		else
			table._[key] = value
		end
	end

	setmetatable(obj, mt)

	return obj
end

-- set properties outside the constructor or other functions
function Class:set(prop, value)
	if not value and type(prop) == "table" then
		for k, v in pairs(prop) do
			self._[k] = v
		end
	else
		self._[prop] = value
	end
end

-- create an instance of an object with constructor parameters
function Class:new(...)
	obj = self:extend({})
	if obj.init then obj:init(...) end
	return obj
end


function class(attr)
	attr = attr or {}
	return Class:extend(attr)
end
