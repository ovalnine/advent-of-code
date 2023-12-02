(def input (slurp "inputs/2.txt"))
(def input (string/trimr input))
(def input (string/split "\n" input))

(def constraint {"r" 12 "g" 13 "b" 14})

(def game
  ~{:game-no (* "Game " (<- :d*) ":")
    :red (group (* " " (<- :d*) (* (/ " red" "r") (any (+ "," ";")))))
    :green (group (* " " (<- :d*) (* (/ " green" "g") (any (+ "," ";")))))
    :blue (group (* " " (<- :d*) (* (/ " blue" "b") (any (+ "," ";")))))
    :round (some (+ :red :green :blue))
    :game (* :game-no (group (some (+ :round))))
    :main :game})

(var s1 0)
(var s2 0)
(loop [g :in input]
  (def state (peg/match game g))
  (def game-no (scan-number (first state)))
  (def rounds (last state))
  (def result (reduce
                (fn [acc el]
                  (def k (last el))
                  (def v (scan-number (first el)))
                  (set (acc k) (max (acc k) v))
                  acc)
                @{"r" 0 "g" 0 "b" 0} rounds))
  (def power (* (result "r") (result "g") (result "b")))
  (+= s2 power)
  (+= s1 (if (and 
             (<= (result "r") (constraint "r"))
             (<= (result "g") (constraint "g"))
             (<= (result "b") (constraint "b")))
         game-no
         0)))

(pp s1)
(pp s2)
