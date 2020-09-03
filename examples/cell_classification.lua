local types = require("lualife.types")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local ClassifiedGame = require("biohazardcore.classifiedgame")

local function print_field(field)
  assert(types.is_instance(field, PlacedField))

  field:map(function(point, contains)
    io.write(contains and "O" or ".")

    if point.x - field.offset.x == field.size.width - 1 then
      io.write("\n")
    end
  end)

  io.write("\n")
end

local game = ClassifiedGame:new(GameSettings:new(
  FieldSettings:new(Size:new(3, 3)),
  FieldSettings:new(Size:new(3, 3))
))

game._field = PlacedField:new(Size:new(3, 3))
game._field:set(Point:new(0, 0))
game._field:set(Point:new(0, 1))
game._field:set(Point:new(0, 2))

game._field_part = PlacedField:new(Size:new(3, 3))
game._field_part:set(Point:new(1, 0))
game._field_part:set(Point:new(2, 1))
game._field_part:set(Point:new(0, 2))
game._field_part:set(Point:new(1, 2))
game._field_part:set(Point:new(2, 2))

local classification = game:classify_cells()
print_field(classification.old)
print_field(classification.new)
print_field(classification.intersection)
