local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local PlacedField = require("lualife.models.placedfield")
local CellClassification = require("biohazardcore.models.cellclassification")

-- luacheck: globals TestCellClassification
TestCellClassification = {}

function TestCellClassification.test_cell_kinds()
  local kinds = CellClassification.cell_kinds()

  local want_kinds = {"old", "new", "intersection"}

  luaunit.assert_is_table(kinds)
  luaunit.assert_equals(kinds, want_kinds)
end

function TestCellClassification.test_is_cell_kind_false()
  local result = CellClassification.is_cell_kind("unknown")

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestCellClassification.test_is_cell_kind_true()
  local result = CellClassification.is_cell_kind("intersection")

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestCellClassification.test_new()
  local old = PlacedField:new(Size:new(3, 3))
  old:set(Vector2D:new(1, 0))
  old:set(Vector2D:new(2, 1))

  local new = PlacedField:new(Size:new(3, 3))
  new:set(Vector2D:new(1, 2))
  new:set(Vector2D:new(2, 2))

  local intersection = PlacedField:new(Size:new(3, 3))
  intersection:set(Vector2D:new(0, 2))

  local classification = CellClassification:new(old, new, intersection)

  luaunit.assert_true(checks.is_instance(classification, CellClassification))

  luaunit.assert_true(checks.is_instance(classification.old, PlacedField))
  luaunit.assert_equals(classification.old, old)

  luaunit.assert_true(checks.is_instance(classification.new, PlacedField))
  luaunit.assert_equals(classification.new, new)

  luaunit.assert_true(checks.is_instance(
    classification.intersection,
    PlacedField
  ))
  luaunit.assert_equals(classification.intersection, intersection)
end

function TestCellClassification.test_new_copies_inputs()
  local old = PlacedField:new(Size:new(3, 3))
  old:set(Vector2D:new(1, 0))

  local new = PlacedField:new(Size:new(3, 3))
  new:set(Vector2D:new(1, 2))

  local intersection = PlacedField:new(Size:new(3, 3))
  intersection:set(Vector2D:new(0, 2))

  local classification = CellClassification:new(old, new, intersection)

  old:set(Vector2D:new(2, 1))
  new.size.height = 4
  intersection:set(Vector2D:new(2, 2))

  local want_classification = CellClassification:new(
    PlacedField:new(Size:new(3, 3)),
    PlacedField:new(Size:new(3, 3)),
    PlacedField:new(Size:new(3, 3))
  )
  want_classification.old:set(Vector2D:new(1, 0))
  want_classification.new:set(Vector2D:new(1, 2))
  want_classification.intersection:set(Vector2D:new(0, 2))

  luaunit.assert_equals(classification, want_classification)
end

function TestCellClassification.test_pairs()
  if _VERSION == "Lua 5.1" then
    local message =
      "Lua 5.1 doesn't support for customizing the `pairs()` function"
    luaunit.skip(message)
  end

  local old = PlacedField:new(Size:new(3, 3))
  old:set(Vector2D:new(1, 0))
  old:set(Vector2D:new(2, 1))

  local new = PlacedField:new(Size:new(3, 3))
  new:set(Vector2D:new(1, 2))
  new:set(Vector2D:new(2, 2))

  local intersection = PlacedField:new(Size:new(3, 3))
  intersection:set(Vector2D:new(0, 2))

  local classification = CellClassification:new(old, new, intersection)

  local collected_pairs = {}
  for cell_kind, cells in pairs(classification) do
    table.insert(collected_pairs, {
      key = cell_kind,
      value = cells,
    })
  end

  luaunit.assert_equals(collected_pairs, {
    {
      key = "old",
      value = old,
    },
    {
      key = "new",
      value = new,
    },
    {
      key = "intersection",
      value = intersection,
    },
  })
end

function TestCellClassification.test_tostring()
  if _VERSION == "Lua 5.1" then
    local message =
      "Lua 5.1 doesn't support for customizing the `pairs()` function"
    luaunit.skip(message)
  end

  local old = PlacedField:new(Size:new(3, 3))
  old:set(Vector2D:new(1, 0))
  old:set(Vector2D:new(2, 1))

  local new = PlacedField:new(Size:new(3, 3))
  new:set(Vector2D:new(1, 2))
  new:set(Vector2D:new(2, 2))

  local intersection = PlacedField:new(Size:new(3, 3))
  intersection:set(Vector2D:new(0, 2))

  local classification = CellClassification:new(old, new, intersection)
  local text = tostring(classification)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"CellClassification\"," ..
    "intersection = {" ..
      "__name = \"PlacedField\"," ..
      "bounds = {" ..
        "__name = \"BoundingBox\"," ..
        "max = {__name = \"Vector2D\",x = 2,y = 2}," ..
        "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
      "}," ..
      "cells = { {__name = \"Vector2D\",x = 0,y = 2} }," ..
      "local_bounds = {" ..
        "__name = \"BoundingBox\"," ..
        "max = {__name = \"Vector2D\",x = 2,y = 2}," ..
        "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
      "}," ..
      "size = {__name = \"Size\",height = 3,width = 3}" ..
    "}," ..
    "new = {" ..
      "__name = \"PlacedField\"," ..
      "bounds = {" ..
        "__name = \"BoundingBox\"," ..
        "max = {__name = \"Vector2D\",x = 2,y = 2}," ..
        "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
      "}," ..
      "cells = { " ..
        "{__name = \"Vector2D\",x = 1,y = 2}, " ..
        "{__name = \"Vector2D\",x = 2,y = 2} " ..
      "}," ..
      "local_bounds = {" ..
        "__name = \"BoundingBox\"," ..
        "max = {__name = \"Vector2D\",x = 2,y = 2}," ..
        "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
      "}," ..
      "size = {__name = \"Size\",height = 3,width = 3}" ..
    "}," ..
    "old = {" ..
      "__name = \"PlacedField\"," ..
      "bounds = {" ..
        "__name = \"BoundingBox\"," ..
        "max = {__name = \"Vector2D\",x = 2,y = 2}," ..
        "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
      "}," ..
      "cells = { " ..
        "{__name = \"Vector2D\",x = 1,y = 0}, " ..
        "{__name = \"Vector2D\",x = 2,y = 1} " ..
      "}," ..
      "local_bounds = {" ..
        "__name = \"BoundingBox\"," ..
        "max = {__name = \"Vector2D\",x = 2,y = 2}," ..
        "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
      "}," ..
      "size = {__name = \"Size\",height = 3,width = 3}" ..
    "}" ..
  "}")
end
