-- Process input file

local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day7", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)
local number = lpeg.C(lpeg.digit^1) / tonumber
local colon = lpeg.P(":")
local newline = lpeg.P("\n")
local line = lpeg.Ct(number * colon * (lpeg.P(" ") * number)^1 * newline)
local lines = lpeg.Ct(line^1)

local test = [[
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
]]

local match = lpeg.match(lines, content)

local function toBits(num)
    local t={}

    while num>0 do
        local rest = math.fmod(num,2)
        t[#t+1] = rest
        num=(num - rest)/2
    end
    return t
end

local function toTriBits(num)
    local t={}

    while num>0 do
        local rest = math.fmod(num,3)
        t[#t+1] = rest
        num=(num - rest)/3
    end
    return t
end

local function operate(t)
  local result = t[1]
  local m = #t - 2
  local n = 2 ^ m
  -- print(inspect(t))
  for i = 0, (n - 1) do
    local bits = toBits(i)

    local temp_result = t[2]
    for j = 2, (#t - 1) do
      local bit = bits[j - 1]

      -- print(i, bit, temp_result, t[j + 1], inspect(bits))
      if bit == 0 or bit == nil then
        temp_result = temp_result * t[j + 1]
      else
        temp_result = temp_result + t[j + 1]
      end

      if temp_result > result then
        goto continue
      end
    end

    if temp_result == result then
      return result
    end


    ::continue::
  end

  return 0
end

local function operate2(t)
  local result = t[1]
  local m = #t - 2
  local n = 3 ^ m
  -- print(inspect(t))
  for i = 0, (n - 1) do
    local bits = toTriBits(i)

    local temp_result = t[2]
    for j = 2, (#t - 1) do
      local bit = bits[j - 1]

      -- print(i, bit, temp_result, t[j + 1], inspect(bits))
      if bit == 0 or bit == nil then
        temp_result = temp_result * t[j + 1]
      elseif bit == 1 then
        temp_result = temp_result + t[j + 1]
      elseif bit == 2 then
        temp_result = tonumber(tostring(temp_result) .. tostring(t[j + 1]))
      end

      if temp_result > result then
        goto continue
      end
    end

    if temp_result == result then
      return result
    end

    ::continue::
  end

  return 0
end

local sum = 0
local sum2 = 0
for _, m in ipairs(match) do
  -- sum = sum + operate(m)
  sum2 = sum2 + operate2(m)
end

print(sum2)
