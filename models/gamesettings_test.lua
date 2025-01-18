local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")

-- luacheck: globals TestGameSettings
TestGameSettings = {}

function TestGameSettings.test_from_json_success()
  local settings, err = json.from_json(
    [[{
      "__name": "GameSettings",
      "field": {
        "__name": "FieldSettings",
        "size": { "__name": "Size", "width": 5, "height": 12 },
        "initial_offset": { "__name": "Point", "x": 23, "y": 42 },
        "filling": 0.1,
        "minimal_count": 2,
        "maximal_count": 3
      },
      "field_part": {
        "__name": "FieldSettings",
        "size": { "__name": "Size", "width": 6, "height": 13 },
        "initial_offset": { "__name": "Point", "x": 24, "y": 43 },
        "filling": 0.2,
        "minimal_count": 4,
        "maximal_count": 5
      }
    }]],
    GameSettings.schema(),
    {
      FieldSettings = FieldSettings.from_options,
      GameSettings = GameSettings.from_options,
    }
  )

  luaunit.assert_is_table(settings)
  luaunit.assert_is_true(checks.is_instance(settings, GameSettings))

  local want_field =
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3)
  luaunit.assert_is_table(settings.field)
  luaunit.assert_is_true(checks.is_instance(settings.field, FieldSettings))
  luaunit.assert_equals(settings.field, want_field)

  local want_field_part =
    FieldSettings:new(Size:new(6, 13), Point:new(24, 43), 0.2, 4, 5)
  luaunit.assert_is_table(settings.field_part)
  luaunit.assert_is_true(checks.is_instance(settings.field_part, FieldSettings))
  luaunit.assert_equals(settings.field_part, want_field_part)

  luaunit.assert_is_nil(err)
end

function TestGameSettings.test_from_json_error()
  local settings, err = json.from_json(
    [[{
      "__name": "GameSettings",
      "field": {
        "__name": "FieldSettings",
        "size": { "__name": "Size", "width": 5, "height": 12 },
        "initial_offset": { "__name": "Point", "x": 23, "y": 42 },
        "filling": 0.1,
        "minimal_count": 2,
        "maximal_count": 3
      },
      "field_part": {
        "__name": "FieldSettings",
        "size": { "__name": "Size", "width": 6, "height": 13 },
        "initial_offset": { "__name": "Point", "x": 24, "y": 43 },
        "filling": "invalid",
        "minimal_count": 4,
        "maximal_count": 5
      }
    }]],
    GameSettings.schema(),
    {
      FieldSettings = FieldSettings.from_options,
      GameSettings = GameSettings.from_options,
    }
  )

  luaunit.assert_is_nil(settings)

  luaunit.assert_is_string(err)
  luaunit.assert_str_matches(
    err,
    "^invalid data: " ..
      [[property "field_part" validation failed: ]] ..
      [[property "filling" validation failed: ]] ..
      "wrong type: " ..
      "expected number, got string$"
  )
end

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
    "__name = \"GameSettings\"," ..
    "field = {" ..
      "__name = \"FieldSettings\"," ..
      "filling = 0.1," ..
      "initial_offset = {__name = \"Point\",x = 23,y = 42}," ..
      "maximal_count = 3," ..
      "minimal_count = 2," ..
      "size = {__name = \"Size\",height = 12,width = 5}" ..
    "}," ..
    "field_part = {" ..
      "__name = \"FieldSettings\"," ..
      "filling = 0.2," ..
      "initial_offset = {__name = \"Point\",x = 24,y = 43}," ..
      "maximal_count = 100," ..
      "minimal_count = 10," ..
      "size = {__name = \"Size\",height = 13,width = 6}" ..
    "}" ..
  "}")
end
