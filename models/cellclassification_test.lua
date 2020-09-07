local luaunit = require("luaunit")
local types = require("lualife.types")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
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

function TestCellClassification.test_new()
  local old = PlacedField:new(Size:new(3, 3))
  old:set(Point:new(1, 0))
  old:set(Point:new(2, 1))

  local new = PlacedField:new(Size:new(3, 3))
  new:set(Point:new(1, 2))
  new:set(Point:new(2, 2))

  local intersection = PlacedField:new(Size:new(3, 3))
  intersection:set(Point:new(0, 2))

  local classification = CellClassification:new(old, new, intersection)

  luaunit.assert_true(types.is_instance(classification, CellClassification))

  luaunit.assert_true(types.is_instance(classification.old, PlacedField))
  luaunit.assert_is(classification.old, old)

  luaunit.assert_true(types.is_instance(classification.new, PlacedField))
  luaunit.assert_is(classification.new, new)

  luaunit.assert_true(types.is_instance(
    classification.intersection,
    PlacedField
  ))
  luaunit.assert_is(classification.intersection, intersection)
end

function TestCellClassification.test_tostring()
  local old = PlacedField:new(Size:new(3, 3))
  old:set(Point:new(1, 0))
  old:set(Point:new(2, 1))

  local new = PlacedField:new(Size:new(3, 3))
  new:set(Point:new(1, 2))
  new:set(Point:new(2, 2))

  local intersection = PlacedField:new(Size:new(3, 3))
  intersection:set(Point:new(0, 2))

  local classification = CellClassification:new(old, new, intersection)
  local text = tostring(classification)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "intersection = {" ..
      "cells = { {x = 0,y = 2} }," ..
      "offset = {x = 0,y = 0}," ..
      "size = {height = 3,width = 3}" ..
    "}," ..
    "new = {" ..
      "cells = { {x = 1,y = 2}, {x = 2,y = 2} }," ..
      "offset = {x = 0,y = 0}," ..
      "size = {height = 3,width = 3}" ..
    "}," ..
    "old = {" ..
      "cells = { {x = 1,y = 0}, {x = 2,y = 1} }," ..
      "offset = {x = 0,y = 0}," ..
      "size = {height = 3,width = 3}" ..
    "}" ..
  "}")
end
