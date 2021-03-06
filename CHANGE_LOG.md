# Change Log

## [v1.3](https://github.com/thewizardplusplus/biohazardcore/tree/v1.3) (2020-09-19)

- models:
  - cell classification:
    - supporting of iteration via the `pairs()` function;
- game business logic:
  - providing access:
    - to count of set cells in the primary field;
  - operations with the movable field part:
    - moving:
      - returning of an operation success flag;
    - unioning with the primary field:
      - returning of an operation success flag.

## [v1.2](https://github.com/thewizardplusplus/biohazardcore/tree/v1.2) (2020-09-08)

- models:
  - cell classification:
    - static possibilities:
      - list of all known cell kinds;
      - checking if a cell kind is known;
- game business logic:
  - providing access:
    - to game settings;
    - to an offset of the movable field part.

## [v1.1](https://github.com/thewizardplusplus/biohazardcore/tree/v1.1) (2020-09-03)

- models:
  - cell classification:
    - storing:
      - old cells (those that are presented in the primary field, but not presented in the movable field part);
      - new cells (those that are presented in the movable field part, but not presented in the primary field);
      - intersection between the primary field and the movable field part;
- classifying cells (see the cell classification model for details):
  - adding an example for it.

## [v1.0](https://github.com/thewizardplusplus/biohazardcore/tree/v1.0) (2020-09-02)
