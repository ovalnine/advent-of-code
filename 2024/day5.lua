-- Process input file

local math = require"math"
local inspect = require"inspect"
local lpeg = require "lpeg"
local file = io.open("./inputs/day5", "rb")

if file == nil then
  return
end

local content = file:read("*a")
file:close()

lpeg.locale(lpeg)
local number = lpeg.C(lpeg.digit^1) / tonumber
local rule_pattern = lpeg.Ct(number * lpeg.P("|") * number * lpeg.P"\n")
local update_pattern = lpeg.Ct((number * lpeg.P(","))^1 * (number * lpeg.P'\n'))

local rules_pattern = lpeg.Ct(rule_pattern^1)
local updates_pattern = lpeg.Ct(update_pattern^1)

local rules_updates = lpeg.Ct(rules_pattern * lpeg.P"\n" * updates_pattern)

local test = [[
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
]]

local match = lpeg.match(rules_updates, content)
local rules = match[1]
local updates = match[2]

local rule_set = {}
for _,r in ipairs(rules) do
  local x = r[1]
  local y = r[2]

  if rule_set[x] == nil then
    rule_set[x] = {}
  end

  rule_set[x][y] = true
end

local function page_sort(a, b)
  return rule_set[a] and rule_set[a][b]
end

local function middle_value(t)
  return t[math.floor(#t / 2) + 1]
end

local sum1 = 0
local sum2 = 0
for ux,update in ipairs(updates) do
  for i,page in ipairs(update) do
    for j = (i + 1), #update do
      local next_page = update[j]
      local invalid = rule_set[next_page] and rule_set[next_page][page]
      if invalid then
        table.sort(update, page_sort)
        sum2 = sum2 + middle_value(update)
        goto nextupdate
      end
    end
  end
  sum1 = sum1 + middle_value(update)

  ::nextupdate::
end

print(sum1)
print(sum2)
