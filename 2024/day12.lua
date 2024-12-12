local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day12", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)
local row = lpeg.Ct(lpeg.C(lpeg.alpha)^1 * lpeg.space)
local rows = lpeg.Ct(row^1)

local test = [[
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
]]

local test2 = [[
AAAAAA
AAAAAA
AAABAA
AABAAA
AAAAAA
AAAAAA
]]

local match = lpeg.match(rows, test2)

local function print_grid(t)
  for key, value in pairs(t) do
    print(inspect(value))
  end
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

local function set_yx_add(t, y, x, d)
  if t[y] == nil then
    t[y] = {}
  end

  if t[y][x] == nil then
    t[y][x] = {}
  end

  if t[y][x][d] == nil then
    t[y][x][d] = 0
  end

  t[y][x][d] = t[y][x][d] + 1
end

local function set_yx_sub(t, y, x, d)
  if t[y] == nil then
    t[y] = {}
  end

  if t[y][x] == nil then
    t[y][x] = {}
  end

  if t[y][x][d] == nil then
    t[y][x][d] = 0
  end

  t[y][x][d] = t[y][x][d] - 1
end

local function toboolean(v)
    return v ~= nil and v ~= false
end
local function xor(a, b)
    return toboolean(a) ~= toboolean(b)
end

local function traverse(t, v, pos, q, c)
  if get_yx(v, pos.y, pos.x) then
    return 0, 0
  end

  set_yx(v, pos.y, pos.x)
  local curr = get_yx(t, pos.y, pos.x)
  local area = 1
  local prmt = 0

  local rtv = false
  local ltv = false
  local utv = false
  local dtv = false

  local rt = get_yx(t, pos.y, pos.x + 1)
  if rt == nil then
    prmt = prmt + 1
    rtv = true
    set_yx_add(c, pos.y, pos.x, "h")
    set_yx_add(c, pos.y, pos.x + 1, "h")
  elseif rt ~= curr then
    prmt = prmt + 1
    rtv = true
    set_yx_add(c, pos.y, pos.x, "h")
    set_yx_add(c, pos.y, pos.x + 1, "h")
    table.insert(q, { y = pos.y, x = pos.x + 1 })
  else
    local a, p = traverse(t, v, { y = pos.y, x = pos.x + 1}, q, c)
    area = area + a
    prmt = prmt + p
  end

  local lt = get_yx(t, pos.y, pos.x - 1)
  if lt == nil then
    prmt = prmt + 1
    ltv = true
    set_yx_add(c, pos.y, pos.x, "h")
    set_yx_add(c, pos.y, pos.x - 1, "h")
  elseif lt ~= curr then
    prmt = prmt + 1
    ltv = true
    set_yx_add(c, pos.y, pos.x, "h")
    set_yx_add(c, pos.y, pos.x - 1, "h")
    table.insert(q, { y = pos.y, x = pos.x - 1 })
  else
    local a, p = traverse(t, v, { y = pos.y, x = pos.x - 1 }, q, c)
    area = area + a
    prmt = prmt + p
  end

  local dn = get_yx(t, pos.y + 1, pos.x)
  if dn == nil then
    prmt = prmt + 1
    dtv = true
    set_yx_add(c, pos.y, pos.x, "v")
    set_yx_add(c, pos.y + 1, pos.x, "v")
  elseif dn ~= curr then
    prmt = prmt + 1
    dtv = true
    set_yx_add(c, pos.y, pos.x, "v")
    set_yx_add(c, pos.y + 1, pos.x, "v")
    table.insert(q, { y = pos.y + 1, x = pos.x })
  else
    local a, p = traverse(t, v, { y = pos.y + 1, x = pos.x }, q, c)
    area = area + a
    prmt = prmt + p
  end

  local up = get_yx(t, pos.y - 1, pos.x)
  if up == nil then
    prmt = prmt + 1
    utv = true
    set_yx_add(c, pos.y, pos.x, "v")
    set_yx_add(c, pos.y - 1, pos.x, "v")
  elseif up ~= curr then
    prmt = prmt + 1
    utv = true
    set_yx_add(c, pos.y, pos.x, "v")
    set_yx_add(c, pos.y - 1, pos.x, "v")
    table.insert(q, { y = pos.y - 1, x = pos.x })
  else
    local a, p = traverse(t, v, { y = pos.y - 1, x = pos.x }, q, c)
    area = area + a
    prmt = prmt + p
  end

  if rtv and utv and not(ltv) and not(dtv) then
    local cru = get_yx(t, pos.y - 1, pos.x + 1)
    if cru == curr then
      set_yx_sub(c, pos.y, pos.x + 1, "h")
      set_yx_sub(c, pos.y - 1, pos.x, "v")
    end
  end

  if ltv and utv and not(rtv) and not(dtv) then
    local cru = get_yx(t, pos.y - 1, pos.x - 1)
    if cru == curr then
      set_yx_sub(c, pos.y, pos.x - 1, "h")
      set_yx_sub(c, pos.y - 1, pos.x, "v")
    end
  end

  if rtv and dtv and not(ltv) and not(utv) then
    local cru = get_yx(t, pos.y + 1, pos.x + 1)
    if cru == curr then
      set_yx_sub(c, pos.y, pos.x + 1, "h")
      set_yx_sub(c, pos.y + 1, pos.x, "v")
    end
  end

  if ltv and dtv and not(rtv) and not(utv) then
    local cru = get_yx(t, pos.y + 1, pos.x - 1)
    if cru == curr then
      set_yx_sub(c, pos.y, pos.x - 1, "h")
      set_yx_sub(c, pos.y + 1, pos.x, "v")
    end
  end

  return area, prmt
end

local function clone(t)
  local nt = {}
  for index, value in pairs(t) do
    if type(value) == "table" then
      table.insert(nt, clone(value))
    else
      table.insert(nt, value)
    end
  end

  return nt
end

local visited = {}
local stack = { { x = 1, y = 1} }
local price = 0
while #stack > 0 do
  local pos = table.remove(stack)
  local a, p = traverse(match, visited, pos, stack, {})
  if a ~= 0 or p ~= 0 then
    price = price + (a * p)
  end
end
print(price)

local function count_corners(t)
  local sum = 0
  for i, tt in pairs(t) do
    for j, v in pairs(tt) do
      if v.v and v.h then
        local s = v.v + v.h
        if s == 2 then
          sum = sum + 1
        elseif s == 3 then
          sum = sum + 2
        elseif s == 4 then
          sum = sum + 4
        end
      end
    end
  end

  return sum
end

local visited2 = {}
local stack2 = { { x = 1, y = 1} }
local price2 = 0
while #stack2 > 0 do
  local corners = {}
  local pos = table.remove(stack2)
  local a, p = traverse(match, visited2, pos, stack2, corners)
  if a ~= 0 or p ~= 0 then
    local count = count_corners(corners)
    print("---------------------------------------")
    print(inspect(corners))
    print(count)
    price2 = price2 + (a * count)
  end
end

print(price2)
