-- Process input file

local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day4", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

local locale = lpeg.locale()
local digits = lpeg.C(locale.digit^1) / tonumber
local mul = lpeg.P("mul")
local mult = lpeg.Ct(mul * lpeg.P("(") * digits * lpeg.P(",") * digits * lpeg.P(")"))
local do_p = lpeg.P("do()") * lpeg.Cc(1)
local dont_p = lpeg.P("don't()") * lpeg.Cc(0)
local search = lpeg.Ct(lpeg.P{ mult + do_p + dont_p + 1 * lpeg.V(1)}^1)

local alpha = lpeg.C(locale.alpha)
local newline = lpeg.P'\n' + -1
local row = lpeg.Ct(alpha^1 * newline)
local all = lpeg.Ct(row^1)

local test = [[
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
]]

local match = lpeg.match(all, content)
local width = #match[1]
local height = #match

local function right(j, i)
  if i <= (width - 3) then
    local m = match[j][i + 1]
    local a = match[j][i + 2]
    local s = match[j][i + 3]

    return m == "M" and a == "A" and s == "S"
  else
    return false
  end
end

local function left(j, i)
  if i > 3 then
    local m = match[j][i - 1]
    local a = match[j][i - 2]
    local s = match[j][i - 3]

    return m == "M" and a == "A" and s == "S"
  else
    return false
  end
end

local function up(j, i)
  if j > 3 then
    local m = match[j - 1][i]
    local a = match[j - 2][i]
    local s = match[j - 3][i]

    return m == "M" and a == "A" and s == "S"
  else
    return false
  end
end

local function down(j, i)
  if j <= (height - 3) then
    local m = match[j + 1][i]
    local a = match[j + 2][i]
    local s = match[j + 3][i]

    return m == "M" and a == "A" and s == "S"
  else
    return false
  end
end

local function right_up(j, i)
  if i <= (width - 3) and j > 3 then
    local m = match[j - 1][i + 1]
    local a = match[j - 2][i + 2]
    local s = match[j - 3][i + 3]

    return m == "M" and a == "A" and s == "S"
  end

  return false
end

local function right_down(j, i)
  if i <= (width - 3) and j <= (height - 3) then
    local m = match[j + 1][i + 1]
    local a = match[j + 2][i + 2]
    local s = match[j + 3][i + 3]

    return m == "M" and a == "A" and s == "S"
  end

  return false
end

local function left_up(j, i)
  if i > 3 and j > 3 then
    local m = match[j - 1][i - 1]
    local a = match[j - 2][i - 2]
    local s = match[j - 3][i - 3]

    return m == "M" and a == "A" and s == "S"
  end

  return false
end

local function left_down(j, i)
  if i > 3 and j <= (height - 3) then
    local m = match[j + 1][i - 1]
    local a = match[j + 2][i - 2]
    local s = match[j + 3][i - 3]

    return m == "M" and a == "A" and s == "S"
  end

  return false
end

local function xmas1(j, i)
  local sum = 0
  if right(j, i) then
    sum = sum + 1
  end
  if left(j, i) then
    sum = sum + 1
  end
  if up(j, i) then
    sum = sum + 1
  end
  if down(j, i) then
    sum = sum + 1
  end
  if right_up(j, i) then
    sum = sum + 1
  end
  if right_down(j, i) then
    sum = sum + 1
  end
  if left_up(j, i) then
    sum = sum + 1
  end
  if left_down(j, i) then
    sum = sum + 1
  end
  return sum
end

-- Part 2

local function backslash(j, i)
  if (j + 1) > height or (j - 1) < 1 then
    return false
  end

  local m = match[j - 1][i - 1]
  local s = match[j + 1][i + 1]

  return (m == "M" and s == "S") or (m == "S" and s == "M")
end

local function fowardslash(j, i)
  if (j + 1) > height or (j - 1) < 1 then
    return false
  end

  local m = match[j - 1][i + 1]
  local s = match[j + 1][i - 1]

  return (m == "M" and s == "S") or (m == "S" and s == "M")
end

local function xmas2(j, i)
  local sum = 0

  if backslash(j, i) and fowardslash(j, i) then
    return 1
  else
    return 0
  end
end


local sum = 0
local sum2 = 0
for j,b in ipairs(match) do
  for i,a in ipairs(b) do
    if a == "X" then
      sum = sum + xmas1(j, i)
    end

    if a == "A" then
      sum2 = sum2 + xmas2(j, i)
    end
  end
end

print(sum)
print(sum2)
