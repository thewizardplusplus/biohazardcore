local luaunit = require("luaunit")
local types = require("lualife.types")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local Game = require("biohazardcore.game")

-- luacheck: globals TestGame
TestGame = {}

function TestGame.test_new()
  math.randomseed(1)

  local settings = GameSettings:new(
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3),
    FieldSettings:new(Size:new(6, 13), Point:new(24, 43), 0.2, 10, 100)
  )
  local game = Game:new(settings)

  local want_field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  want_field:set(Point:new(23, 50))
  want_field:set(Point:new(24, 51))

  local want_field_part = PlacedField:new(Size:new(6, 13), Point:new(24, 43))
  want_field_part:set(Point:new(28, 44))
  want_field_part:set(Point:new(24, 45))
  want_field_part:set(Point:new(28, 45))
  want_field_part:set(Point:new(25, 46))
  want_field_part:set(Point:new(26, 47))
  want_field_part:set(Point:new(27, 47))
  want_field_part:set(Point:new(26, 48))
  want_field_part:set(Point:new(27, 48))
  want_field_part:set(Point:new(28, 48))
  want_field_part:set(Point:new(27, 49))
  want_field_part:set(Point:new(24, 51))
  want_field_part:set(Point:new(25, 52))
  want_field_part:set(Point:new(26, 52))
  want_field_part:set(Point:new(28, 52))
  want_field_part:set(Point:new(26, 54))
  want_field_part:set(Point:new(27, 55))
  want_field_part:set(Point:new(29, 55))

  luaunit.assert_true(types.is_instance(game, Game))

  luaunit.assert_true(types.is_instance(game.settings, GameSettings))
  luaunit.assert_is(game.settings, settings)

  luaunit.assert_true(types.is_instance(game._field, PlacedField))
  luaunit.assert_equals(game._field, want_field)

  luaunit.assert_true(types.is_instance(game._field_part, PlacedField))
  luaunit.assert_equals(game._field_part, want_field_part)
end

function TestGame.test_count()
  local game = Game:new(GameSettings:new(
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3),
    FieldSettings:new(Size:new(6, 13), Point:new(24, 43), 0.2, 10, 100)
  ))
  local count = game:count()

  local want_count = game._field:count()

  luaunit.assert_is_number(count)
  luaunit.assert_equals(count, want_count)
end

function TestGame.test_offset()
  local game = Game:new(GameSettings:new(
    FieldSettings:new(Size:new(5, 12), Point:new(23, 42), 0.1, 2, 3),
    FieldSettings:new(Size:new(6, 13), Point:new(24, 43), 0.2, 10, 100)
  ))
  local offset = game:offset()

  luaunit.assert_true(types.is_instance(offset, Point))
  luaunit.assert_equals(offset, Point:new(24, 43))
end

function TestGame.test_move_success()
  local game = Game:new(GameSettings:new(
    FieldSettings:new(Size:new(10, 10)),
    FieldSettings:new(Size:new(3, 3), Point:new(6, 6), 1)
  ))
  game:move(Point:new(1, 1))

  local want_field_part = PlacedField:new(Size:new(3, 3), Point:new(7, 7))
  want_field_part:set(Point:new(7, 7))
  want_field_part:set(Point:new(8, 7))
  want_field_part:set(Point:new(9, 7))
  want_field_part:set(Point:new(7, 8))
  want_field_part:set(Point:new(8, 8))
  want_field_part:set(Point:new(9, 8))
  want_field_part:set(Point:new(7, 9))
  want_field_part:set(Point:new(8, 9))
  want_field_part:set(Point:new(9, 9))

  luaunit.assert_true(types.is_instance(game._field_part, PlacedField))
  luaunit.assert_equals(game._field_part, want_field_part)
end

function TestGame.test_move_failure()
  local game = Game:new(GameSettings:new(
    FieldSettings:new(Size:new(10, 10)),
    FieldSettings:new(Size:new(3, 3), Point:new(6, 6), 1)
  ))
  game:move(Point:new(2, 2))

  local want_field_part = PlacedField:new(Size:new(3, 3), Point:new(6, 6))
  want_field_part:set(Point:new(6, 6))
  want_field_part:set(Point:new(7, 6))
  want_field_part:set(Point:new(8, 6))
  want_field_part:set(Point:new(6, 7))
  want_field_part:set(Point:new(7, 7))
  want_field_part:set(Point:new(8, 7))
  want_field_part:set(Point:new(6, 8))
  want_field_part:set(Point:new(7, 8))
  want_field_part:set(Point:new(8, 8))

  luaunit.assert_true(types.is_instance(game._field_part, PlacedField))
  luaunit.assert_equals(game._field_part, want_field_part)
