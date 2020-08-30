---
-- @classmod Game

local middleclass = require("middleclass")
local types = require("lualife.types")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")
local GameSettings = require("biohazardcore.models.gamesettings")
local random = require("lualife.random")

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
    settings.field.size,
    settings.field.initial_offset
  )
  self._field_part = random.generate_with_limits(
    field_part_sample,
    settings.field_part.filling,
    settings.field_part.minimal_count,
    settings.field_part.maximal_count
  )
end

return Game
