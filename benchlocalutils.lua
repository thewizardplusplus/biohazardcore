-- luacheck: no max comment line length

---
-- @module benchlocalutils

local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local PlacedField = require("lualife.models.placedfield")
local sets = require("lualife.sets")
local basebenchlocalutils = require("lualife.benchlocalutils")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")

local _FIELD_DENOMINATOR = 5
local _FIELD_PART_SIZE = 3
local _FIELD_PART_TARGET_FILLING = 0.5
local _FIELD_PART_MIN_ALIVE_RATIO = 0.5
local _FIELD_PART_MAX_ALIVE_RATIO = 0.5

local benchlocalutils = setmetatable({}, { __index = basebenchlocalutils })

---
-- @table module
-- @tfield int FIELD_SIZE square primary field size used by benchmarks
-- @tfield number FIELD_TARGET_FILLING primary field target filling [0, 1]
-- @tfield number FIELD_MIN_ALIVE_RATIO primary field minimum alive ratio [0, 1]
-- @tfield number FIELD_MAX_ALIVE_RATIO primary field maximum alive ratio [0, 1]

benchlocalutils.FIELD_SIZE = 50
benchlocalutils.FIELD_TARGET_FILLING = 0.2
benchlocalutils.FIELD_MIN_ALIVE_RATIO = 0.18
benchlocalutils.FIELD_MAX_ALIVE_RATIO = 0.22

---
-- ⚠️. Create square field settings from relative alive-cell limits.
-- @tparam int size positive field width and height
-- @tparam number target_filling target filling [0, 1]
-- @tparam number min_alive_ratio minimum alive ratio [0, 1]
-- @tparam number max_alive_ratio maximum alive ratio [0, 1]
-- @tparam[opt=Vector2D.ZERO] Vector2D initial_offset
-- @treturn FieldSettings
function benchlocalutils.new_field_settings(
  size,
  target_filling,
  min_alive_ratio,
  max_alive_ratio,
  initial_offset
)
  initial_offset = initial_offset or Vector2D.ZERO

  assertions.is_integer(size)
  assertions.is_number(target_filling)
  assertions.is_number(min_alive_ratio)
  assertions.is_number(max_alive_ratio)
  assertions.is_instance(initial_offset, Vector2D)
  assertions.is_true(size > 0)
  assertions.is_true(0 <= target_filling and target_filling <= 1)
  assertions.is_true(0 <= min_alive_ratio)
  assertions.is_true(min_alive_ratio <= target_filling)
  assertions.is_true(target_filling <= max_alive_ratio)
  assertions.is_true(max_alive_ratio <= 1)

  local field_area = size * size
  return FieldSettings:new(
    Size:new(size, size),
    initial_offset,
    target_filling,
    Range:new( -- count range
      math.floor(field_area * min_alive_ratio),
      math.ceil(field_area * max_alive_ratio)
    )
  )
end

---
-- ⚠️. Create representative settings used by benchmarks.
-- @treturn GameSettings
function benchlocalutils.new_game_settings()
  assertions.is_true(_FIELD_PART_SIZE < benchlocalutils.FIELD_SIZE)

  local field_part_offset =
    math.floor((benchlocalutils.FIELD_SIZE - _FIELD_PART_SIZE) / 2)
  return GameSettings:new(
    benchlocalutils.new_field_settings(
      benchlocalutils.FIELD_SIZE,
      benchlocalutils.FIELD_TARGET_FILLING,
      benchlocalutils.FIELD_MIN_ALIVE_RATIO,
      benchlocalutils.FIELD_MAX_ALIVE_RATIO
    ),
    benchlocalutils.new_field_settings(
      _FIELD_PART_SIZE,
      _FIELD_PART_TARGET_FILLING,
      _FIELD_PART_MIN_ALIVE_RATIO,
      _FIELD_PART_MAX_ALIVE_RATIO,
      Vector2D:new(field_part_offset, field_part_offset)
    )
  )
end

---
-- ⚠️. Create a deterministic field part satisfying its settings and not intersecting the primary field.
-- @tparam PlacedField field primary field
-- @tparam FieldSettings settings field part settings
-- @treturn PlacedField
function benchlocalutils.new_field_part(field, settings)
  assertions.is_instance(field, PlacedField)
  assertions.is_instance(settings, FieldSettings)
  assertions.is_true(settings.size.width == settings.size.height)

  local sample = benchlocalutils.new_placed_field(
    settings.size.width,
    1, -- denominator; fill every cell
    0, -- phase
    0 -- offset
  )
  sample = PlacedField.place(sample, settings.initial_offset)
  assertions.is_true(sample:fits(field))

  local available = sets.complement(sample, field)
  local field_area = settings.size.width * settings.size.height
  local target_count = math.floor(field_area * settings.filling + 0.5)
  target_count = math.max(settings.count_range.min, target_count)
  target_count = math.min(
    settings.count_range.max,
    available:count(),
    target_count
  )
  assertions.is_true(settings.count_range:contains(target_count))

  local count = 0
  return available:map(function(_, contains)
    if contains and count < target_count then
      count = count + 1
      return true
    end

    return false
  end)
end

---
-- ⚠️. Create a game with deterministic fields of representative benchmark sizes.
-- @tparam tab GameClass Game or a subclass of Game
-- @treturn Game
function benchlocalutils.new_game_fixture(GameClass)
  assertions.is_table(GameClass)

  local game_settings = benchlocalutils.new_game_settings()
  local game = GameClass:new(game_settings)
  game._field = benchlocalutils.new_placed_field(
    benchlocalutils.FIELD_SIZE,
    _FIELD_DENOMINATOR,
    0, -- phase
    0 -- offset
  )
  game._field_part =
    benchlocalutils.new_field_part(game._field, game_settings.field_part)

  return game
end

return benchlocalutils
