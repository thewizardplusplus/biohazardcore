local luaunit = require("luaunit")

for _, module in ipairs({
  "factory",
  "game",
  "models.fieldsettings",
  "models.gamesettings",
}) do
  require("biohazardcore." .. module .. "_test")
end

os.exit(luaunit.run())
