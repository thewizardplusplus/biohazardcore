local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")

-- luacheck: globals TestFieldSettings
TestFieldSettings = {}

function TestFieldSettings.test_new_full()
  local size = Size:new(5, 12)
  local initial_offset = Point:new(23, 42)
  local settings = FieldSettings:new(size, initial_offset, 0.1, 2, 3)

  luaunit.assert_true(checks.is_instance(settings, FieldSettings))

  luaunit.assert_true(checks.is_instance(settings.size, Size))
  luaunit.assert_is(settings.size, size)

  luaunit.assert_true(checks.is_instance(settings.initial_offset, Point))
  luaunit.assert_is(settings.initial_offset, initial_offset)

  luaunit.assert_is_number(settings.filling)
  luaunit.assert_equals(settings.filling, 0.1)

  luaunit.assert_is_number(settings.minimal_count)
  luaunit.assert_equals(settings.minimal_count, 2)

  luaunit.assert_is_number(settings.maximal_count)
  luaunit.assert_equals(settings.maximal_count, 3)
end

function TestFieldSettings.test_new_partial()
  local size = Size:new(5, 12)
  local settings = FieldSettings:new(size)

  luaunit.assert_true(checks.is_instance(settings, FieldSettings))

  luaunit.assert_true(checks.is_instance(settings.size, Size))
  luaunit.assert_is(settings.size, size)

  luaunit.assert_true(checks.is_instance(settings.initial_offset, Point))
  luaunit.assert_equals(settings.initial_offset, Point:new(0, 0))

  luaunit.assert_is_number(settings.filling)
  luaunit.assert_equals(settings.filling, 0.5)

  luaunit.assert_is_number(settings.minimal_count)
  luaunit.assert_equals(settings.minimal_count, 0)

  luaunit.assert_is_number(settings.maximal_count)
  luaunit.assert_equals(settings.maximal_count, math.huge)
end

function TestFieldSettings.test_tostring()
  local settings =
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3)
  local text = tostring(settings)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "filling = 0.1," ..
    "initial_offset = {x = 23,y = 42}," ..
    "maximal_count = 3," ..
    "minimal_count = 2," ..
    "size = {height = 12,width = 5}" ..
  "}")
end
