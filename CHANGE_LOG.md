# Change Log

## [v1.3.1](https://github.com/thewizardplusplus/biohazardcore/tree/v1.3.1) (2026-09-12)

Using the `luatypechecks`, `luaserialization`, and `luamath` libraries for type validation, model serialization, and mathematical primitives.

- models:
  - field and game settings:
    - exposing a class name and a stringified representation via the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library;
    - generating a JSON Schema via the `schema()` static method;
    - constructing an instance from serializable options via the `from_options()` static method;
- refactoring:
  - replacing the internal `types` package with the [luatypechecks](https://github.com/thewizardplusplus/luatypechecks) library;
  - replacing the internal `Point` and `Size` classes with the [luamath](https://github.com/thewizardplusplus/luamath) library;
  - replacing the internal `Stringifiable` mixin with the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library;
- misc.:
  - adding GitHub Actions workflows for tests, linting, and documentation deployment;
  - supporting Lua 5.1, 5.2, 5.3, 5.4, 5.5, and LuaJIT;
  - improving the generated documentation.

## [v1.3](https://github.com/thewizardplusplus/biohazardcore/tree/v1.3) (2020-09-19)

Support iteration over cell classification, provide access to count of set cells in the primary field and return of a success flag for moving and unioning the movable field part.

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

Add static possibilities for cell classification and provide access to game settings and an offset of the movable field part.

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

Support cell classification.

- models:
  - cell classification:
    - storing:
      - old cells (those that are presented in the primary field, but not presented in the movable field part);
      - new cells (those that are presented in the movable field part, but not presented in the primary field);
      - intersection between the primary field and the movable field part;
- classifying cells (see the cell classification model for details):
  - adding an example for it.

## [v1.0](https://github.com/thewizardplusplus/biohazardcore/tree/v1.0) (2020-09-02)

Major version.
