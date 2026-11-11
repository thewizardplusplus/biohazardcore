local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
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

function TestCellClassification.test_from_json_success()
  local classification, err = json.from_json(
    [=[{
      "__name": "CellClassification",
      "old": {
        "__name": "PlacedField",
        "size": { "__name": "Size", "width": 3, "height": 3 },
        "bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 23, "y": 42 },
          "max": { "__name": "Vector2D", "x": 25, "y": 44 }
        },
        "local_bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 0, "y": 0 },
          "max": { "__name": "Vector2D", "x": 2, "y": 2 }
        },
        "cells": [{ "__name": "Vector2D", "x": 24, "y": 43 }]
      },
      "new": {
        "__name": "PlacedField",
        "size": { "__name": "Size", "width": 3, "height": 3 },
        "bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 24, "y": 43 },
          "max": { "__name": "Vector2D", "x": 26, "y": 45 }
        },
        "local_bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 0, "y": 0 },
          "max": { "__name": "Vector2D", "x": 2, "y": 2 }
        },
        "cells": [{ "__name": "Vector2D", "x": 26, "y": 45 }]
      },
      "intersection": {
        "__name": "PlacedField",
        "size": { "__name": "Size", "width": 3, "height": 3 },
        "bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 25, "y": 44 },
          "max": { "__name": "Vector2D", "x": 27, "y": 46 }
        },
        "local_bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 0, "y": 0 },
          "max": { "__name": "Vector2D", "x": 2, "y": 2 }
        },
        "cells": [{ "__name": "Vector2D", "x": 25, "y": 44 }]
      }
    }]=],
    CellClassification.schema(),
    {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      BoundingBox = BoundingBox.from_options,
      PlacedField = PlacedField.from_options,
      CellClassification = CellClassification.from_options,
    }
  )

  luaunit.assert_is_table(classification)
  luaunit.assert_is_true(checks.is_instance(classification, CellClassification))

  local want_old = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  want_old:set(Vector2D:new(24, 43))

  luaunit.assert_is_true(checks.is_instance(classification.old, PlacedField))
  luaunit.assert_equals(classification.old, want_old)

  local want_new = PlacedField:new(Size:new(3, 3), Vector2D:new(24, 43))
  want_new:set(Vector2D:new(26, 45))

  luaunit.assert_is_true(checks.is_instance(classification.new, PlacedField))
  luaunit.assert_equals(classification.new, want_new)

  local want_intersection =
    PlacedField:new(Size:new(3, 3), Vector2D:new(25, 44))
  want_intersection:set(Vector2D:new(25, 44))

  luaunit.assert_is_true(checks.is_instance(
    classification.intersection,
    PlacedField
  ))
  luaunit.assert_equals(classification.intersection, want_intersection)

  luaunit.assert_is_nil(err)
end

function TestCellClassification.test_from_json_error()
  local classification, err = json.from_json(
    [=[{
      "__name": "CellClassification",
      "old": {
        "__name": "PlacedField",
        "size": { "__name": "Size", "width": 3, "height": 3 },
        "bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 23, "y": 42 },
          "max": { "__name": "Vector2D", "x": 25, "y": 44 }
        },
        "local_bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 0, "y": 0 },
          "max": { "__name": "Vector2D", "x": 2, "y": 2 }
        },
        "cells": [{ "__name": "Vector2D", "x": 24, "y": 43 }]
      },
      "new": {
        "__name": "PlacedField",
        "size": { "__name": "Size", "width": 3, "height": 3 },
        "bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 24, "y": 43 },
          "max": { "__name": "Vector2D", "x": 26, "y": 45 }
        },
        "local_bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 0, "y": 0 },
          "max": { "__name": "Vector2D", "x": 2, "y": 2 }
        },
        "cells": [{ "__name": "Vector2D", "x": 26, "y": 45 }]
      },
      "intersection": {
        "__name": "PlacedField",
        "size": { "__name": "Size", "width": "invalid", "height": 3 },
        "bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 25, "y": 44 },
          "max": { "__name": "Vector2D", "x": 27, "y": 46 }
        },
        "local_bounds": {
          "__name": "BoundingBox",
          "min": { "__name": "Vector2D", "x": 0, "y": 0 },
          "max": { "__name": "Vector2D", "x": 2, "y": 2 }
        },
        "cells": [{ "__name": "Vector2D", "x": 25, "y": 44 }]
      }
    }]=],
    CellClassification.schema(),
    {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      BoundingBox = BoundingBox.from_options,
      PlacedField = PlacedField.from_options,
      CellClassification = CellClassification.from_options,
    }
  )

  luaunit.assert_is_nil(classification)

  luaunit.assert_is_string(err)
  luaunit.assert_str_matches(
    err,
    "^invalid data: " ..
      [[property "intersection" validation failed: ]] ..
      [[property "size" validation failed: ]] ..
      [[property "width" validation failed: ]] ..
      "wrong type: " ..
      "expected number, got string$"
  )
end

function TestCellClassification.test_from_options_copies_inputs()
  local options = {
    old = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42)),
    new = PlacedField:new(Size:new(3, 3), Vector2D:new(24, 43)),
    intersection = PlacedField:new(Size:new(3, 3), Vector2D:new(25, 44)),
  }
  options.old:set(Vector2D:new(24, 43))
  options.new:set(Vector2D:new(26, 45))
  options.intersection:set(Vector2D:new(25, 44))

  local classification = CellClassification.from_options(options)

  options.old:set(Vector2D:new(24, 44))
  options.old.size.height = 4
  options.old.bounds.min.y = 50

  options.new:set(Vector2D:new(25, 45))
  options.new.size.height = 4
  options.new.bounds.min.y = 50

  options.intersection:set(Vector2D:new(26, 46))
  options.intersection.size.height = 4
  options.intersection.bounds.min.y = 50

  luaunit.assert_is_table(classification)
  luaunit.assert_is_true(checks.is_instance(classification, CellClassification))

  local want_old = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  want_old:set(Vector2D:new(24, 43))

  luaunit.assert_is_true(checks.is_instance(classification.old, PlacedField))
  luaunit.assert_equals(classification.old, want_old)

  local want_new = PlacedField:new(Size:new(3, 3), Vector2D:new(24, 43))
  want_new:set(Vector2D:new(26, 45))

  luaunit.assert_is_true(checks.is_instance(classification.new, PlacedField))
  luaunit.assert_equals(classification.new, want_new)

  local want_intersection =
    PlacedField:new(Size:new(3, 3), Vector2D:new(25, 44))
  want_intersection:set(Vector2D:new(25, 44))

  luaunit.assert_is_true(checks.is_instance(
    classification.intersection,
    PlacedField
  ))
  luaunit.assert_equals(classification.intersection, want_intersection)
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
