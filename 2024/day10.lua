local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day10", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

local test = [[
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
]]

lpeg.locale(lpeg)
local number = lpeg.digit / tonumber
local numbers = lpeg.Ct(number^1 * (lpeg.space + -1))
local all = lpeg.Ct(numbers^1)
local map = lpeg.match(all, content)

local function print_grid(t)
  for key, value in pairs(t) do
    print(inspect(value))
  end
end

local function find_values(t, value)
  local r = {}
  for j, v in pairs(t) do
    for i, u in pairs(v) do
      if u == value then
        table.insert(r, { x = i, y = j })
      end
    end
  end

  return r
end


local function compare(v, u)
  return u - v == 1
end

local function get_yx(t, y, x)
  return t[y] and t[y][x]
end

local function set_yx(t, y, x)
  if t[y] == nil then
    t[y] = {}
  end

  t[y][x] = true
end

local function traverse(map, pos, memo)
  local v = map[pos.y][pos.x]

  if v == 9 then
    if get_yx(memo, pos.y, pos.x) then
      return 0
    end

    set_yx(memo, pos.y, pos.x) -- Comment for Part 2 solution
    return 1
  end

  local sum = 0

  local vr = map[pos.y][pos.x + 1]
  if vr ~= nil then
    if compare(v, vr) then
      sum = sum + traverse(map, { x = pos.x + 1, y = pos.y }, memo)
    end
  end

  local vl = map[pos.y][pos.x - 1]
  if vl ~= nil then
    if compare(v, vl) then
      sum = sum + traverse(map, { x = pos.x - 1, y = pos.y }, memo)
    end
  end

  local vd = nil
  if map[pos.y + 1] ~= nil then
    vd = map[pos.y + 1][pos.x]
    if compare(v, vd) then
      sum = sum + traverse(map, { y = pos.y + 1, x = pos.x }, memo)
    end
  end

  local vu = nil
  if map[pos.y - 1] ~= nil then
    vu = map[pos.y - 1][pos.x]
    if compare(v, vu) then
      sum = sum + traverse(map, { y = pos.y - 1, x = pos.x }, memo)
    end
  end

  return sum
end

local trailheads = find_values(map, 0)

local sum = 0
for _, v in pairs(trailheads) do
  local memo = {}
  local result = traverse(map, v, memo)
  sum = sum + result
end

print(sum)
