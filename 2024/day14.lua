local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day14", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)
local number = lpeg.P("-")^0 * lpeg.digit^1 / tonumber
local position = lpeg.Ct(lpeg.P("p=") * number * lpeg.P(",") * number)
local velocity = lpeg.Ct(lpeg.P("v=") * number * lpeg.P(",") * number)
local row = lpeg.Ct(position * lpeg.space * velocity * (lpeg.P("\n") + -1))
local rows = lpeg.Ct(row^1)

local test = [[
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
]]

local match = lpeg.match(rows, content)

local width = 101 --11
local height = 103 --7

local function linear(p, v, t)
  return p + v * t
end

local gpos = {}
for key, value in pairs(match) do
  local p = value[1]
  local v = value[2]

  table.insert(gpos, { linear(p[1], v[1], 100) % width, linear(p[2], v[2], 100) % height })
end

local sumq1 = 0
local sumq2 = 0
local sumq3 = 0
local sumq4 = 0
for key, value in pairs(gpos) do
  local xx = value[1]
  local yy = value[2]

  local hw = math.floor(width/2)
  local hh = math.floor(height/2)

  if xx < hw and yy < hh then
    sumq1 = sumq1 + 1
  end

  if xx > hw and yy < hh then
    sumq2 = sumq2 + 1
  end

  if xx < hw and yy > hh then
    sumq3 = sumq3 + 1
  end

  if xx > hw and yy > hh then
    sumq4 = sumq4 + 1
  end
end

print(sumq1 * sumq2 * sumq3 * sumq4)

local cache = {}
local t = 0
local exit = false
while not(exit) do
  exit = true
  cache = {}

  for key, value in pairs(match) do
    local p = value[1]
    local v = value[2]

    local x = linear(p[1], v[1], t) % width
    local y = linear(p[2], v[2], t) % height

    if cache[x] == nil then
      cache[x] = {}
    end

    if cache[x][y] == nil then
      cache[x][y] = 1
    else
      exit = false
      break
    end
  end

  t = t + 1
end
t = t - 1

print(t)

