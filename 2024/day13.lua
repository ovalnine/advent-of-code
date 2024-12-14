local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day13", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)
local number = lpeg.digit^1 / tonumber
local buttona = lpeg.Ct(lpeg.P("Button A: X+")*number*lpeg.P(", Y+")*number*lpeg.P("\n"))
local buttonb = lpeg.Ct(lpeg.P("Button B: X+")*number*lpeg.P(", Y+")*number*lpeg.P("\n"))
local prize = lpeg.Ct(lpeg.P("Prize: X=")*number*lpeg.P(", Y=")*number*lpeg.P("\n"))
local machine = lpeg.Ct(buttona*buttonb*prize)*(lpeg.P("\n") + -1)
local machines = lpeg.Ct(machine^1)

local test = [[
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
]]

local match = lpeg.match(machines, content)


local function solveLinearEquations(a1, b1, c1, a2, b2, c2)
    -- Calculate the determinant
    local determinant = a1 * b2 - a2 * b1

    if determinant == 0 then
        return nil, "The equations have no unique solution (parallel or coincident lines)."
    end

    -- Calculate the values of x and y
    local x = (c1 * b2 - c2 * b1) / determinant
    local y = (a1 * c2 - a2 * c1) / determinant

    return x, y
end

local sum = 0
for key, value in pairs(match) do
  local x, y = solveLinearEquations(value[1][1], value[2][1], value[3][1], value[1][2], value[2][2], value[3][2])

  if x ~= nil and y ~= nil then
    if x % 1 == 0  and y % 1 == 0 then
      sum = sum + (x * 3) + y
    end
  end
end
print(sum)

local sum2 = 0
for key, value in pairs(match) do
  local c1 = value[3][1] + 10000000000000
  local c2 = value[3][2] + 10000000000000
  local x, y = solveLinearEquations(value[1][1], value[2][1], c1, value[1][2], value[2][2], c2)

  if x ~= nil and y ~= nil then
    if x % 1 == 0 and y % 1 == 0 then
      sum2 = sum2 + (x * 3) + y
    end
  end
end
print(sum2)
