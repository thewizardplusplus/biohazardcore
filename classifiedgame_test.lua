local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local CellClassification = require("biohazardcore.models.cellclassification")
local ClassifiedGame = require("biohazardcore.classifiedgame")

-- luacheck: globals TestClassifiedGame
TestClassifiedGame = {}

function TestClassifiedGame.test_new()
  math.randomseed(1)

  local settings = GameSettings:new(
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3),
    FieldSettings:new(Size:new(6, 13), Point:new(24, 43), 0.2, 10, 100)
  )
  local game = ClassifiedGame:new(settings)

  local want_field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  if _VERSION == "Lua 5.4" then
    want_field:set(Point:new(24, 44))
    want_field:set(Point:new(26, 47))
    want_field:set(Point:new(27, 48))
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    want_field:set(Point:new(23, 50))
    want_field:set(Point:new(24, 51))
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      want_field:set(Point:new(23, 43))
      want_field:set(Point:new(23, 45))
      want_field:set(Point:new(23, 52))
    else
      want_field:set(Point:new(24, 50))
      want_field:set(Point:new(25, 51))
    end
  end

  local want_field_part = PlacedField:new(Size:new(6, 13), Point:new(24, 43))
  if _VERSION == "Lua 5.4" then
    want_field_part:set(Point:new(29, 45))
    want_field_part:set(Point:new(28, 46))
    want_field_part:set(Point:new(28, 47))
    want_field_part:set(Point:new(29, 48))
    want_field_part:set(Point:new(28, 50))
    want_field_part:set(Point:new(28, 51))
    want_field_part:set(Point:new(24, 52))
    want_field_part:set(Point:new(25, 52))
    want_field_part:set(Point:new(28, 53))
    want_field_part:set(Point:new(28, 55))
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    want_field_part:set(Point:new(28, 44))
    want_field_part:set(Point:new(24, 45))
    want_field_part:set(Point:new(28, 45))
    want_field_part:set(Point:new(25, 46))
    want_field_part:set(Point:new(26, 47))
    want_field_part:set(Point:new(27, 47))
    want_field_part:set(Point:new(26, 48))
    want_field_part:set(Point:new(27, 48))
    want_field_part:set(Point:new(28, 48))
    want_field_part:set(Point:new(27, 49))
    want_field_part:set(Point:new(24, 51))
    want_field_part:set(Point:new(25, 52))
    want_field_part:set(Point:new(26, 52))
    want_field_part:set(Point:new(28, 52))
    want_field_part:set(Point:new(26, 54))
    want_field_part:set(Point:new(27, 55))
    want_field_part:set(Point:new(29, 55))
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      want_field_part:set(Point:new(24, 43))
      want_field_part:set(Point:new(28, 43))
      want_field_part:set(Point:new(29, 43))
      want_field_part:set(Point:new(24, 44))
      want_field_part:set(Point:new(26, 44))
      want_field_part:set(Point:new(29, 44))
      want_field_part:set(Point:new(28, 46))
      want_field_part:set(Point:new(24, 47))
      want_field_part:set(Point:new(25, 47))
      want_field_part:set(Point:new(28, 47))
      want_field_part:set(Point:new(29, 49))
      want_field_part:set(Point:new(26, 50))
      want_field_part:set(Point:new(28, 50))
      want_field_part:set(Point:new(29, 50))
      want_field_part:set(Point:new(29, 52))
      want_field_part:set(Point:new(27, 53))
    else
      want_field_part:set(Point:new(29, 44))
      want_field_part:set(Point:new(25, 45))
      want_field_part:set(Point:new(29, 45))
      want_field_part:set(Point:new(26, 46))
      want_field_part:set(Point:new(27, 47))
      want_field_part:set(Point:new(28, 47))
      want_field_part:set(Point:new(27, 48))
      want_field_part:set(Point:new(28, 48))
      want_field_part:set(Point:new(29, 48))
      want_field_part:set(Point:new(28, 49))
      want_field_part:set(Point:new(25, 51))
      want_field_part:set(Point:new(26, 52))
      want_field_part:set(Point:new(27, 52))
      want_field_part:set(Point:new(29, 52))
      want_field_part:set(Point:new(27, 54))
      want_field_part:set(Point:new(28, 55))
    end
  end

  luaunit.assert_true(checks.is_instance(game, ClassifiedGame))

  luaunit.assert_true(checks.is_instance(game.settings, GameSettings))
  luaunit.assert_is(game.settings, settings)

  luaunit.assert_true(checks.is_instance(game._field, PlacedField))
  luaunit.assert_equals(game._field, want_field)

  luaunit.assert_true(checks.is_instance(game._field_part, PlacedField))
  luaunit.assert_equals(game._field_part, want_field_part)
end

function TestClassifiedGame.test_classify_cells()
  local game = ClassifiedGame:new(GameSettings:new(
    FieldSettings:new(Size:new(3, 3)),
    FieldSettings:new(Size:new(3, 3))
  ))

  game._field = PlacedField:new(Size:new(3, 3))
  game._field:set(Point:new(1, 0))
  game._field:set(Point:new(2, 1))
  game._field:set(Point:new(0, 2))

  game._field_part = PlacedField:new(Size:new(3, 3))
  game._field_part:set(Point:new(0, 2))
  game._field_part:set(Point:new(1, 2))
  game._field_part:set(Point:new(2, 2))

  local classification = game:classify_cells()

  local want_old = PlacedField:new(Size:new(3, 3))
  want_old:set(Point:new(1, 0))
  want_old:set(Point:new(2, 1))

  local want_new = PlacedField:new(Size:new(3, 3))
  want_new:set(Point:new(1, 2))
  want_new:set(Point:new(2, 2))

  local want_intersection = PlacedField:new(Size:new(3, 3))
  want_intersection:set(Point:new(0, 2))

  local want_classification =
    CellClassification:new(want_old, want_new, want_intersection)

  luaunit.assert_true(checks.is_instance(classification, CellClassification))
  luaunit.assert_equals(classification, want_classification)
end
