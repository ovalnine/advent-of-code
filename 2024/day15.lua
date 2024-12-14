local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day15", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)

-- local width = 10
-- local height = 10
local width = 50
local height = 50

local start = {}
local map = {}
local function yx(t)
  local l = t[1]
  local e = t[2]

  local x = l % (width + 1)
  local y = math.floor(l / (width + 1)) + 1

  if e == "@" then
    start.x = x
    start.y = y
  end

  if map [y] == nil then
    map [y] = {}
  end

  map[y][x] = e
end

local start2 = {}
local map2 = {}
local function yx2(t)
  local l = t[1]
  local e = t[2]

  local x = (l % (width + 1) * 2)
  local y = math.floor(l / (width + 1)) + 1

  if map2 [y] == nil then
    map2 [y] = {}
  end

  if e == "#" or e == "." then
    map2[y][x] = e
    map2[y][x - 1] = e
  end

  if e == "O" then
    map2[y][x - 1] = "["
    map2[y][x] = "]"
  end

  if e == "@" then
    start2.x = x - 1
    start2.y = y

    map2[y][x] = "."
    map2[y][x - 1] = "@"
  end
end

local wall = lpeg.Ct(lpeg.Cp() * lpeg.C("#")) / yx
local box = lpeg.Ct(lpeg.Cp() * lpeg.C("O")) / yx
local empty = lpeg.Ct(lpeg.Cp() * lpeg.C(".")) / yx
local subm = lpeg.Ct(lpeg.Cp() * lpeg.C("@")) / yx
local mapp = (wall + box + empty + subm + lpeg.space)^1
local dirp = (lpeg.C("<") + lpeg.C(">") + lpeg.C("^") + lpeg.C("v"))^1
local dirsp = lpeg.Ct((dirp * (lpeg.P("\n") + -1))^1)
local all = mapp * dirsp

local wall2 = lpeg.Ct(lpeg.Cp() * lpeg.C("#")) / yx2
local box2 = lpeg.Ct(lpeg.Cp() * lpeg.C("O")) / yx2
local empty2 = lpeg.Ct(lpeg.Cp() * lpeg.C(".")) / yx2
local subm2 = lpeg.Ct(lpeg.Cp() * lpeg.C("@")) / yx2
local mapp2 = (wall2 + box2 + empty2 + subm2 + lpeg.space)^1
local all2 = mapp2 * dirsp

local test = [[
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
]]


local match = lpeg.match(all, content)
local match2 = lpeg.match(all2, content)

local function print_grid(t)
  for _, tt in pairs(t) do
    print(inspect(tt))
  end
end

print_grid(map2)

local function get_yx(t, y, x)
  if t[y] == nil then
    return nil
  end

  return t[y][x]
end

local function get_dir(pos, dir)
  if dir == ">" then
    return pos.x + 1, pos.y
  end

  if dir == "<" then
    return pos.x - 1, pos.y
  end

  if dir == "v" then
    return pos.x, pos.y + 1
  end

  if dir == "^" then
    return pos.x, pos.y - 1
  end
end

local function switch(t, posa, posb)
  local a = get_yx(t, posa.y, posa.x)
  local b = get_yx(t, posb.y, posb.x)
  t[posa.y][posa.x] = b
  t[posb.y][posb.x] = a
end

local function move(pos, dir)
  local e = get_yx(map, pos.y, pos.x)

  if e == "." then
    return true
  end

  if e == "#" then
    return false
  end

  local x, y = get_dir(pos, dir)

  local m = move({ x = x, y = y }, dir)

  if not(m) then
    return false
  end

  switch(map, pos, { x = x, y = y })

  return true
end


local pos = { x = start.x, y = start.y }
for key, dir in pairs(match) do
  if move(pos, dir) then
    local x, y = get_dir(pos, dir)
    pos.x = x
    pos.y = y
  end
end

local sum = 0
for j, y in pairs(map) do
  for i, v in pairs(y) do
    if v == "O" then
      sum = sum + (100 * (j - 1) + (i - 1))
    end
  end
end

print(sum)

local function set_yx(t, y, x)
  if t[y] == nil then
    t[y] = {}
  end

  t[y][x] = true
end

local function traverse2(pos, dir, dirs, visited)
  local nx, ny = get_dir(pos, dir)
  local next = { x = nx, y = ny }
  local ne = get_yx(map2, ny, nx)

  if ne == "#" then
    return false
  end

  if ne == "[" or ne == "]" then
    if dir == "^" or dir == "v" then
      local x = 0
      if ne == "[" then x = 1 else x = -1 end
      if traverse2(next, dir, dirs, visited) and traverse2({ x = nx + x, y = ny }, dir, dirs, visited) then
        -- print("here0", inspect(pos))
        if not(get_yx(visited, pos.y, pos.x)) then
          table.insert(dirs, pos)
        end

        set_yx(visited, pos.y, pos.x)
        return true
      end

      return false
    end

    if traverse2(next, dir, dirs, visited) then
      -- print("here1", inspect(pos))
      if not(get_yx(visited, pos.y, pos.x)) then
        table.insert(dirs, pos)
      end

      set_yx(visited, pos.y, pos.x)
      return true
    end

    return false
  end

  if ne == "." then
    -- print("here2", inspect(pos))
    if not(get_yx(visited, pos.y, pos.x)) then
      table.insert(dirs, pos)
    end

    set_yx(visited, pos.y, pos.x)
    return true
  end
end

local pos2 = { x = start2.x, y = start2.y }
for _, dir in pairs(match) do
  local poss = {}
  local visited = {}
  local result = traverse2(pos2, dir, poss, visited)

  if result then
    if #poss > 0 then
      local x, y = get_dir(pos2, dir)
      pos2 = { x = x, y = y }
    end

    for _, p in pairs(poss) do
      local x, y = get_dir(p, dir)
      switch(map2, p, { x = x, y = y })
    end
  end
end

local sum2 = 0
for j, y in pairs(map2) do
  for i, v in pairs(y) do
    if v == "[" then
      sum2 = sum2 + (100 * (j - 1) + (i - 1))
    end
  end
end

print(sum2)
