local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local FieldSettings = require("biohazardcore.models.fieldsettings")

-- luacheck: globals TestFieldSettingsBench
TestFieldSettingsBench = {}

function TestFieldSettingsBench.setupClass()
  benchutils.print_name()
end

function TestFieldSettingsBench.test_from_json()
  local field_settings =
    benchlocalutils.new_field_settings(benchlocalutils.FIELD_SIZE)
  local text = assert(json.to_json(field_settings))

  benchutils.run(string.format(
    "json.from_json(FieldSettings) (%dx%d)",
    field_settings.size.width,
    field_settings.size.height
  ), function()
    return json.from_json(text, FieldSettings.schema(), {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      Range = Range.from_options,
      FieldSettings = FieldSettings.from_options,
    })
  end)
end

function TestFieldSettingsBench.test_tostring()
  local field_settings =
    benchlocalutils.new_field_settings(benchlocalutils.FIELD_SIZE)

  benchutils.run(string.format(
    "tostring(FieldSettings) (%dx%d)",
    field_settings.size.width,
    field_settings.size.height
  ), function()
    return tostring(field_settings.field)
  end)
end
