(def input (slurp "inputs/19.txt"))
(def [workflows parts] (string/split "\n\n" input))
(def workflows (string workflows "\n"))

# (def test-input ```
# px{a<2006:qkq,m>2090:A,rfg}
# pv{a>1716:R,A}
# lnx{m>1548:A,A}
# rfg{s<537:gd,x>2440:R,A}
# qs{s>3448:A,lnx}
# qkq{x<1416:A,crn}
# crn{x>2662:A,R}
# in{s<1351:px,qqz}
# qqz{s>2770:qs,m<1801:hdj,R}
# gd{a>3333:R,R}
# hdj{m>838:A,pv}
# 
# {x=787,m=2655,a=1222,s=2876}
# {x=1679,m=44,a=2067,s=496}
# {x=2036,m=264,a=79,s=2244}
# {x=2461,m=1339,a=466,s=291}
# {x=2127,m=1623,a=2188,s=1013}
# 
# ```)
# (def [workflows parts] (string/split "\n\n" test-input))
# (def workflows (string workflows "\n"))

(def workflow-grammar
  ~{:cond (/ (* (<- :a) (<- (+ "<" ">")) (number :d+) ":" (<- :a+)) ,|{:key $0 :comp $1 :value $2 :match $3})
    :rules (group (some (* (+ :cond (<- :a+)) 1)))
    :workflow (/ (* (<- (to "{")) 1 :rules) ,|[(symbol "sym" $0) $1])
    :main (some (* :workflow 1))})

(def workflows (peg/match workflow-grammar workflows))

(def part-grammar
  ~{:parts (/ (some (* (<- (set "xmas")) "=" (number :d+) 1)) ,table)
    :main (some (* 1 :parts 1))})

(def parts (peg/match part-grammar parts))

(defn cond-body [x]
  (match x 
    "R" nil 
    "A" ~(break part)
    ~((eval (symbol "sym" ,x)) part)))

(defn conditions [body]
  (array/concat
    ;(map
       (fn [x] @[~(,(symbol (x :comp)) (part ,(x :key)) ,(x :value)) (cond-body (x :match))])
       (array/slice body 0 -2))
    @[(cond-body (last body))]))

(defn workflow [name body]
  (eval
    ~(defn ,name [part]
       (cond ,;(conditions body)))))

(loop [[name body] :in workflows]
  (workflow name body))

(pp (sum (seq [p :in parts] (if (symin p) (sum (values p)) 0))))
