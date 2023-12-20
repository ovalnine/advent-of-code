(def input (slurp "inputs/19.txt"))
(def [workflows parts] (string/split "\n\n" input))
(def workflows (string workflows "\n"))

(def workflow-grammar
  ~{:cond (/ (* (<- :a) (<- (+ "<" ">")) (number :d+)) ,|{:k $0 :op (symbol $1) :v $2})
    :expr (<- :a+)
    :pairs (/ (* :cond ":" :expr 1) ,|[:pair [$0 $1]])
    :rules (group (* (some :pairs) (/ :expr ,|[:default $]) 1))
    :workflow (/ (* (<- (to "{")) 1 :rules) ,|{$0 $1})
    :main (some (* :workflow 1))})

(def part-grammar
  ~{:parts (/ (some (* (<- (set "xmas")) "=" (number :d+) 1)) ,table)
    :main (some (* 1 :parts 1))})

(def workflows (merge ;(peg/match workflow-grammar workflows)))
(def parts (peg/match part-grammar parts))

(defn solve-1 [key tab]
  (match key
    "A" (break tab)
    "R" (break))
  (prompt
    :ret
    (loop
      [w :in (workflows key)]
      (match w
        [:pair [{:k k :op op :v v} exp]]
        (when ((eval op) (tab k) v)
          (return :ret (solve-1 exp tab)))
        [:default d]
        (return :ret (solve-1 d tab))))))

(defn solve-2 [key rng]
  (match key
    "A" (break rng)
    "R" (break))

  (def rng (table/clone rng))
  (catseq
    [w :in (workflows key)]
    (prompt
      :ret
      (match w
        [:pair [{:k k :op op :v v} exp]]
        (do
          (def [start end] (rng k))
          (match [((eval op) start v) ((eval op) end v)]
            [true true]
            (return :ret (solve-2 exp rng))
            [true false]
            (do
              (def result (solve-2 exp (merge rng {k [start (dec v)]})))
              (set (rng k) [v end])
              result)
            [false true]
            (do
              (def result (solve-2 exp (merge rng {k [(inc v) end]})))
              (set (rng k) [start v])
              result)))
        [:default d]
        (solve-2 d rng)))))

# Part 1
(pp (sum (map |(sum $) (values (filter truthy? (map |(solve-1 "in" $) parts))))))

# Part 2
(def solution (filter truthy? (solve-2 "in" @{"x" [1 4000] "m" [1 4000] "a" [1 4000] "s" [1 4000]})))
(pp (sum (map (fn [s] (* ;(map |(inc (- ;(reverse $))) (values s)))) solution)))

