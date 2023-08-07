rockspec_format = "3.0"
package = "biohazardcore"
version = "1.3-1"
description = {
  summary = "The library that implements the business logic of the puzzle game inspired by Conway's Game of Life and various block games.",
  license = "MIT",
  maintainer = "thewizardplusplus <thewizardplusplus@yandex.ru>",
  homepage = "https://github.com/thewizardplusplus/biohazardcore",
}
source = {
  url = "git+https://github.com/thewizardplusplus/biohazardcore.git",
  tag = "v1.3",
}
dependencies = {
  "lua >= 5.1",
  "middleclass >= 4.1.1, < 5.0",
  "lualife >= 1.5.4, < 2.0",
  "luatypechecks >= 1.3.4, < 2.0",
}
test_dependencies = {
  "luaunit >= 3.4, < 4.0",
}
build = {
  type = "builtin",
  modules = {
    ["biohazardcore.factory"] = "factory.lua",
    ["biohazardcore.factory_test"] = "factory_test.lua",
    ["biohazardcore.game"] = "game.lua",
    ["biohazardcore.game_test"] = "game_test.lua",
    ["biohazardcore.classifiedgame"] = "classifiedgame.lua",
    ["biohazardcore.classifiedgame_test"] = "classifiedgame_test.lua",
    ["biohazardcore.models.fieldsettings"] = "models/fieldsettings.lua",
    ["biohazardcore.models.fieldsettings_test"] = "models/fieldsettings_test.lua",
    ["biohazardcore.models.gamesettings"] = "models/gamesettings.lua",
    ["biohazardcore.models.gamesettings_test"] = "models/gamesettings_test.lua",
    ["biohazardcore.models.cellclassification"] = "models/cellclassification.lua",
    ["biohazardcore.models.cellclassification_test"] = "models/cellclassification_test.lua",
  },
  copy_directories = {
    "doc",
  },
}
