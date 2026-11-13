local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local BoundingBox = require("luamath.models.boundingbox")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local Game = require("biohazardcore.game")

-- luacheck: globals TestBenchlocalutils
TestBenchlocalutils = {}

function TestBenchlocalutils.test_new_field()
  local field = benchlocalutils.new_field(3, 3, 1)

  luaunit.assert_true(checks.is_instance(field, Field))
  luaunit.assert_equals(field.size, Size:new(3, 3))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))
  luaunit.assert_equals(field:count(), 3)
  luaunit.assert_true(field:contains(Vector2D:new(1, 0)))
  luaunit.assert_true(field:contains(Vector2D:new(2, 1)))
  luaunit.assert_true(field:contains(Vector2D:new(0, 2)))
end

function TestBenchlocalutils.test_new_field_with_defaults()
  local field = benchlocalutils.new_field(5)

  luaunit.assert_true(checks.is_instance(field, Field))
  luaunit.assert_equals(field.size, Size:new(5, 5))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(4, 4)
  ))
  luaunit.assert_equals(field:count(), 5)
  luaunit.assert_true(field:contains(Vector2D:new(0, 0)))
  luaunit.assert_true(field:contains(Vector2D:new(2, 1)))
  luaunit.assert_true(field:contains(Vector2D:new(4, 2)))
  luaunit.assert_true(field:contains(Vector2D:new(1, 3)))
  luaunit.assert_true(field:contains(Vector2D:new(3, 4)))
end

function TestBenchlocalutils.test_new_placed_field()
  local field = benchlocalutils.new_placed_field(3, 3, 1, 10)

  luaunit.assert_true(checks.is_instance(field, PlacedField))
  luaunit.assert_equals(field.size, Size:new(3, 3))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(10, 10),
    Vector2D:new(12, 12)
  ))
  luaunit.assert_equals(field:count(), 3)
  luaunit.assert_true(field:contains(Vector2D:new(11, 10)))
  luaunit.assert_true(field:contains(Vector2D:new(12, 11)))
  luaunit.assert_true(field:contains(Vector2D:new(10, 12)))
end

function TestBenchlocalutils.test_new_placed_field_with_defaults()
  local field = benchlocalutils.new_placed_field(5)

  luaunit.assert_true(checks.is_instance(field, PlacedField))
  luaunit.assert_equals(field.size, Size:new(5, 5))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(5, 5),
    Vector2D:new(9, 9)
  ))
  luaunit.assert_equals(field:count(), 5)
  luaunit.assert_true(field:contains(Vector2D:new(5, 5)))
  luaunit.assert_true(field:contains(Vector2D:new(7, 6)))
  luaunit.assert_true(field:contains(Vector2D:new(9, 7)))
  luaunit.assert_true(field:contains(Vector2D:new(6, 8)))
  luaunit.assert_true(field:contains(Vector2D:new(8, 9)))
end

function TestBenchlocalutils.test_collect_points_all()
  local field = Field:new(Size:new(3, 3))
  local points = benchlocalutils.collect_points(field, "all", 3, 1)

  luaunit.assert_equals(points, {
    Vector2D:new(0, 0),
    Vector2D:new(1, 0),
    Vector2D:new(2, 0),
    Vector2D:new(0, 1),
    Vector2D:new(1, 1),
    Vector2D:new(2, 1),
    Vector2D:new(0, 2),
    Vector2D:new(1, 2),
    Vector2D:new(2, 2),
  })
end

function TestBenchlocalutils.test_collect_points_pattern()
  local field = Field:new(Size:new(3, 3))
  local points = benchlocalutils.collect_points(field, "pattern", 3, 1)

  luaunit.assert_equals(points, {
    Vector2D:new(1, 0),
    Vector2D:new(2, 1),
    Vector2D:new(0, 2),
  })
end

function TestBenchlocalutils.test_collect_points_with_defaults()
  local field = Field:new(Size:new(3, 3))
  local points = benchlocalutils.collect_points(field)

  luaunit.assert_equals(points, {
    Vector2D:new(0, 0),
    Vector2D:new(1, 0),
    Vector2D:new(2, 0),
    Vector2D:new(0, 1),
    Vector2D:new(1, 1),
    Vector2D:new(2, 1),
    Vector2D:new(0, 2),
    Vector2D:new(1, 2),
    Vector2D:new(2, 2),
  })
end

function TestBenchlocalutils.test_new_settings()
  local settings = benchlocalutils.new_settings()

  luaunit.assert_true(checks.is_instance(settings, GameSettings))
  luaunit.assert_equals(settings, GameSettings:new(
    FieldSettings:new(
      Size:new(50, 50),
      Vector2D.ZERO,
      0.2,
      Range:new(450, 550)
    ),
    FieldSettings:new(
      Size:new(3, 3),
      Vector2D.ZERO,
      0.5,
      Range:new(5, 5)
    )
  ))
end

function TestBenchlocalutils.test_new_field_part()
  local field = benchlocalutils.new_field_part(Vector2D:new(10, 20))

  luaunit.assert_true(checks.is_instance(field, PlacedField))
  luaunit.assert_equals(field.size, Size:new(3, 3))
  luaunit.assert_equals(field:offset(), Vector2D:new(10, 20))
  luaunit.assert_equals(field:count(), 5)
  for _, point in ipairs({
    Vector2D:new(11, 20),
    Vector2D:new(12, 20),
    Vector2D:new(10, 21),
    Vector2D:new(11, 21),
    Vector2D:new(10, 22),
  }) do
    luaunit.assert_true(field:contains(point))
  end
end

function TestBenchlocalutils.test_new_game_fixture()
  local game = benchlocalutils.new_game_fixture(Game)

  luaunit.assert_true(checks.is_instance(game, Game))
  luaunit.assert_equals(game.settings, benchlocalutils.new_settings())
  luaunit.assert_equals(game._field.size, Size:new(50, 50))
  luaunit.assert_equals(game._field:count(), 500)
  luaunit.assert_equals(game._field_part.size, Size:new(3, 3))
  luaunit.assert_equals(game._field_part:offset(), Vector2D:new(10, 10))
  luaunit.assert_equals(game._field_part:count(), 5)
end
