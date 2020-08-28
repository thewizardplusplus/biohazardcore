local luaunit = require("luaunit")

for _, module in ipairs({
  "fieldsettings",
}) do
  require("biohazardcore." .. module .. "_test")
end

os.exit(luaunit.run())
