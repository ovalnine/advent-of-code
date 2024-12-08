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

local pc = prechecksum(match)
pc = check(pc)
local sum1 = checksum(pc)
print(sum1)

