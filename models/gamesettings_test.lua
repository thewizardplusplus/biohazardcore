local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
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
        "initial_offset": { "__name": "Vector2D", "x": 23, "y": 42 },
        "filling": 0.1,
        "count_range": { "__name": "Range", "min": 2, "max": 3 }
      },
      "field_part": {
        "__name": "FieldSettings",
        "size": { "__name": "Size", "width": 6, "height": 13 },
        "initial_offset": { "__name": "Vector2D", "x": 24, "y": 43 },
        "filling": 0.2,
        "count_range": { "__name": "Range", "min": 4, "max": 5 }
      }
    }]],
    GameSettings.schema(),
    {
      Size = Size.from_options,
      Vector2D = Vector2D.from_options,
      Range = Range.from_options,
      FieldSettings = FieldSettings.from_options,
      GameSettings = GameSettings.from_options,
    }
  )

  luaunit.assert_is_table(settings)
  luaunit.assert_is_true(checks.is_instance(settings, GameSettings))

  local want_field = FieldSettings:new(
    Size:new(5, 12),
    Vector2D:new(23, 42),
    0.1,
    Range:new(2, 3)
  )
  luaunit.assert_is_table(settings.field)
  luaunit.assert_is_true(checks.is_instance(settings.field, FieldSettings))
  luaunit.assert_equals(settings.field, want_field)

  local want_field_part = FieldSettings:new(
    Size:new(6, 13),
    Vector2D:new(24, 43),
    0.2,
    Range:new(4, 5)
  )
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
        "initial_offset": { "__name": "Vector2D", "x": 23, "y": 42 },
        "filling": 0.1,
        "count_range": { "__name": "Range", "min": 2, "max": 3 }
      },
      "field_part": {
        "__name": "FieldSettings",
        "size": { "__name": "Size", "width": 6, "height": 13 },
        "initial_offset": { "__name": "Vector2D", "x": 24, "y": 43 },
        "filling": "invalid",
        "count_range": { "__name": "Range", "min": 4, "max": 5 }
      }
    }]],
    GameSettings.schema(),
    {
      Size = Size.from_options,
      Vector2D = Vector2D.from_options,
      Range = Range.from_options,
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
  local field_settings = FieldSettings:new(
    Size:new(5, 12),
    Vector2D:new(23, 42),
    0.1,
    Range:new(2, 3)
  )
  local field_part_settings = FieldSettings:new(
    Size:new(6, 13),
    Vector2D:new(24, 43),
    0.2,
    Range:new(10, 100)
  )
  local settings = GameSettings:new(field_settings, field_part_settings)

  luaunit.assert_true(checks.is_instance(settings, GameSettings))

  luaunit.assert_true(checks.is_instance(settings.field, FieldSettings))
  luaunit.assert_is(settings.field, field_settings)

  luaunit.assert_true(checks.is_instance(settings.field_part, FieldSettings))
  luaunit.assert_is(settings.field_part, field_part_settings)
end

function TestGameSettings.test_tostring()
  local settings = GameSettings:new(
    FieldSettings:new(
      Size:new(5, 12),
      Vector2D:new(23, 42),
      0.1,
      Range:new(2, 3)
    ),
    FieldSettings:new(
      Size:new(6, 13),
      Vector2D:new(24, 43),
      0.2,
      Range:new(10, 100)
    )
  )
  local text = tostring(settings)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"GameSettings\"," ..
    "field = {" ..
      "__name = \"FieldSettings\"," ..
      "count_range = {__name = \"Range\",max = 3,min = 2}," ..
      "filling = 0.1," ..
      "initial_offset = {__name = \"Vector2D\",x = 23,y = 42}," ..
      "size = {__name = \"Size\",height = 12,width = 5}" ..
    "}," ..
    "field_part = {" ..
      "__name = \"FieldSettings\"," ..
      "count_range = {__name = \"Range\",max = 100,min = 10}," ..
      "filling = 0.2," ..
      "initial_offset = {__name = \"Vector2D\",x = 24,y = 43}," ..
      "size = {__name = \"Size\",height = 13,width = 6}" ..
    "}" ..
  "}")
end
