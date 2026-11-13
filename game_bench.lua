local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local BoundingBox = require("luamath.models.boundingbox")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local Game = require("biohazardcore.game")

-- luacheck: globals TestGameBench
TestGameBench = {}

function TestGameBench.setupClass()
  benchutils.print_name()
end

function TestGameBench.test_new()
  local settings = benchlocalutils.new_settings()

  benchutils.run("Game:new() (50x50/3x3, 20%/5 alive)", function()
    return Game:new(settings)
  end)
end

function TestGameBench.test_from_json()
  local game = benchlocalutils.new_game_fixture(Game)
  local text = assert(json.to_json(game))

  benchutils.run("json.from_json(Game) (50x50/3x3, 500+5 alive)", function()
    return json.from_json(text, Game.schema(), {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      Range = Range.from_options,
      BoundingBox = BoundingBox.from_options,
      PlacedField = PlacedField.from_options,
      FieldSettings = FieldSettings.from_options,
      GameSettings = GameSettings.from_options,
      Game = Game.from_options,
    })
  end)
end

function TestGameBench.test_tostring()
  local game = benchlocalutils.new_game_fixture(Game)

  benchutils.run("tostring(Game) (50x50/3x3, 500+5 alive)", function()
    return tostring(game)
  end)
end

function TestGameBench.test_count()
  local game = benchlocalutils.new_game_fixture(Game)

  benchutils.run("Game:count() (50x50, 500 alive)", function()
    return game:count()
  end)
end

function TestGameBench.test_offset()
  local game = benchlocalutils.new_game_fixture(Game)

  benchutils.run("Game:offset() (3x3, 5 alive)", function()
    return game:offset()
  end)
end

function TestGameBench.test_move_success()
  local game = benchlocalutils.new_game_fixture(Game)
  local field_part = game._field_part
  local delta_offset = Vector2D:new(1, 0)

  benchutils.run("Game:move() success (50x50/3x3)", function()
    game._field_part = field_part
    return game:move(delta_offset)
  end)
end

function TestGameBench.test_rotate()
  local game = benchlocalutils.new_game_fixture(Game)
  local field_part = game._field_part

  benchutils.run("Game:rotate() (50x50/3x3, 5 alive)", function()
    game._field_part = field_part
    game:rotate()

    return game._field_part
  end)
end

function TestGameBench.test_union_success()
  local game = benchlocalutils.new_game_fixture(Game)
  local field = game._field
  local field_part = benchlocalutils.new_field_part(Vector2D.ZERO)

  benchutils.run("Game:union() success (50x50/3x3, 500+5 alive)", function()
    game._field = field
    game._field_part = field_part
    return game:union()
  end)
end
