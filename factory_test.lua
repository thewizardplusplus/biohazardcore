local luaunit = require("luaunit")
local types = require("lualife.types")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local factory = require("biohazardcore.factory")

-- luacheck: globals TestFactory
TestFactory = {}

function TestFactory.test_neighbors()
  math.randomseed(1)

  local settings = FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3)
  local field = factory.create_field(settings)

  luaunit.assert_true(types.is_instance(field, PlacedField))

  luaunit.assert_true(types.is_instance(field.size, Size))
  luaunit.assert_is(field.size, settings.size)

  luaunit.assert_true(types.is_instance(field.offset, Point))
  luaunit.assert_is(field.offset, settings.initial_offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{x = 0,y = 8}"] = true,
    ["{x = 1,y = 9}"] = true,
  })
end
