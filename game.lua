---
-- @classmod Game

local middleclass = require("middleclass")
local types = require("lualife.types")
local Point = require("lualife.models.point")
local GameSettings = require("biohazardcore.models.gamesettings")
local sets = require("lualife.sets")
local matrix = require("lualife.matrix")
local life = require("lualife.life")
local factory = require("biohazardcore.factory")

local Game = middleclass("Game")

---
-- @table instance
-- @tfield GameSettings _settings
-- @tfield lualife.models.Field _field
-- @tfield lualife.models.PlacedField _field_part

---
-- @function new
-- @tparam GameSettings settings
-- @treturn Game
function Game:initialize(settings)
  assert(types.is_instance(settings, GameSettings))

  self._settings = settings
  self._field = factory.create_field(settings.field)
  self._field_part = factory.create_field(settings.field_part)
end

---
-- @tparam Point delta_offset
function Game:move(delta_offset)
  assert(types.is_instance(delta_offset, Point))

  local field_part_offset_next = self._field_part.offset:translate(delta_offset)
  local field_part_next = PlacedField.place(self._field_part, field_part_offset_next)
  if field_part_next:fits(self._field) then
    self._field_part = field_part_next
  end
end

function Game:rotate()
  self._field_part = matrix.rotate(self._field_part)
end

function Game:union()
  local intersected_field_part = sets.intersection(self._field, self._field_part)
  if intersected_field_part:count() ~= 0 then
    return
  end

  local field_next = sets.union(self._field, self._field_part)
  field_next = life.populate(field_next)

  self._field = field_next
  self._field_part = factory.create_field(settings.field_part)
end

return Game
