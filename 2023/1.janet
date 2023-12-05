(def input (slurp "inputs/1.txt"))
(def input (string/trimr input))
(def input (string/split "\n" input))

(def grammar
  ~{:1 (/ (if "one" 1) 1)
    :2 (/ (if "two" 1) 2)
    :3 (/ (if "three" 1) 3)
    :4 (/ (if "four" 1) 4)
    :5 (/ (if "five" 1) 5)
    :6 (/ (if "six" 1) 6)
    :7 (/ (if "seven" 1) 7)
    :8 (/ (if "eight" 1) 8)
    :9 (/ (if "nine" 1) 9)
    :digits (/ (<- :d) ,scan-number)
    :words (+ :1 :2 :3 :4 :5 :6 :7 :8 :9)
    :part-1 (+ :digits 1) 
    :part-2 (+ :digits :words 1) 
    :main (some :part-2)})

(var s 0)
(loop [i :in input]
  (var digits (peg/match grammar i))
  (+= s (* 10 (first digits)) (last digits)))

(pp s)
