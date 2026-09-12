local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local BoundingBox = require("luamath.models.boundingbox")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local factory = require("biohazardcore.factory")

-- luacheck: globals TestFactory
TestFactory = {}

function TestFactory.test_neighbors()
  math.randomseed(1)

  local settings = FieldSettings:new(
    Size:new(5, 12),
    Vector2D:new(23, 42),
    0.1,
    Range:new(2, 3)
  )
  local field = factory.create_field(settings)

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 3,y = 5}"] = true,
      ["{__name = \"Vector2D\",x = 4,y = 6}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 8}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 9}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 10}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 3}"] = true,
      }
    else
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 1,y = 8}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 9}"] = true,
      }
    end
  end

  luaunit.assert_true(checks.is_instance(field, PlacedField))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, settings.size)

  luaunit.assert_true(checks.is_instance(field.local_bounds, BoundingBox))
  luaunit.assert_equals(field.local_bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(4, 11)
  ))

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(23, 42),
    Vector2D:new(27, 53)
  ))

  luaunit.assert_true(checks.is_instance(field:offset(), Vector2D))
  luaunit.assert_equals(field:offset(), settings.initial_offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestFactory.test_create_field_copies_inputs()
  local settings = FieldSettings:new(
    Size:new(5, 12),
    Vector2D:new(23, 42),
    0.1,
    Range:new(2, 3)
  )
  local field = factory.create_field(settings)
  local want_field = PlacedField.place(field, field:offset())

  settings.size.height = 20
  settings.initial_offset.y = 50
  settings.count_range.max = 4

  luaunit.assert_equals(field, want_field)
end
