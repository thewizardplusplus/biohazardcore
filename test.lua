local luaunit = require("luaunit")

for _, module in ipairs({
  "factory",
  "game",
  "classifiedgame",
  "models.fieldsettings",
  "models.gamesettings",
  "models.cellclassification",
}) do
  require("biohazardcore." .. module .. "_test")
end

os.exit(luaunit.run())
