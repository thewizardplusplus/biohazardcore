local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")

-- luacheck: globals TestGameSettings
TestGameSettings = {}

function TestGameSettings.test_new()
  local field_settings =
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3)
  local field_part_settings =
    FieldSettings:new(Size:new(6, 13), Point:new(24, 43), 0.2, 10, 100)
  local settings = GameSettings:new(field_settings, field_part_settings)

  luaunit.assert_true(checks.is_instance(settings, GameSettings))

  luaunit.assert_true(checks.is_instance(settings.field, FieldSettings))
  luaunit.assert_is(settings.field, field_settings)

  luaunit.assert_true(checks.is_instance(settings.field_part, FieldSettings))
  luaunit.assert_is(settings.field_part, field_part_settings)
end

function TestGameSettings.test_tostring()
  local settings = GameSettings:new(
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3),
    FieldSettings:new(Size:new(6, 13), Point:new(24, 43), 0.2, 10, 100)
  )
  local text = tostring(settings)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "field = {" ..
      "filling = 0.1," ..
      "initial_offset = {x = 23,y = 42}," ..
      "maximal_count = 3," ..
      "minimal_count = 2," ..
      "size = {height = 12,width = 5}" ..
    "}," ..
    "field_part = {" ..
      "filling = 0.2," ..
      "initial_offset = {x = 24,y = 43}," ..
      "maximal_count = 100," ..
      "minimal_count = 10," ..
      "size = {height = 13,width = 6}" ..
    "}" ..
  "}")
end
