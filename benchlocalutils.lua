---
-- @module benchlocalutils

local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local PlacedField = require("lualife.models.placedfield")
local base = require("lualife.benchlocalutils")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")

local _FIELD_SIZE = 50
local _FIELD_PART_SIZE = 3
local _FIELD_DENOMINATOR = 5
local _FIELD_PART_OFFSET = 10

local benchlocalutils = setmetatable({}, {__index = base})

---
-- ⚠️. Create settings matching the application configuration.
-- @treturn GameSettings
function benchlocalutils.new_settings()
  return GameSettings:new(
    FieldSettings:new(
      Size:new(_FIELD_SIZE, _FIELD_SIZE),
      nil,
      0.2,
      Range:new(450, 550)
    ),
    FieldSettings:new(
      Size:new(_FIELD_PART_SIZE, _FIELD_PART_SIZE),
      nil,
      0.5,
      Range:new(5, 5)
    )
  )
end

---
-- ⚠️. Create the deterministic five-cell field part used by benchmarks.
-- @tparam Vector2D offset
-- @treturn PlacedField
function benchlocalutils.new_field_part(offset)
  assertions.is_instance(offset, Vector2D)

  local field = PlacedField:new(
    Size:new(_FIELD_PART_SIZE, _FIELD_PART_SIZE),
    offset
  )
  for _, local_point in ipairs({
    Vector2D:new(1, 0),
    Vector2D:new(2, 0),
    Vector2D:new(0, 1),
    Vector2D:new(1, 1),
    Vector2D:new(0, 2),
  }) do
    field:set(offset + local_point)
  end

  return field
end

---
-- ⚠️. Create a game with deterministic fields matching the application size.
-- @tparam tab GameClass Game or a subclass of Game
-- @treturn Game
function benchlocalutils.new_game_fixture(GameClass)
  assertions.is_table(GameClass)

  local game = GameClass:new(benchlocalutils.new_settings())
  game._field = base.new_placed_field(
    _FIELD_SIZE,
    _FIELD_DENOMINATOR,
    0, -- phase
    0 -- offset
  )
  game._field_part = benchlocalutils.new_field_part(
    Vector2D:new(_FIELD_PART_OFFSET, _FIELD_PART_OFFSET)
  )

  return game
end

return benchlocalutils
