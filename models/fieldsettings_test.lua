local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")

-- luacheck: globals TestFieldSettings
TestFieldSettings = {}

function TestFieldSettings.test_from_json_success()
  local settings, err = json.from_json(
    [[{
      "__name": "FieldSettings",
      "size": { "__name": "Size", "width": 5, "height": 12 },
      "initial_offset": { "__name": "Point", "x": 23, "y": 42 },
      "filling": 0.1,
      "minimal_count": 2,
      "maximal_count": 3
    }]],
    FieldSettings.schema(),
    { FieldSettings = FieldSettings.from_options }
  )

  luaunit.assert_is_table(settings)
  luaunit.assert_is_true(checks.is_instance(settings, FieldSettings))

  luaunit.assert_is_table(settings.size)
  luaunit.assert_is_true(checks.is_instance(settings.size, Size))
  luaunit.assert_equals(settings.size, Size:new(5, 12))

  luaunit.assert_is_table(settings.initial_offset)
  luaunit.assert_is_true(checks.is_instance(settings.initial_offset, Point))
  luaunit.assert_equals(settings.initial_offset, Point:new(23, 42))

  luaunit.assert_is_number(settings.filling)
  luaunit.assert_equals(settings.filling, 0.1)

  luaunit.assert_is_number(settings.minimal_count)
  luaunit.assert_equals(settings.minimal_count, 2)

  luaunit.assert_is_number(settings.maximal_count)
  luaunit.assert_equals(settings.maximal_count, 3)

  luaunit.assert_is_nil(err)
end

function TestFieldSettings.test_from_json_error()
  local settings, err = json.from_json(
    [[{
      "__name": "FieldSettings",
      "size": { "__name": "Size", "width": 5, "height": 12 },
      "initial_offset": { "__name": "Point", "x": 23, "y": 42 },
      "filling": "invalid",
      "minimal_count": 2,
      "maximal_count": 3
    }]],
    FieldSettings.schema(),
    { FieldSettings = FieldSettings.from_options }
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
    "__name = \"FieldSettings\"," ..
    "filling = 0.1," ..
    "initial_offset = {__name = \"Point\",x = 23,y = 42}," ..
    "maximal_count = 3," ..
    "minimal_count = 2," ..
    "size = {__name = \"Size\",height = 12,width = 5}" ..
  "}")
end
