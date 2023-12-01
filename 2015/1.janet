(def input (slurp "inputs/1.txt"))

(defn updown "Maps parantheses to 1 or -1" [c] (if (= c 40) 1 -1))

# Part1
(def output (reduce2 + (map updown input)))
(print output)

# Part2
(var c 0)
(var a 0)
(loop [x :in input :until (= a -1)]
  (set a (+ a (updown x)))
  (set c (inc c)))
(print c)
