(def input (slurp "inputs/13.txt"))

(def test-input ```
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#

```)

(def grammar ~(some (+ (group (some (* (<- (if-not "\n" (to "\n"))) 1))) 1)))

(def valleys (peg/match grammar input))

(defn
  columns
  [rows]
  (map |(string/from-bytes ;$&) ;rows))

(defn
  reflections
  [v]
  (filter
    truthy?
    (seq [i :range [0 (dec (length v))]
          :let [a (v i)
                b (v (inc i))]]
      (when (= a b) i))))

(defn
  mirror
  [index valley]
  (var result true)
  (loop [offset :range [0 (inc index)]]
    (if-let [a (get valley (- index offset))
             b (get valley (+ (inc index) offset))]
      (when (not= a b) (break (set result false)))
      (break (set result true))))
  result)

(def mirrors
  (seq [rows :in valleys
        :let [cols (columns rows)]]
    (def cols-mirror (find |(mirror $ cols) (reflections cols)))
    (def rows-mirror (find |(mirror $ rows) (reflections rows)))
    (if cols-mirror (inc cols-mirror) (* 100 (inc rows-mirror)))))

(pp (sum mirrors))
