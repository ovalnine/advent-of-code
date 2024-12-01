-- Process input file

local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day1", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

local locale = lpeg.locale()
local digits = lpeg.C(locale.digit^1)
local newline = lpeg.P'\n' + -1
local spaces = locale.space^1
local line = lpeg.Ct(digits * spaces * digits * newline)
local pattern = lpeg.Ct(line^1)

local match = lpeg.match(pattern, content)

-- Part 1

local left_list = {}
local right_list = {}
for i,t in ipairs(match) do
	table.insert(left_list, t[1])
	table.insert(right_list, t[2])
end

table.sort(left_list)
table.sort(right_list)

local sum = 0
for k in ipairs(left_list) do
	local left = left_list[k]
	local right = right_list[k]

	local distance = math.abs(left - right)
	sum = sum + distance
end

print(sum)

-- Part 2

local freq = {}
for _, v in ipairs(right_list) do
  freq[v] = (freq[v] or 0) + 1
end

sum = 0
for k,v in ipairs(left_list) do
	if not(freq[v] == nil) then
		sum = sum + (freq[v] * v)
	end
end

print(sum)
