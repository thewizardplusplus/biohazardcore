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
  local settings = benchlocalutils.new_settings().field
  local text = assert(json.to_json(settings))

  benchutils.run("json.from_json(FieldSettings) (50x50)", function()
    return json.from_json(text, FieldSettings.schema(), {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      Range = Range.from_options,
      FieldSettings = FieldSettings.from_options,
    })
  end)
end

function TestFieldSettingsBench.test_tostring()
  local settings = benchlocalutils.new_settings().field

  benchutils.run("tostring(FieldSettings) (50x50)", function()
    return tostring(settings)
  end)
end
