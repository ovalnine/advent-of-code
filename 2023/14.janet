(def input (slurp "inputs/14.txt"))

(def test-input ```
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....

```)

(def dish (peg/match ~(some (group (* (some (<- (if-not "\n" 1))) "\n"))) input))

(defn matrix/transpose [rows] (map |(identity $&) ;rows))

(defn
  memo-tilt
  []
  (def memo @{})
  (fn
    [row r]
    (def k [row r])
    (when-let [result (in memo k)]
      (break result))

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
    (set (memo k) (reverse (array/push result ;balls)))))

(def tilt (memo-tilt))

(var tilted-dish (->> (matrix/transpose dish)
               (map |(tilt $ true))
               (matrix/transpose)))

(defn
  load
  [dish]
  (def l (length dish))
  (->> (pairs dish)
       (map (fn [[i row]] (* (- l i) (count |(= $ "O") row))))
       (sum)))

(pp (load tilted-dish))

# Part 2

(defn
  memo-cycle
  []
  (def memo @{})
  (fn
  [dish]
  (when-let [x (in memo dish)]
    (break x))
  (set (memo dish) (->>
    (matrix/transpose dish)
    (map |(tilt $ true))
    (matrix/transpose)
    (map |(tilt $ true))
    (matrix/transpose)
    (map |(tilt $ false))
    (matrix/transpose)
    (map |(tilt $ false))))))

(def cycle (memo-cycle))

(var cycled-dish dish)
(loop [i :range [0 10000]]
  (set cycled-dish (cycle cycled-dish))
  (pp (load cycled-dish)))
