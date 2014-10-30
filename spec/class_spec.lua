require "class"

describe("class() function", function()
	it("creates a new class", function()
		local A = class()
		assert.same(Class:extend(), A)
	end)
end)

describe("set() function", function()
	it("sets one property/value", function()
		local A = class()
		A:set("prop", "value")

		local a = A()

		assert.equal("value", a.prop)
	end)

	it("sets multiple properties/values", function()
		local A = class()
		A:set{
			prop = "value",
			prop2 = "value2"
		}

		local a = A()

		assert.equal("value", a.prop)
		assert.equal("value2", a.prop2)
	end)
end)
