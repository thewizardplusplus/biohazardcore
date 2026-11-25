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

function TestGameBench.test_from_json()
  local game = benchlocalutils.new_game_fixture(Game)
  local text = assert(json.to_json(game))

  benchutils.run(string.format(
    "json.from_json(Game) (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field:count(),
    game._field_part:count()
  ), function()
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

  benchutils.run(string.format(
    "tostring(Game) (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field:count(),
    game._field_part:count()
  ), function()
    return tostring(game)
  end)
end

function TestGameBench.test_new()
  local game_settings = benchlocalutils.new_game_settings()

  benchutils.run(string.format(
    "Game:new() (%dx%d/%dx%d, filling: %g%%+%g%%)",
    game_settings.field.size.width,
    game_settings.field.size.height,
    game_settings.field_part.size.width,
    game_settings.field_part.size.height,
    100 * game_settings.field.filling,
    100 * game_settings.field_part.filling
  ), function()
    return Game:new(game_settings)
  end)
end

function TestGameBench.test_count()
  local game = benchlocalutils.new_game_fixture(Game)

  benchutils.run(string.format(
    "Game:count() (%dx%d, %d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game._field:count()
  ), function()
    return game:count()
  end)
end

function TestGameBench.test_offset()
  local game = benchlocalutils.new_game_fixture(Game)

  benchutils.run(string.format(
    "Game:offset() (%dx%d, %d alive)",
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field_part:count()
  ), function()
    return game:offset()
  end)
end

function TestGameBench.test_move_success()
  local game = benchlocalutils.new_game_fixture(Game)
  local field_part = game._field_part

  benchutils.run(string.format(
    "Game:move() success (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field:count(),
    field_part:count()
  ), function()
    game._field_part = field_part
    return game:move(Vector2D:new(1, 0))
  end)
end

function TestGameBench.test_rotate()
  local game = benchlocalutils.new_game_fixture(Game)
  local field_part = game._field_part

  benchutils.run(string.format(
    "Game:rotate() (%dx%d, %d alive)",
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    field_part:count()
  ), function()
    game._field_part = field_part
    game:rotate()

    return game._field_part
  end)
end

function TestGameBench.test_union_success()
  local game = benchlocalutils.new_game_fixture(Game)
  local field = game._field
  local field_part = game._field_part

  benchutils.run(string.format(
    "Game:union() success (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    field:count(),
    field_part:count()
  ), function()
    game._field = field
    game._field_part = field_part
    return game:union()
  end)
end
