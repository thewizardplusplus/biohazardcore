---
-- @classmod Game

local middleclass = require("middleclass")
local types = require("lualife.types")
local Stringifiable = require("lualife.models.stringifiable")
local Size = require("lualife.models.size")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")
local GameSettings = require("biohazardcore.models.gamesettings")

local Game = middleclass("Game")
Game:include(Stringifiable)

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
  self._field = Field:new(Size:new(0, 0))
  self._field_part = PlacedField:new(Size:new(0, 0))
end

---
-- @treturn tab table with instance fields
function Game:__data()
  return {
    settings = self._settings:__data(),
    field = self._field:__data(),
    field_part = self._field_part:__data(),
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
-- @see lualife.models.Stringifiable

return Game
