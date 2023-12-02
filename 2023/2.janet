(def input (slurp "inputs/2.txt"))
(def input (string/trimr input))
(def input (string/split "\n" input))

(def constraint {:r 12 :g 13 :b 14})

(def game-grammar
  ~{:to-number (/ (<- :d*) ,scan-number)
    :game-no (* "Game " :to-number ":")
    :round-end (any (+ "," ";"))
    :rd (group (* " " :to-number (/ " red" :r) :round-end))
    :gn (group (* " " :to-number (/ " green" :g) :round-end))
    :bl (group (* " " :to-number (/ " blue" :b) :round-end))
    :rounds (some (+ :rd :gn :bl))
    :game (* :game-no (group :rounds))
    :main :game})

(defn check-constraint [c v]
  (and 
    (<= (v :r) (c :r))
    (<= (v :g) (c :g))
    (<= (v :b) (c :b))))

(defn
  put-max
  [t [v k]]
  (put t k (max (t k) v)))

(var s1 0)
(var s2 0)
(loop [game :in input]
  (def [no rounds] (peg/match game-grammar game))
  (def minimum (reduce put-max @{:r 0 :g 0 :b 0} rounds))
  (def power (* (minimum :r) (minimum :g) (minimum :b)))
  (+= s1 (if (check-constraint constraint minimum) no 0))
  (+= s2 power))

(pp s1)
(pp s2)
