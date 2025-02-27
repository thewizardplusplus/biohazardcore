-- luacheck: no max comment line length

---
-- @classmod ClassifiedGame

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local GameSettings = require("biohazardcore.models.gamesettings")
local CellClassification = require("biohazardcore.models.cellclassification")
local sets = require("lualife.sets")
local Game = require("biohazardcore.game")

local ClassifiedGame = middleclass("ClassifiedGame", Game)

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
-- @treturn lualife.models.Point

---
-- @function move
-- @tparam lualife.models.Point delta_offset
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
