-- Process input file

local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day2", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

local locale = lpeg.locale()
local digits = lpeg.C(locale.digit^1) / tonumber
local newline = lpeg.P'\n' + -1
local spaces = locale.space^0
local level = (digits * (spaces - newline))
local last_level = (digits * newline)
local line = lpeg.Ct(level^1 * last_level)
local pattern = lpeg.Ct(line^1)

local match = lpeg.match(pattern, content)

-- Test
local test = [[
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
]]

local test_match = lpeg.match(pattern, test)

-- Part 1

local sum = 0
for _,row in ipairs(match) do
  local sorting = ""

  for i,v in ipairs(row) do
    local nv = row[i + 1]
    -- print(v, nv, sorting, inspect(row))
    if nv == nil then
      print(inspect(row))
      sum = sum + 1
      goto continue
    end

    if v == nv then
      goto continue
    end

    if i == 1 then
      if v < nv then
        sorting = "asc"
      else
        sorting = "desc"
      end
    end

    if v < nv then
      if sorting ~= "asc" then
        goto continue
      else
        local dist = nv - v
        if dist < 1 or dist > 3 then
          goto continue
        end
      end
    else
      if sorting ~= "desc" then
        goto continue
      else
        local dist = v - nv
        if dist < 1 or dist > 3 then
          goto continue
        end
      end
    end

  end
    ::continue::
end

print(sum)
