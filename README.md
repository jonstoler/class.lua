# class.lua

<img src="https://travis-ci.org/jonstoler/class.lua.svg" />

Make lua Object-Oriented!

	require "class"
	
	Dog = class()
	function Dog:bark()
		print "woof!"
	end

	SleepyDog = Dog:extend()
	function SleepyDog:bark()
		print "snore!"
	end

	local d = Dog()
	local s = SleepyDog()
	d:bark()
	s:bark()

### Features

- simple usage & implementation
- small (one file, just over 100 lines, about 2KB)
- support for static and instance properties
- easy inline getters/setters

## Usage

### Creating a class

Classes can be created with the `class()` function or by creating a subclass of `Class`. Classes are just like any other lua variable. They can be local or global. I recommend using CapitalCamelCase names and creating classes globally. This way, you can give classes their own files and it's easy to import them into any other files that need them.

	-- these are the same thing
	MyAwesomeClass = class()
	MyAwesomeClass = Class:extend()

### Creating a subclass

Subclasses can be created with the `extend()` function. They inherit all properties from their parent classes. 

You can also use the `class()` function, with a parent class as a parameter.

	-- these are the same thing
	MySubClass = MyAwesomeClass:extend()
	MySubClass = class(MyAwesomeClass)

### Setting properties

Sometimes it's useful to set class properties outside of a constructor (especially for inheritance). You can use the `set()` function for this, with either one key/value pair or a table.

	MyAwesomeClass:set("property", "value")
	MyAwesomeClass:set{
		property1 = "value1",
		property2 = "value2",
	}

### Static properties

Static properties can be added to the class itself.

	MyAwesomeClass.staticProperty = 3

Static properties have the same features as other properties (getters/setters, inheritance, etc.)

### Creating a constructor

The `init` function is called when your class is initialized. It takes an arbitrary number of arguments.

	function MyAwesomeClass:init(a, b, c)
		self.sum = a + b + c
	end

### Creating an instance of a class

You can create a new instance of your class with the `new()` function, or by simply calling the class name as a function. Pass constructor arguments to this function.

	-- these are the same
	local awesome = MyAwesomeClass:new(1, 2, 3)
	local awesome = MyAwesomeClass(1, 2, 3)

	print(awesome.sum) --> 6

### Getters/Setters

Getters and setters are declared by setting a property to a table with fields `get` and/or `set`.

#### Constant getters/setters

If you set the value of `get` or `set` to a constant, that will be used instead of the actual property.

The value for this property is stored in the `value` key of this table, if appropriate.

	MyAwesomeClass:set{
		property = {
			get = "getConstant",
		},
		property2 = {
			value = "unset",
			set = "setConstant",
		}
	}

	local c = MyAwesomeClass()
	print(c.property) --> "getConstant"
	print(c.property2) --> "unset"
	c.property2 = "this value will be overridden!"
	print(c.property2) --> "setConstant"

#### Getter/Setter functions

If you set the value of `get` or `set` to a function, that will be called and the result will be used.

The `get` function takes two arguments: `self` and the current value of the property being accessed (`value` key in the table).

The `set` function takes three arguments: `self`, the new value, and the current value of the property being set. The `value` key will be automatically changed to the result of this function.

	MyAwesomeClass:set{
		a = "something",
		property = {
			value = "v",
			get = function(self, value) return self.a .. value end
		},
		property2 = {
			value = 3,
			set = function(self, newVal, oldVal) return newVal * oldVal end
		}
	}

	local c = MyAwesomeClass()
	print(c.property) --> "somethingv"
	c.property2 = 6
	print(c.property2) --> 18

#### Setter callbacks

If the `afterSet` key (must be a function!) is set, it will be called after a value is changed. It takes two arguments: `self` and the current value of the variable (after the setter has already been called).

This is useful for systems that require updating when specific values change (eg text that must reformat itself after a window is resized).

## Privacy

There is no built-in mechanism for private or protected variables. These features would bloat the code and make it very difficult to maintain. Instead, I recommend you treat all variable names that start with an underscore (`_privateProperty`) as private. It's up to you to make sure you don't access these properties when you shouldn't.

## Reserved Values

The following are special properties/functions that you should not use for other purposes in your classes, because the class library itself uses them:

	-- GLOBALS
	Class
	class()

	-- CLASS PROPERTIES/METHODS
	_
	new()
	init()
	extend()
	set()
	__index metatable
	__newindex metatable
	"get", "set", "afterSet", or "value" keys in a table property
