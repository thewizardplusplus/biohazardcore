-- luacheck: no max comment line length

---
-- @classmod GameSettings

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local FieldSettings = require("biohazardcore.models.fieldsettings")

local GameSettings = middleclass("GameSettings")
GameSettings:include(Nameable)
GameSettings:include(Stringifiable)

---
-- @function schema
-- @static
-- @treturn tab JSON Schema for this class
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function GameSettings.static.schema()
  return {
    type = "object",
    required = {"field", "field_part"},
    properties = {
      field = FieldSettings.schema(),
      field_part = FieldSettings.schema(),
    },
  }
end

---
-- @function from_options
-- @static
-- @tparam tab options constructor options conforming to the JSON Schema
--   returned by @{GameSettings.schema|GameSettings.schema()}
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
-- @treturn GameSettings
function GameSettings.static.from_options(options)
  assertions.is_table(options)

  return GameSettings:new(options.field, options.field_part)
end

---
-- @table instance
-- @tfield FieldSettings field
-- @tfield FieldSettings field_part

---
-- @function new
-- @tparam FieldSettings field
-- @tparam FieldSettings field_part
-- @treturn GameSettings
function GameSettings:initialize(field, field_part)
  assertions.is_instance(field, FieldSettings)
  assertions.is_instance(field_part, FieldSettings)

  self.field = FieldSettings:new(
    field.size,
    field.initial_offset,
    field.filling,
    field.count_range
  )
  self.field_part = FieldSettings:new(
    field_part.size,
    field_part.initial_offset,
    field_part.filling,
    field_part.count_range
  )
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function GameSettings:__data()
  return {
    field = self.field,
    field_part = self.field_part,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

return GameSettings
