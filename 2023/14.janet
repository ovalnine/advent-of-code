(def input (slurp "inputs/14.txt"))

(def dish (peg/match ~(some (group (* (some (<- (if-not "\n" 1))) "\n"))) input))

(defn matrix/transpose [rows] (map |(identity $&) ;rows))

(defn
  tilt
  [row r]
    (def result @[])
    (def balls @[])
    (def row (if r (reverse row) row))
    (loop [a :in row]
      (when (= a "#")
        (array/push result ;balls)
        (array/clear balls))
      (if (= a "O")
        (array/push balls "O")
        (array/push result a)))
    (def result (array/push result ;balls))
    (if r (reverse result) result))

(defn
  load
  [dish]
  (def l (length dish))
  (->> (pairs dish)
       (map (fn [[i row]] (* (- l i) (count |(= $ "O") row))))
       (sum)))

(var tilted-dish (->> (matrix/transpose dish)
               (map |(tilt $ true))
               (matrix/transpose)))

(pp (load tilted-dish))

# Part 2
(defn
  cycle
  [dish]
  (->>
    (matrix/transpose dish)
    (map |(tilt $ true))
    (matrix/transpose)
    (map |(tilt $ true))
    (matrix/transpose)
    (map |(tilt $ false))
    (matrix/transpose)
    (map |(tilt $ false))))


(var cycled-dish dish)
(def memo @{})
(def loads @[])
(var offset 0)
(var c 0)
(forever
  (set cycled-dish (cycle cycled-dish))
  (array/push loads (load cycled-dish))
  (def k (tuple ;(flatten cycled-dish)))
  (when-let [x (in memo k)]
    (set offset (dec x))
    (break))
  (set (memo k) (++ c)))

(def wave (% (- 1000000000 offset) (- c offset)))
(pp (loads (dec (+ offset wave))))
