local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local Game = require("biohazardcore.game")

math.randomseed(os.time())

local game = Game:new(GameSettings:new(
  FieldSettings:new(Size:new(11, 11), Vector2D:new(0, 0), 0.4),
  FieldSettings:new(Size:new(3, 3), Vector2D:new(4, 4), 0.5, Range:new(5, 5))
))
local counter = 0
repeat
  local action = math.floor(5 * math.random())
  local action_description
  if action == 0 then
    action_description = "move left"
    game:move(Vector2D:new(-1, 0))
  elseif action == 1 then
    action_description = "move right"
    game:move(Vector2D:new(1, 0))
  elseif action == 2 then
    action_description = "move top"
    game:move(Vector2D:new(0, -1))
  elseif action == 3 then
    action_description = "move bottom"
    game:move(Vector2D:new(0, 1))
  else
    action_description = "rotate"
    game:rotate()
  end
  print(string.format("step #%d: " .. action_description, counter + 1))

  local unioned = game:union()
  counter = counter + 1
until unioned
