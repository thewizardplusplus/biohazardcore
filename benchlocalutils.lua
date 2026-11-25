-- luacheck: no max comment line length

---
-- @module benchlocalutils

local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local PlacedField = require("lualife.models.placedfield")
local basebenchlocalutils = require("lualife.benchlocalutils")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")

local _FIELD_DENOMINATOR = 5
local _FIELD_PART_SIZE = 3
local _FIELD_PART_OFFSET = 10

local benchlocalutils = setmetatable({}, { __index = basebenchlocalutils })

---
-- @table module
-- @tfield int FIELD_SIZE ???
-- @tfield number FIELD_TARGET_FILLING ???
-- @tfield number FIELD_MIN_ALIVE_RATIO ???
-- @tfield number FIELD_MAX_ALIVE_RATIO ???

benchlocalutils.FIELD_SIZE = 50
benchlocalutils.FIELD_TARGET_FILLING = 0.2
benchlocalutils.FIELD_MIN_ALIVE_RATIO = 0.18
benchlocalutils.FIELD_MAX_ALIVE_RATIO = 0.22

---
-- ⚠️. ???
-- @tparam int size positive field width and height
-- @treturn FieldSettings
function benchlocalutils.new_field_settings(size)
  assertions.is_integer(size)

  local field_area = size * size
  return FieldSettings:new(
    Size:new(size, size),
    Vector2D.ZERO, -- initial offset
    benchlocalutils.FIELD_TARGET_FILLING,
    Range:new( -- count range
      math.floor(field_area * benchlocalutils.FIELD_MIN_ALIVE_RATIO),
      math.ceil(field_area * benchlocalutils.FIELD_MAX_ALIVE_RATIO)
    )
  )
end

---
-- ⚠️. Create representative settings used by benchmarks.
-- @treturn GameSettings
function benchlocalutils.new_game_settings()
  return GameSettings:new(
    benchlocalutils.new_field_settings(benchlocalutils.FIELD_SIZE),
    FieldSettings:new(
      Size:new(_FIELD_PART_SIZE, _FIELD_PART_SIZE),
      Vector2D.ZERO, -- initial offset
      0.5, -- filling
      Range:new(5, 5) -- count range
    )
  )
end

---
-- ⚠️. Create the deterministic five-cell field part used by benchmarks.
-- @tparam Vector2D offset
-- @treturn PlacedField
function benchlocalutils.new_field_part(offset)
  assertions.is_instance(offset, Vector2D)

  local field =
    PlacedField:new(Size:new(_FIELD_PART_SIZE, _FIELD_PART_SIZE), offset)
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
-- ⚠️. Create a game with deterministic fields of representative benchmark sizes.
-- @tparam tab GameClass Game or a subclass of Game
-- @treturn Game
function benchlocalutils.new_game_fixture(GameClass)
  assertions.is_table(GameClass)

  local game = GameClass:new(benchlocalutils.new_game_settings())
  game._field = benchlocalutils.new_placed_field(
    benchlocalutils.FIELD_SIZE,
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
