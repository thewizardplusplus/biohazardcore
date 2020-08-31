---
-- @classmod Game

local middleclass = require("middleclass")
local types = require("lualife.types")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")
local GameSettings = require("biohazardcore.models.gamesettings")
local random = require("lualife.random")
local sets = require("lualife.sets")
local matrix = require("lualife.matrix")
local life = require("lualife.life")

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

  local field_part_sample = PlacedField:new(
    settings.field.size,
    settings.field.initial_offset
  )
  self._field = random.generate_with_limits(
    field_sample,
    settings.field.filling,
    settings.field.minimal_count,
    settings.field.maximal_count
  )

  local field_part_sample = PlacedField:new(
    settings.field_part.size,
    settings.field_part.initial_offset
  )
  self._field_part = random.generate_with_limits(
    field_part_sample,
    settings.field_part.filling,
    settings.field_part.minimal_count,
    settings.field_part.maximal_count
  )
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
  local has_intersection = intersected_field_part:count() ~= 0
  if has_intersection then
    return
  end

  local field_next = sets.union(self._field, self._field_part)
  field_next = life.populate(field_next)
  self._field = field_next

  local field_part_sample = PlacedField:new(
    self._settings.field_part.size,
    self._settings.field_part.initial_offset
  )
  self._field_part = random.generate_with_limits(
    field_part_sample,
    self._settings.field_part.filling,
    self._settings.field_part.minimal_count,
    self._settings.field_part.maximal_count
  )
end

return Game
