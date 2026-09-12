local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local FieldSettings = require("biohazardcore.models.fieldsettings")

-- luacheck: globals TestFieldSettings
TestFieldSettings = {}

function TestFieldSettings.test_from_json_success()
  local settings, err = json.from_json(
    [[{
      "__name": "FieldSettings",
      "size": { "__name": "Size", "width": 5, "height": 12 },
      "initial_offset": { "__name": "Vector2D", "x": 23, "y": 42 },
      "filling": 0.1,
      "count_range": { "__name": "Range", "min": 2, "max": 3 }
    }]],
    FieldSettings.schema(),
    {
      Size = Size.from_options,
      Vector2D = Vector2D.from_options,
      Range = Range.from_options,
      FieldSettings = FieldSettings.from_options,
    }
  )

  luaunit.assert_is_table(settings)
  luaunit.assert_is_true(checks.is_instance(settings, FieldSettings))

  luaunit.assert_is_table(settings.size)
  luaunit.assert_is_true(checks.is_instance(settings.size, Size))
  luaunit.assert_equals(settings.size, Size:new(5, 12))

  luaunit.assert_is_table(settings.initial_offset)
  luaunit.assert_is_true(checks.is_instance(settings.initial_offset, Vector2D))
  luaunit.assert_equals(settings.initial_offset, Vector2D:new(23, 42))

  luaunit.assert_is_number(settings.filling)
  luaunit.assert_equals(settings.filling, 0.1)

  luaunit.assert_is_table(settings.count_range)
  luaunit.assert_is_true(checks.is_instance(settings.count_range, Range))
  luaunit.assert_equals(settings.count_range, Range:new(2, 3))

  luaunit.assert_is_nil(err)
end

function TestFieldSettings.test_from_json_error()
  local settings, err = json.from_json(
    [[{
      "__name": "FieldSettings",
      "size": { "__name": "Size", "width": 5, "height": 12 },
      "initial_offset": { "__name": "Vector2D", "x": 23, "y": 42 },
      "filling": "invalid",
      "count_range": { "__name": "Range", "min": 2, "max": 3 }
    }]],
    FieldSettings.schema(),
    {
      Size = Size.from_options,
      Vector2D = Vector2D.from_options,
      Range = Range.from_options,
      FieldSettings = FieldSettings.from_options,
    }
  )

  luaunit.assert_is_nil(settings)

  luaunit.assert_is_string(err)
  luaunit.assert_str_matches(
    err,
    "^invalid data: " ..
      [[property "filling" validation failed: ]] ..
      "wrong type: " ..
      "expected number, got string$"
  )
end

function TestFieldSettings.test_new_full()
  local size = Size:new(5, 12)
  local initial_offset = Vector2D:new(23, 42)
  local count_range = Range:new(2, 3)
  local settings = FieldSettings:new(size, initial_offset, 0.1, count_range)

  luaunit.assert_true(checks.is_instance(settings, FieldSettings))

  luaunit.assert_true(checks.is_instance(settings.size, Size))
  luaunit.assert_equals(settings.size, size)

  luaunit.assert_true(checks.is_instance(settings.initial_offset, Vector2D))
  luaunit.assert_equals(settings.initial_offset, initial_offset)

  luaunit.assert_is_number(settings.filling)
  luaunit.assert_equals(settings.filling, 0.1)

  luaunit.assert_true(checks.is_instance(settings.count_range, Range))
  luaunit.assert_equals(settings.count_range, count_range)
end

function TestFieldSettings.test_new_partial()
  local size = Size:new(5, 12)
  local settings = FieldSettings:new(size)

  luaunit.assert_true(checks.is_instance(settings, FieldSettings))

  luaunit.assert_true(checks.is_instance(settings.size, Size))
  luaunit.assert_equals(settings.size, size)

  luaunit.assert_true(checks.is_instance(settings.initial_offset, Vector2D))
  luaunit.assert_equals(settings.initial_offset, Vector2D:new(0, 0))

  luaunit.assert_is_number(settings.filling)
  luaunit.assert_equals(settings.filling, 0.5)

  luaunit.assert_true(checks.is_instance(settings.count_range, Range))
  luaunit.assert_equals(settings.count_range, Range:new(0, math.huge))
end

function TestFieldSettings.test_tostring()
  local settings = FieldSettings:new(
    Size:new(5, 12),
    Vector2D:new(23, 42),
    0.1,
    Range:new(2, 3)
  )
  local text = tostring(settings)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"FieldSettings\"," ..
    "count_range = {__name = \"Range\",max = 3,min = 2}," ..
    "filling = 0.1," ..
    "initial_offset = {__name = \"Vector2D\",x = 23,y = 42}," ..
    "size = {__name = \"Size\",height = 12,width = 5}" ..
  "}")
end
