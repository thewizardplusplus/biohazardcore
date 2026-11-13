local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("biohazardcore.benchlocalutils")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local factory = require("biohazardcore.factory")

local _TARGET_FILLING = 0.2
local _MIN_ALIVE_RATIO, _MAX_ALIVE_RATIO = 0.18, 0.22

-- luacheck: globals TestFactoryBench
TestFactoryBench = {}

function TestFactoryBench.setupClass()
  benchutils.print_name()
end

function TestFactoryBench.test_create_field()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local area = size * size
    local settings = FieldSettings:new(
      Size:new(size, size),
      nil,
      _TARGET_FILLING,
      Range:new(
        math.floor(area * _MIN_ALIVE_RATIO),
        math.ceil(area * _MAX_ALIVE_RATIO)
      )
    )

    math.randomseed(1)

    benchutils.run(string.format(
      "factory.create_field() (%dx%d, filling: %g%%, %g..%g%% alive)",
      settings.size.width,
      settings.size.height,
      100 * _TARGET_FILLING,
      100 * _MIN_ALIVE_RATIO,
      100 * _MAX_ALIVE_RATIO
    ), function()
      return factory.create_field(settings)
    end)
  end
end
