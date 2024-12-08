local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day8", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

local test = [[
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
]]

lpeg.locale(lpeg)

local rwidth = lpeg.match(lpeg.P{(lpeg.space * lpeg.Cp()) + 1 * lpeg.V(1)}, content) - 1
local height = (lpeg.match(lpeg.P{(-1 * lpeg.Cp()) + 1 * lpeg.V(1)}, content) - 1) / rwidth
local width = rwidth - 1

local function position(p)
  return { x =  ((p - 1) % rwidth), y = math.floor((p - 1)/rwidth + 1) }
end

local antennas = {}
local function create_antenna(t)
  local key = t[1]
  local value = t[2]
  if antennas[key] == nil then
    antennas[key] = {}
  end

  table.insert(antennas[key], value)

  return t
end

local pattern = lpeg.Ct((lpeg.P(".") + lpeg.Ct(lpeg.C(lpeg.alnum) * (lpeg.Cp() / position)) / create_antenna + lpeg.space)^1)
local match = lpeg.match(pattern, content)

local function roc(t1, t2)
  local dx = t1.x - t2.x
  local dy = t1.y - t2.y

  local anodes = { }

  local an = { x = t1.x + dx, y = t1.y + dy }
  if an.x <= width and an.x > 0  and an.y <= height and an.y > 0 then
    table.insert(anodes, an)
  end

  an = { x = t2.x - dx, y = t2.y - dy }
  if an.x <= width and an.x > 0  and an.y <= height and an.y > 0 then
    table.insert(anodes, an)
  end

  return anodes
end

local function roc2(t1, t2)
  local dx = t1.x - t2.x
  local dy = t1.y - t2.y

  local anodes = { }


  local an = { x = t1.x, y = t1.y }
  table.insert(anodes, an)

  while true do
    an = { x = an.x + dx, y = an.y + dy }

    if an.x <= width and an.x > 0  and an.y <= height and an.y > 0 then
      table.insert(anodes, an)
    else
      break
    end
  end

  local an = { x = t2.x, y = t2.y }
  table.insert(anodes, an)

  while true do
    an = { x = an.x - dx, y = an.y - dy }

    if an.x <= width and an.x > 0  and an.y <= height and an.y > 0 then
      table.insert(anodes, an)
    else
      break
    end
  end

  return anodes
end

local function combine(k, t, result)
  for i = 1, #t - 1 do
    for j = i + 1, #t do
      local anodes = roc(t[i], t[j])
      for _, value in pairs(anodes) do
        if result[value.x] == nil then
          result[value.x] = {}
        end

        result[value.x][value.y] = k
      end
    end
  end
end

local function combine2(k, t, result)
  for i = 1, #t - 1 do
    for j = i + 1, #t do
      local anodes = roc2(t[i], t[j])
      for _, value in pairs(anodes) do
        if result[value.x] == nil then
          result[value.x] = {}
        end

        result[value.x][value.y] = k
      end
    end
  end
end

local result = {}
local result2 = {}
for key, value in pairs(antennas) do
  combine(key, value, result)
  combine2(key, value, result2)
end

local sum = 0
for i, col in pairs(result) do
  for j, val in pairs(col) do
    sum = sum + 1
  end
end

local sum2 = 0
for i, col in pairs(result2) do
  for j, val in pairs(col) do
    sum2 = sum2 + 1
  end
end

print(sum)
print(sum2)

