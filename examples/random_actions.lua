local types = require("lualife.types")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local Game = require("biohazardcore.game")

local settings = GameSettings:new(
  FieldSettings:new(Size:new(11, 11), Point:new(0, 0), 0.2),
  FieldSettings:new(Size:new(3, 3), Point:new(4, 4), 0.5, 5, 5)
)
local game = Game:new(settings)

math.randomseed(os.time())

local counter = 0
while true do
  local action = math.floor(5 * math.random())
  if action == 0 then
    game:move(Point:new(-1, 0))
  elseif action == 1 then
    game:move(Point:new(1, 0))
  elseif action == 2 then
    game:move(Point:new(0, -1))
  elseif action == 3 then
    game:move(Point:new(0, 1))
  else
    game:rotate()
  end

  local field_part = game._field_part
  game:union()

  if game._field_part ~= field_part then
    break
  end

  counter = counter + 1
end

print(counter)
