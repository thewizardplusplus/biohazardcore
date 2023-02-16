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

  local settings =
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3)
  local field = factory.create_field(settings)

  local wanted_cells
  if _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{x = 1,y = 2}"] = true,
      ["{x = 3,y = 5}"] = true,
      ["{x = 4,y = 6}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{x = 0,y = 8}"] = true,
      ["{x = 1,y = 9}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{x = 0,y = 10}"] = true,
        ["{x = 0,y = 1}"] = true,
        ["{x = 0,y = 3}"] = true,
      }
    else
      wanted_cells = {
        ["{x = 1,y = 8}"] = true,
        ["{x = 2,y = 9}"] = true,
      }
    end
  end

  luaunit.assert_true(types.is_instance(field, PlacedField))

  luaunit.assert_true(types.is_instance(field.size, Size))
  luaunit.assert_is(field.size, settings.size)

  luaunit.assert_true(types.is_instance(field.offset, Point))
  luaunit.assert_is(field.offset, settings.initial_offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end
