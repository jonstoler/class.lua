require "class"

describe("static variables", function()
	it("can be created and accessed", function()
		local A = class()
		A.static = "static variable"
		
		assert.equal(A.static, "static variable")
	end)

	it("can be inherited", function()
		local A = class()
		A.static = "static variable"

		local B = A:extend()

		assert.equal("static variable", A.static)
		assert.equal("static variable", B.static)
	end)

	it("can be overridden", function()
		local A = class()
		A.static = "static variable"

		local B = A:extend()
		B.static = "overridden static"

		assert.equal("static variable", A.static)
		assert.equal("overridden static", B.static)
	end)
end)

describe("static getters", function()
	it("can be created and used", function()
		local A = class()
		A.static = {
			get = function() return "static getter" end
		}

		assert.equal("static getter", A.static)
	end)

	it("can be inherited", function()
		local A = class()
		A.static = {
			get = function() return "static getter" end
		}

		local B = A:extend()

		local C = A:extend()

		assert.equal("static getter", A.static)
		assert.equal("static getter", B.static)
		assert.equal("static getter", C.static)
	end)

	it("can be overridden", function()
		local A = class()
		A.static = {
			get = function() return "static getter" end
		}

		local B = A:extend()
		B.static = {
			get = function() return "overridden getter" end
		}

		assert.equal("static getter", A.static)
		assert.equal(B.static, "overridden getter")
	end)
end)

describe("static setters", function()
	it("can be created and used", function()
		local A = class()
		A.static = {
			value = 1,
			set = function(self, newVal, oldVal)
				return oldVal + newVal
			end
		}

		A.static = 2
		assert.equal(3, A.static)
	end)

	it("can be inherited", function()
		local A = class()
		A.static = {
			value = 1,
			set = function(self, newVal, oldVal)
				return oldVal + newVal
			end
		}

		local B = A:extend()

		A.static = 2
		B.static = 3
		assert.equal(4, B.static)
		assert.equal(3, A.static)
	end)

	it("can be overridden", function()
		local A = class()
		A.static = {
			value = 1,
			set = function(self, newVal, oldVal)
				return oldVal + newVal
			end
		}

		--[[
		-- note: overriding static setters normally
		-- turned out to be a huge pain, because
		-- the new setter would call the old one,
		-- removing the transparency of the setter.
		--
		-- here's the work-around (using rawset under the hood):
		--]]
		local B = A:extend()
		B.set(B, "static", {
			value = 1,
			set = function(self, newVal, oldVal)
				return newVal * oldVal
			end
		})

		A.static = 2
		B.static = 2

		assert.equal(2, B.static)
		assert.equal(3, A.static)
	end)
end)
