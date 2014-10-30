require "class"

describe("instances", function()
	it("can be created with new()", function()
		local A = class()

		local a = A:new()
		assert.same(class(), a)
	end)

	it("can be created with __call()", function()
		local A = class()

		local a = A()
		assert.same(class(), a)
	end)

	it("are independent", function()
		local A = class{key = "value"}
		local a = A()
		local aa = A()
		a.key = "other value"
		assert.equal("other value", a.key)
		assert.equal("value", aa.key)
	end)

	it("are equal", function()
		local A = class{key = "value"}
		local a = A()
		local aa = A()
		assert.same(a, aa)
	end)
end)

describe("constructors", function()
	it("can be defined by init()", function()
		local A = class{value = 0}
		function A:init(val)
			self.value = val
		end

		local a = A(3)
		assert.equal(3, a.value)
	end)
end)

describe("getters", function()
	it("return values", function()
		local A = class()
		function A:init()
			self.foo = { get = "bar" }
		end

		local a = A()
		assert.equal("bar", a.foo)
	end)

	it("return results of functions", function()
		local A = class()
		function A:init()
			self.foo = { get = function() return "bar" end }
		end

		local a = A()
		assert.equal("bar", a.foo)
	end)

	it("pass 'value' to 'get' function", function()
		local A = class()
		function A:init()
			self.foo = { value = "bar", get = function(self, v) return v:rep(2) end }
		end

		local a = A()
		assert.equal("barbar", a.foo)
	end)

	it("default to 'value' if 'get' is not defined", function()
		local A = class()
		function A:init()
			self.foo = { value = "bar" }

			local a = A()
			assert.equal("bar", a.foo)
		end
	end)
end)

describe("setters", function()
	it("use values", function()
		local A = class()
		function A:init()
			self.foo = { set = "bar" }
		end

		local a = A()
		a.foo = "something else"

		assert.equal("bar", a.foo)
	end)

	it("use results of functions", function()
		local A = class()
		function A:init()
			self.foo = { set = function() return "bar" end }
		end

		local a = A()
		a.foo = "something else"

		assert.equal("bar", a.foo)
	end)

	it("pass new value, 'value' to set function", function()
		local A = class()
		function A:init()
			self.foo = { value = "bar", set = function(self, new, old) return old .. new end}
		end

		local a = A()
		a.foo = "bar2"

		assert.equal("barbar2", a.foo)
	end)

	it("sets 'value'", function()
		local A = class()
		function A:init()
			self.foo = { value = "bar", set = function(self, new) return new end }
		end

		local a = A()
		a.foo = "bar2"

		assert.equal("bar2", a._.foo.value)
	end)

	it("can be used as a callback", function()
		local b = 1

		local A = class()
		function A:init()
			self.foo = { set = function(self, v) return v end, afterSet = function(self) b = 2 end }
		end

		local a = A()
		a.foo = "set"
		assert.equal(2, b)
	end)
end)
