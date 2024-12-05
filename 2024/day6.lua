-- Process input file

local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day6", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)
local number = lpeg.C(lpeg.digit^1) / tonumber
local empty = lpeg.C(".")
local obstacle = lpeg.C("#")
local guard = lpeg.C("^")
local row = lpeg.Ct((empty + obstacle + guard)^1 * lpeg.space)
local map = lpeg.Ct(row^1)

local test = [[
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
]]

local match = lpeg.match(map, content)

local function findpos()
  for j, r in ipairs(match) do
    for i, v in ipairs(r) do
      if v == "^" then
        return { x = i, y = j }
      end
    end
  end
end


local pos = findpos()
local dir = { x = 0, y = -1 }

local init_pos_x = pos.x
local init_pos_y = pos.y

local cache = {}

local function check_cache()
  if cache[pos.y] == nil then
    cache[pos.y] = {}
  end

  if cache[pos.y][pos.x] == nil then
    cache[pos.y][pos.x] = {}
  end

  if cache[pos.y][pos.x][dir.y] == nil then
    cache[pos.y][pos.x][dir.y] = {}
  end

  if cache[pos.y][pos.x][dir.y][dir.x] == nil then
    cache[pos.y][pos.x][dir.y][dir.x] = true
    return false
  end

  return true
end

print(inspect(pos))

local function lookahead()
  local y = pos.y + dir.y
  local x = pos.x + dir.x

  local line = match[y]
  if line == nil then return nil end

  local slot = line[x]
  if slot == nil then return nil end

  return slot == "." or slot == "^" or slot == "+"
end

local function rotate()
  if dir.x == 0 and dir.y == -1 then
    dir.x = 1
    dir.y = 0
    return
  end

  if dir.x == 1 and dir.y == 0 then
    dir.x = 0
    dir.y = 1
    return
  end

  if dir.x == 0 and dir.y == 1 then
    dir.x = -1
    dir.y = 0
    return
  end

  if dir.x == -1 and dir.y == 0 then
    dir.x = 0
    dir.y = -1
    return
  end
end

local function mark()
  match[pos.y][pos.x] = "+"
end

local function move()
  pos.x = pos.x + dir.x
  pos.y = pos.y + dir.y
end

-- Part 1
local sum = 1
while true do
-- for i = 1, 10, 1 do
  local la = lookahead()
  if la == nil then
    break
  end

  if la then
    mark()
    move()
  else
    rotate()
  end
end

for _, r in ipairs(match) do
  for _, v in ipairs(r) do
    if v == "+" then
      sum = sum + 1
    end
  end
end
print(sum)


local function clone()
  local table = {}
  for j, r in ipairs(match) do
    table[j] = {}
    for i, v in ipairs(r) do
      table[j][i] = v
    end
  end
  return table
end

-- Part 2
local sum2 = 0
local function part2(j, i)
  pos = { x = init_pos_x, y = init_pos_y }
  dir = { x = 0, y = -1 }
  cache = {}

  while true do
    local la = lookahead()
    if la == nil then
      break
    end

    if la then
      move()
    else
      rotate()
    end

    if check_cache() then
      sum2 = sum2 + 1
      return true
    end
  end

  return false
end

match = lpeg.match(map, content)

for j, r in ipairs(match) do
  for i, v in ipairs(r) do
    if v == "." then
      match[j][i] = "O"

      part2(j, i)

      match[j][i] = "."
    end
  end
end

-- match[9][4] = "O"
-- part2()

print(sum2)
