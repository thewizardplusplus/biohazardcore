local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local PlacedField = require("lualife.models.placedfield")
local CellClassification = require("biohazardcore.models.cellclassification")
local ClassifiedGame = require("biohazardcore.classifiedgame")

local _classification

-- luacheck: globals TestCellClassificationBench
TestCellClassificationBench = {}

function TestCellClassificationBench.setupClass()
  benchutils.print_name()

  local game = benchlocalutils.new_game_fixture(ClassifiedGame)
  _classification = game:classify_cells()
end

function TestCellClassificationBench.test_from_json()
  local text = assert(json.to_json(_classification))

  benchutils.run(
    "json.from_json(CellClassification) (50x50/3x3, 500+5 alive)",
    function()
      return json.from_json(text, CellClassification.schema(), {
        Vector2D = Vector2D.from_options,
        Size = Size.from_options,
        BoundingBox = BoundingBox.from_options,
        PlacedField = PlacedField.from_options,
        CellClassification = CellClassification.from_options,
      })
    end
  )
end

function TestCellClassificationBench.test_tostring()
  benchutils.run(
    "tostring(CellClassification) (50x50/3x3, 500+5 alive)",
    function()
      return tostring(_classification)
    end
  )
end
