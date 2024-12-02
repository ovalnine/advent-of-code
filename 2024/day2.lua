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


local function safety(row)
  local sorting = ""

  for i,v in ipairs(row) do
    local nv = row[i + 1]
    if nv == nil then
      return 1
    end

    if v == nv then
      return 0
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
        return 0
      else
        local dist = nv - v
        if dist < 1 or dist > 3 then
          return 0
        end
      end
    else
      if sorting ~= "desc" then
        return 0
      else
        local dist = v - nv
        if dist < 1 or dist > 3 then
          return 0
        end
      end
    end

  end
end

local function remove_index(t, i)
  local c = {}
  for k,v in ipairs(t) do
    if k ~= i then
      table.insert(c, v)
    end
  end
  return c
end

local sum = 0
local dampened_sum = 0
for _,row in ipairs(match) do
  local safe = safety(row)

  if safe == 1 then
    -- Part 1
    sum = sum + 1
  else
    -- Part 2
    for i = 1, #row do
      local row_copy = remove_index(row, i)
      local safe_copy = safety(row_copy)

      if safe_copy == 1 then
        dampened_sum = dampened_sum + 1
        goto nextrow
      end
    end

    ::nextrow::
  end
end

print(sum)
print(sum + dampened_sum)
