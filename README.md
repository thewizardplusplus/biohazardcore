# biohazardcore

The library that implements the business logic of the puzzle game inspired by [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) and various block games.

## Features

- models:
  - field settings:
    - storing:
      - size;
      - initial offset;
      - filling;
      - minimal count;
      - maximal count;
    - supporting of default values for some settings;
  - game settings:
    - storing:
      - primary field settings;
      - movable field part settings;
  - cell classification:
    - static possibilities:
      - list of all known cell kinds;
      - checking if a cell kind is known;
    - storing:
      - old cells (those that are presented in the primary field, but not presented in the movable field part);
      - new cells (those that are presented in the movable field part, but not presented in the primary field);
      - intersection between the primary field and the movable field part;
- creating a field by its settings:
  - random filling of the generated field;
- game business logic:
  - providing access:
    - to game settings;
    - to an offset of the movable field part;
  - generating of random fields:
    - primary field;
    - movable field part;
  - operations with the movable field part:
    - moving;
    - rotating;
    - unioning with the primary field;
  - classifying cells (see the cell classification model for details).

## Installation

Clone this repository:

```
$ git clone https://github.com/thewizardplusplus/biohazardcore.git
$ cd biohazardcore
```

Install the library with the [LuaRocks](https://luarocks.org/) tool:

```
$ luarocks make
```

## Examples

`biohazardcore.Game`:

```lua
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local Game = require("biohazardcore.game")

math.randomseed(os.time())

local game = Game:new(GameSettings:new(
  FieldSettings:new(Size:new(11, 11), Point:new(0, 0), 0.4),
  FieldSettings:new(Size:new(3, 3), Point:new(4, 4), 0.5, 5, 5)
))
local counter = 0
repeat
  local action = math.floor(5 * math.random())
  local action_description
  if action == 0 then
    action_description = "move left"
    game:move(Point:new(-1, 0))
  elseif action == 1 then
    action_description = "move right"
    game:move(Point:new(1, 0))
  elseif action == 2 then
    action_description = "move top"
    game:move(Point:new(0, -1))
  elseif action == 3 then
    action_description = "move bottom"
    game:move(Point:new(0, 1))
  else
    action_description = "rotate"
    game:rotate()
  end
  print(string.format("step #%d: " .. action_description, counter + 1))

  local previous_field_part = game._field_part
  game:union()

  counter = counter + 1
until game._field_part ~= previous_field_part
```

`biohazardcore.ClassifiedGame`:

```lua
local types = require("lualife.types")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local CellClassification = require("biohazardcore.models.cellclassification")
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
for _, cell_kind in ipairs(CellClassification:cell_kinds()) do
  print_field(classification[cell_kind])
end
```

## License

The MIT License (MIT)

Copyright &copy; 2020 thewizardplusplus
