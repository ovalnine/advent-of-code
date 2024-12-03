-- Process input file

local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day3", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

local locale = lpeg.locale()
local digits = lpeg.C(locale.digit^1) / tonumber
local mul = lpeg.P("mul")
local mult = lpeg.Ct(mul * lpeg.P("(") * digits * lpeg.P(",") * digits * lpeg.P(")"))
local do_p = lpeg.P("do()") * lpeg.Cc(1)
local dont_p = lpeg.P("don't()") * lpeg.Cc(0)
local search = lpeg.Ct(lpeg.P{ mult + do_p + dont_p + 1 * lpeg.V(1)}^1)

local test = [[
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
]]

local match = lpeg.match(search, content)

print(inspect(match))

local sum = 0
local enable = 1
for _, value in pairs(match) do

  if type(value) ~= "table" then
    enable = value
  else
    sum = sum + enable * (value[1] * value[2])
  end
end

print(sum)
