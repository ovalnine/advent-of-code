local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day9", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

local test = [[
2333133121414131402
]]

lpeg.locale(lpeg)
local number = lpeg.digit / tonumber
local numbers = lpeg.Ct(number^1)
local match = lpeg.match(numbers, content)

local disk = {}
for index, value in ipairs(match) do
  local id =  (index - 1) / 2
  local map = index % 2 == 1 and { value, id } or value
  table.insert(disk, map)
end

-- print(inspect(disk))

local function first_from(a, i, t)
  for j = i, #a do
    if type(a[j]) == t then
      return j
    end
  end

  return -1
end

local function last_from(a, i, t)
  for j = i, 0, -1 do
    if type(a[j]) == "table" then
      return j
    end
  end

  return -1
end

local visited = {}
local i = first_from(disk, 1, "number")
local j = last_from(disk, #disk, "table")
while true do
  local ii = disk[i]
  local jj = disk[j]

  if i >= j then
      i = first_from(disk, 1, "number")
      j = last_from(disk, j - 1, "table")
  else
    if jj[1] > ii then
      i = first_from(disk, i + 1, "number")

      if i == -1 then
        visited[jj[2]] = true
        i = first_from(disk, 1, "number")
        j = last_from(disk, j - 1, "table")
      end
    else
      if visited[jj[2]] then
        i = first_from(disk, 1, "number")
        j = last_from(disk, j - 1, "table")
      else
        visited[jj[2]] = true
        disk[i] = disk[i] - jj[1]
        table.insert(disk, j, jj[1])
        local temp = table.remove(disk, j + 1)
        table.insert(disk, i, temp)
        i = first_from(disk, 1, "number")
        j = last_from(disk, #disk, "table")
      end
    end
  end

  if j == -1 then
    break
  end
end

-- print(inspect(disk))

local sum = 0
local gp2 = 0
for index, value in ipairs(disk) do
  if type(value) == "table" then
    for k = 1, value[1] do
      sum = sum + gp2 * value[2]
      gp2 = gp2 + 1
    end
  end

  if type(value) == "number" then
    for k = 1, value do
      gp2 = gp2 + 1
    end
  end
end

print(sum)

local function sum(t)
  local s = 0
  for _, value in ipairs(t) do
    s = s + value
  end

  return s
end

local function prechecksum(t)
  local result = {}
  local length = sum(t)
  local id = 0
  local i = 1
  local gp = 0
  for index, value in pairs(t) do
    for _ = 1, value do
      gp = gp + 1
      if index % 2 ~= 0 then
        result[gp] = id
      else
        result[gp] = -1
      end
    end

    if index % 2 == 0 then
      id = id + 1
    end
  end

  return result
end

local function check(t)
  local i = 1
  while true do
    if i >= #t then
      break
    end

    local v = t[i]
    if v == -1 then
      local temp = nil

      while true do
        if i >= #t then
          break
        end

        temp = table.remove(t)
        if temp ~= -1 then
          break
        end
      end

      t[i] = temp
    end

    i = i + 1
  end

  return t
end

local function checksum(t)
  local s = 0

  for key, value in pairs(t) do
    if value ~= -1 then
      s = s + value * (key - 1)
    end
  end

  return s
end

-- local pc = prechecksum(match)
-- pc = check(pc)
-- local sum1 = checksum(pc)
-- print(sum1)

