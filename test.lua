local luaunit = require("luaunit")
local benchutils = require("lualife.benchutils")

for _, module in ipairs({
  "benchlocalutils",
  "factory",
  "game",
  "classifiedgame",
  "models.fieldsettings",
  "models.gamesettings",
  "models.cellclassification",
}) do
  require("biohazardcore." .. module .. "_test")
end

if benchutils.init() then
  for _, module in ipairs({
    "factory",
    "game",
    "classifiedgame",
    "models.fieldsettings",
    "models.gamesettings",
    "models.cellclassification",
  }) do
    require("biohazardcore." .. module .. "_bench")
  end
end

os.exit(luaunit.run())
