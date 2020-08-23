---
-- @classmod Game

local middleclass = require("middleclass")
local Stringifiable = require("lualife.models.stringifiable")
local Size = require("lualife.models.size")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")

local Game = middleclass("Game")
Game:include(Stringifiable)

---
-- @table instance
-- @tfield lualife.models.Field field
-- @tfield lualife.models.PlacedField field_part

---
-- @function new
-- @treturn Game
function Game:initialize()
  self.field = Field:new(Size:new(0, 0))
  self.field_part = PlacedField:new(Size:new(0, 0))
end

---
-- @treturn tab table with instance fields
function Game:__data()
  return {
    field = self.field:__data(),
    field_part = self.field_part:__data(),
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
-- @see lualife.models.Stringifiable

return Game