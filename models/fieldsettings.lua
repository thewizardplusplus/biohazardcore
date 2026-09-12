-- luacheck: no max comment line length

---
-- @classmod FieldSettings

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")

local FieldSettings = middleclass("FieldSettings")
FieldSettings:include(Nameable)
FieldSettings:include(Stringifiable)

---
-- @function schema
-- @static
-- @treturn tab JSON Schema for this class
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function FieldSettings.static.schema()
  return {
    type = "object",
    required = {"size", "initial_offset", "filling", "count_range"},
    properties = {
      size = Size.schema(),
      initial_offset = Vector2D.schema(),
      filling = { type = "number", minimum = 0, maximum = 1 },
      count_range = Range.schema(),
    },
  }
end

---
-- @function from_options
-- @static
-- @tparam tab options constructor options conforming to the JSON Schema
--   returned by @{FieldSettings.schema|FieldSettings.schema()}
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
-- @treturn FieldSettings
function FieldSettings.static.from_options(options)
  assertions.is_table(options)

  return FieldSettings:new(
    options.size,
    options.initial_offset,
    options.filling,
    options.count_range
  )
end

---
-- @table instance
-- @tfield Size size
-- @tfield Vector2D initial_offset
-- @tfield number filling [0, 1]
-- @tfield Range count_range cell count range

---
-- @function new
-- @tparam Size size
-- @tparam[opt=Vector2D.ZERO] Vector2D initial_offset
-- @tparam[optchain=0.5] number filling [0, 1]
-- @tparam[optchain=Range:new(0, math.huge)] Range count_range cell count range
-- @treturn FieldSettings
function FieldSettings:initialize(size, initial_offset, filling, count_range)
  initial_offset = initial_offset or Vector2D.ZERO
  filling = filling or 0.5
  count_range = count_range or Range:new(0, math.huge)

  assertions.is_instance(size, Size)
  assertions.is_instance(initial_offset, Vector2D)
  assertions.is_number(filling)
  assertions.is_instance(count_range, Range)

  self.size = Size:new(size.width, size.height)
  self.initial_offset = Vector2D:new(initial_offset.x, initial_offset.y)
  self.filling = filling
  self.count_range = Range:new(count_range.min, count_range.max)
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function FieldSettings:__data()
  return {
    size = self.size,
    initial_offset = self.initial_offset,
    filling = self.filling,
    count_range = self.count_range,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

return FieldSettings
