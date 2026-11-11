-- luacheck: no max comment line length

---
-- @classmod ClassifiedGame

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local PlacedField = require("lualife.models.placedfield")
local GameSettings = require("biohazardcore.models.gamesettings")
local CellClassification = require("biohazardcore.models.cellclassification")
local Game = require("biohazardcore.game")
local sets = require("lualife.sets")

local ClassifiedGame = middleclass("ClassifiedGame", Game)

---
-- @function schema
-- @static
-- @treturn tab JSON Schema for this class
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @function from_options
-- @static
-- @tparam tab options constructor options conforming to the JSON Schema
--   returned by @{ClassifiedGame.schema|ClassifiedGame.schema()}
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
-- @treturn ClassifiedGame
function ClassifiedGame.static.from_options(options)
  assertions.is_table(options)

  local game = ClassifiedGame:allocate()
  game.settings =
    GameSettings:new(options.settings.field, options.settings.field_part)
  game._field = PlacedField.place(options.field, options.field:offset())
  game._field_part =
    PlacedField.place(options.field_part, options.field_part:offset())

  return game
end

---
-- @table instance
-- @tfield GameSettings settings
-- @tfield lualife.models.PlacedField _field
-- @tfield lualife.models.PlacedField _field_part

---
-- @function new
-- @tparam GameSettings settings
-- @treturn ClassifiedGame
function ClassifiedGame:initialize(settings)
  assertions.is_instance(settings, GameSettings)

  Game.initialize(self, settings)
end

---
-- @function __data
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @treturn CellClassification
function ClassifiedGame:classify_cells()
  local old = sets.complement(self._field, self._field_part)
  local new = sets.complement(self._field_part, self._field)
  return CellClassification:new(old, new, self:_intersection())
end

---
-- @function count
-- @treturn int

---
-- @function offset
-- @treturn Vector2D

---
-- @function move
-- @tparam Vector2D delta_offset
-- @treturn bool

---
-- @function rotate

---
-- @function union
-- @treturn bool

---
-- @function _intersection
-- @treturn lualife.models.PlacedField

return ClassifiedGame
