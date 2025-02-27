# biohazardcore

[![doc:build](https://github.com/thewizardplusplus/biohazardcore/actions/workflows/doc.yaml/badge.svg)](https://github.com/thewizardplusplus/biohazardcore/actions/workflows/doc.yaml)
[![doc:link](https://img.shields.io/badge/doc%3Alink-link-blue?logo=github)](https://thewizardplusplus.github.io/biohazardcore/)
[![lint](https://github.com/thewizardplusplus/biohazardcore/actions/workflows/lint.yaml/badge.svg)](https://github.com/thewizardplusplus/biohazardcore/actions/workflows/lint.yaml)
[![test](https://github.com/thewizardplusplus/biohazardcore/actions/workflows/test.yaml/badge.svg)](https://github.com/thewizardplusplus/biohazardcore/actions/workflows/test.yaml)
[![luarocks](https://img.shields.io/badge/luarocks-link-blue?logo=lua)](https://luarocks.org/modules/thewizardplusplus/biohazardcore)

The library that implements the business logic of the puzzle game inspired by [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) and various block games.

_**Disclaimer:** this library was written directly on an Android smartphone with the [QLua](https://play.google.com/store/apps/details?id=com.quseit.qlua5pro2) IDE._

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
    - supporting of iteration via the `pairs()` function;
- creating a field by its settings:
  - random filling of the generated field;
- game business logic:
  - providing access:
    - to game settings;
    - to count of set cells in the primary field;
    - to an offset of the movable field part;
  - generating of random fields:
    - primary field;
    - movable field part;
  - operations with the movable field part:
    - moving:
      - returning of an operation success flag;
    - rotating;
    - unioning with the primary field:
      - returning of an operation success flag;
  - classifying cells (see the cell classification model for details).

## Installation

```
$ luarocks install biohazardcore
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

  local unioned = game:union()
  counter = counter + 1
until unioned
```

`biohazardcore.ClassifiedGame`:

```lua
local assertions = require("luatypechecks.assertions")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local ClassifiedGame = require("biohazardcore.classifiedgame")

local function print_field(field)
  assertions.is_instance(field, PlacedField)

  field:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

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
for cell_kind, cells in pairs(classification) do
  io.write(cell_kind .. ":\n")
  print_field(cells)
end
```

## License

The MIT License (MIT)

Copyright &copy; 2020 thewizardplusplus
