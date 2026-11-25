local benchutils = require("lualife.benchutils")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local factory = require("biohazardcore.factory")

-- luacheck: globals TestFactoryBench
TestFactoryBench = {}

function TestFactoryBench.setupClass()
  benchutils.print_name()
end

function TestFactoryBench.test_create_field()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field_settings = benchlocalutils.new_field_settings(size)

    math.randomseed(1)

    benchutils.run(string.format(
      "factory.create_field() (%dx%d, filling: %g%%, %g..%g%% alive)",
      field_settings.size.width,
      field_settings.size.height,
      100 * benchlocalutils.FIELD_TARGET_FILLING,
      100 * benchlocalutils.FIELD_MIN_ALIVE_RATIO,
      100 * benchlocalutils.FIELD_MAX_ALIVE_RATIO
    ), function()
      return factory.create_field(field_settings)
    end)
  end
end
