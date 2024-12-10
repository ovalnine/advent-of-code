local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day11", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)
local number = lpeg.digit^1 / tonumber
local numbers = number * (lpeg.space + -1)
local all = lpeg.Ct(numbers^1)

local test = [[
125 17
]]

local rocks = lpeg.match(all, content)

local memo = {}
local function set_memo(n, l, v)
  if memo[n] == nil then
    memo[n] = {}
  end

  memo[n][l] = v
end

local function get_memo(n, l)
  if memo[n] == nil then
    return nil
  end

  return memo[n][l]
end

local function expand2(rock, level, limit)
  local m = get_memo(rock, level)
  if m ~= nil then
    return m
  end

  if level == limit then
    return 1
  end

  local result = 0;
  if rock == 0 then
     result = expand2(1, level + 1, limit)
  else
    local rock_s = tostring(rock)
    local len = rock_s:len()
    if len % 2 == 0 then
      local rock_s_l = rock_s:sub(1, len/2)
      local rock_s_r = rock_s:sub(len/2 + 1, len)
      local rock_l = tonumber(rock_s_l)
      local rock_r = tonumber(rock_s_r)

      result = expand2(rock_l, level + 1, limit) + expand2(rock_r, level + 1, limit)
    else
      result = expand2(rock * 2024, level + 1, limit)
    end
  end

  set_memo(rock, level, result)
  return result
end

local sum1 = 0
for key, value in pairs(rocks) do
  sum1 = sum1 + expand2(value, 1, 26)
end

memo = {}
local sum2 = 0
for key, value in pairs(rocks) do
  sum2 = sum2 + expand2(value, 1, 76)
end

print(string.format("%18.0f", sum1))
print(string.format("%18.0f", sum2))
