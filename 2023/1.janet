(def input (slurp "inputs/1.txt"))
(def input (string/trimr input))
(def input (string/split "\n" input))

(defn kv-finder
  "Creates a PEG that returns the value for the matched key and all matched indexes"
  [k v]
  ~(any (+ (group (* ($) (/ ,k ,v))) 1)))

(defn table-finder
  [t]
  "Returns the key-value-index-finder results for all the key-value pairs"
  (fn 
    [x]
    (array/concat 
      ;(map (fn 
              [[k v]]
              (peg/match (kv-finder k v) x)) (pairs t)))))

(def digits {"1" 1
             "2" 2
             "3" 3
             "4" 4
             "5" 5
             "6" 6
             "7" 7
             "8" 8
             "9" 9})
# Part 2
(def words {"one" 1
            "two" 2
            "three" 3
            "four" 4
            "five" 5
            "six" 6
            "seven" 7
            "eight" 8
            "nine" 9})

(def t (merge digits words))

# Use *digits* instead of *t* for Part 1
(def output (map (table-finder t) input))

(var s 0)
(loop [o :in output]
  (sort o (fn [a b] (< (a 0) (b 0))))
  (+= s (+ (* ((first o) 1) 10) ((last o) 1))))

(pp s)

