(def input (slurp "inputs/11.txt"))

(def universe-grammar ~(some (+ (group (some (+ (<- ".") (<- "#")))) 1)))

(def test-input ```
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
```)

(def universe (peg/match universe-grammar input))

(def rows (filter truthy? (seq [[i row] :pairs universe] (when (all |(= "." $) row) i))))

(var cols (range (length (universe 0))))

(loop [row :in universe]
  (loop [[i u] :pairs row]
    (when (not= u ".") (set cols (filter |(not= $ i) cols)))))

(def expanded (seq [row :in universe]
                (string/join (catseq [[i u] :pairs row]
                        (if (has-value? cols i) (string u ".") u)))))

(def expanded (string/join (catseq [[j row] :pairs expanded]
                      (if (has-value? rows j) @[row row] @[row])) "\n"))

(def expanded-grammar ~(some (+ (group (* (line) (column) "#")) 1)))

(def galaxies (peg/match expanded-grammar expanded))

(def distances (seq [i :keys galaxies]
                 (def [x y] (galaxies i))
                 (map (fn [[xx yy]] (+ (math/abs (- xx x)) (math/abs (- yy y)))) (array/slice galaxies (inc i)))))

(pp (reduce (fn [acc curr] (+ acc (sum curr))) 0 distances))
