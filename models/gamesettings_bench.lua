local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")

-- luacheck: globals TestGameSettingsBench
TestGameSettingsBench = {}

function TestGameSettingsBench.setupClass()
  benchutils.print_name()
end

function TestGameSettingsBench.test_from_json()
  local game_settings = benchlocalutils.new_game_settings()
  local text = assert(json.to_json(game_settings))

  benchutils.run(string.format(
    "json.from_json(GameSettings) (%dx%d/%dx%d)",
    game_settings.field.size.width,
    game_settings.field.size.height,
    game_settings.field_part.size.width,
    game_settings.field_part.size.height
  ), function()
    return json.from_json(text, GameSettings.schema(), {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      Range = Range.from_options,
      FieldSettings = FieldSettings.from_options,
      GameSettings = GameSettings.from_options,
    })
  end)
end

function TestGameSettingsBench.test_tostring()
  local game_settings = benchlocalutils.new_game_settings()

  benchutils.run(string.format(
    "tostring(GameSettings) (%dx%d/%dx%d)",
    game_settings.field.size.width,
    game_settings.field.size.height,
    game_settings.field_part.size.width,
    game_settings.field_part.size.height
  ), function()
    return tostring(game_settings)
  end)
end
