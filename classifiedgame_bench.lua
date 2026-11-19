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
local ClassifiedGame = require("biohazardcore.classifiedgame")

-- luacheck: globals TestClassifiedGameBench
TestClassifiedGameBench = {}

function TestClassifiedGameBench.setupClass()
  benchutils.print_name()
end

function TestClassifiedGameBench.test_from_json()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)
  local text = assert(json.to_json(game))

  benchutils.run(string.format(
    "json.from_json(ClassifiedGame) (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field:count(),
    game._field_part:count()
  ), function()
    return json.from_json(text, ClassifiedGame.schema(), {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      Range = Range.from_options,
      BoundingBox = BoundingBox.from_options,
      PlacedField = PlacedField.from_options,
      FieldSettings = FieldSettings.from_options,
      GameSettings = GameSettings.from_options,
      ClassifiedGame = ClassifiedGame.from_options,
    })
  end)
end

function TestClassifiedGameBench.test_tostring()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)

  benchutils.run(string.format(
    "tostring(ClassifiedGame) (%dx%d/%dx%d, %d+%d alive)",
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

function TestClassifiedGameBench.test_new()
  local settings = benchlocalutils.new_settings()

  benchutils.run(string.format(
    "ClassifiedGame:new() (%dx%d/%dx%d, filling: %g%%+%g%%)",
    settings.field.size.width,
    settings.field.size.height,
    settings.field_part.size.width,
    settings.field_part.size.height,
    100 * settings.field.filling,
    100 * settings.field_part.filling
  ), function()
    return ClassifiedGame:new(settings)
  end)
end

function TestClassifiedGameBench.test_classify_cells()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)

  benchutils.run(string.format(
    "ClassifiedGame:classify_cells() (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field:count(),
    game._field_part:count()
  ), function()
    return game:classify_cells()
  end)
end

function TestClassifiedGameBench.test_count()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)

  benchutils.run(string.format(
    "ClassifiedGame:count() (%dx%d, %d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game._field:count()
  ), function()
    return game:count()
  end)
end

function TestClassifiedGameBench.test_offset()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)

  benchutils.run(string.format(
    "ClassifiedGame:offset() (%dx%d, %d alive)",
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field_part:count()
  ), function()
    return game:offset()
  end)
end

function TestClassifiedGameBench.test_move_success()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)
  local field_part = game._field_part

  benchutils.run(string.format(
    "ClassifiedGame:move() success (%dx%d/%dx%d, %d+%d alive)",
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

function TestClassifiedGameBench.test_rotate()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)
  local field_part = game._field_part

  benchutils.run(string.format(
    "ClassifiedGame:rotate() (%dx%d, %d alive)",
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    field_part:count()
  ), function()
    game._field_part = field_part
    game:rotate()

    return game._field_part
  end)
end

function TestClassifiedGameBench.test_union_success()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)
  local field = game._field
  local field_part = game._field_part

  benchutils.run(string.format(
    "ClassifiedGame:union() success (%dx%d/%dx%d, %d+%d alive)",
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
