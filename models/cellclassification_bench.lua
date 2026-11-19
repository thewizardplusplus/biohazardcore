local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local PlacedField = require("lualife.models.placedfield")
local CellClassification = require("biohazardcore.models.cellclassification")
local ClassifiedGame = require("biohazardcore.classifiedgame")

-- luacheck: globals TestCellClassificationBench
TestCellClassificationBench = {}

function TestCellClassificationBench.setupClass()
  benchutils.print_name()
end

function TestCellClassificationBench.test_from_json()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)
  local classification = game:classify_cells()
  local text = assert(json.to_json(classification))

  benchutils.run(string.format(
    "json.from_json(CellClassification) (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field:count(),
    game._field_part:count()
  ), function()
    return json.from_json(text, CellClassification.schema(), {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      BoundingBox = BoundingBox.from_options,
      PlacedField = PlacedField.from_options,
      CellClassification = CellClassification.from_options,
    })
  end)
end

function TestCellClassificationBench.test_tostring()
  local game = benchlocalutils.new_game_fixture(ClassifiedGame)
  local classification = game:classify_cells()

  benchutils.run(string.format(
    "tostring(CellClassification) (%dx%d/%dx%d, %d+%d alive)",
    game.settings.field.size.width,
    game.settings.field.size.height,
    game.settings.field_part.size.width,
    game.settings.field_part.size.height,
    game._field:count(),
    game._field_part:count()
  ), function()
    return tostring(classification)
  end)
end
