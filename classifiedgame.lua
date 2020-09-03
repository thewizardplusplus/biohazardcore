---
-- @classmod ClassifiedGame

local middleclass = require("middleclass")
local types = require("lualife.types")
local CellClassification = require("biohazardcore.models.cellclassification")
local sets = require("lualife.sets")

local ClassifiedGame = middleclass("ClassifiedGame")

---
-- @table instance
-- @tfield GameSettings _settings
-- @tfield lualife.models.PlacedField _field
-- @tfield lualife.models.PlacedField _field_part

---
-- @function new
-- @tparam GameSettings settings
-- @treturn ClassifiedGame
function ClassifiedGame:initialize(settings)
  assert(types.is_instance(settings, GameSettings))

  Game.initialize(self, settings)
end

---
-- @treturn CellClassification
function ClassifiedGame:classify_cells()
  local old = sets.complement(self._field, self._field_part)
  local new = sets.complement(self._field_part, self._field)
  local intersection = sets.intersection(game._field, game._field_part)
  return CellClassification:new(old, new, intersection)
end

return ClassifiedGame