end

function TestGame.test_rotate()
  local game = Game:new(GameSettings:new(
    FieldSettings:new(Size:new(10, 10)),
    FieldSettings:new(Size:new(3, 3))
  ))

  game._field_part = PlacedField:new(Size:new(3, 3))
  game._field_part:set(Point:new(0, 0))
  game._field_part:set(Point:new(1, 0))
  game._field_part:set(Point:new(2, 0))
  game._field_part:set(Point:new(0, 1))
  game._field_part:set(Point:new(1, 1))
  game._field_part:set(Point:new(0, 2))

  game:rotate()

  local want_field_part = PlacedField:new(Size:new(3, 3))
  want_field_part:set(Point:new(0, 0))
  want_field_part:set(Point:new(1, 0))
  want_field_part:set(Point:new(2, 0))
  want_field_part:set(Point:new(1, 1))
  want_field_part:set(Point:new(2, 1))
  want_field_part:set(Point:new(2, 2))

  luaunit.assert_true(types.is_instance(game._field_part, PlacedField))
  luaunit.assert_equals(game._field_part, want_field_part)
end

function TestGame.test_union_success()
  math.randomseed(1)

  local game = Game:new(GameSettings:new(
    FieldSettings:new(Size:new(4, 4)),
    FieldSettings:new(Size:new(3, 3))
  ))

  game._field = PlacedField:new(Size:new(4, 4))
  game._field:set(Point:new(1, 0))
  game._field:set(Point:new(2, 1))

  game._field_part = PlacedField:new(Size:new(3, 3))
  game._field_part:set(Point:new(0, 2))
  game._field_part:set(Point:new(1, 2))
  game._field_part:set(Point:new(2, 2))

  game:union()

  local want_field = PlacedField:new(Size:new(4, 4))
  want_field:set(Point:new(0, 1))
  want_field:set(Point:new(2, 1))
  want_field:set(Point:new(1, 2))
  want_field:set(Point:new(2, 2))
  want_field:set(Point:new(1, 3))

  luaunit.assert_true(types.is_instance(game._field, PlacedField))
  luaunit.assert_equals(game._field, want_field)

  local want_field_part = PlacedField:new(Size:new(3, 3))
  want_field_part:set(Point:new(0, 0))
  want_field_part:set(Point:new(1, 0))
  want_field_part:set(Point:new(0, 1))
  want_field_part:set(Point:new(1, 2))

  luaunit.assert_true(types.is_instance(game._field_part, PlacedField))
  luaunit.assert_equals(game._field_part, want_field_part)
end

function TestGame.test_union_failure()
  local game = Game:new(GameSettings:new(
    FieldSettings:new(Size:new(4, 4)),
    FieldSettings:new(Size:new(3, 3))
  ))

  game._field = PlacedField:new(Size:new(4, 4))
  game._field:set(Point:new(1, 0))
  game._field:set(Point:new(2, 1))
  game._field:set(Point:new(0, 2))

  game._field_part = PlacedField:new(Size:new(3, 3))
  game._field_part:set(Point:new(0, 2))
  game._field_part:set(Point:new(1, 2))
  game._field_part:set(Point:new(2, 2))

  game:union()

  local want_field = PlacedField:new(Size:new(4, 4))
  want_field:set(Point:new(1, 0))
  want_field:set(Point:new(2, 1))
  want_field:set(Point:new(0, 2))

  luaunit.assert_true(types.is_instance(game._field, PlacedField))
  luaunit.assert_equals(game._field, want_field)

  local want_field_part = PlacedField:new(Size:new(3, 3))
  want_field_part:set(Point:new(0, 2))
  want_field_part:set(Point:new(1, 2))
  want_field_part:set(Point:new(2, 2))

  luaunit.assert_true(types.is_instance(game._field_part, PlacedField))
  luaunit.assert_equals(game._field_part, want_field_part)
end
