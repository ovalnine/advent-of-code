(def input (slurp "inputs/11.txt"))

(def universe (peg/match ~(some (+ (group (some (+ (<- ".") (<- "#")))) 1)) input))

(def rows (filter truthy? (seq [[i row] :pairs universe] (when (all |(= "." $) row) i))))

(var cols (range (length (universe 0))))
(loop [row :in universe]
  (loop [[i u] :pairs row]
    (when (not= u ".") (set cols (filter |(not= $ i) cols)))))

(def galaxies (peg/match ~(some (+ (group (* (column) (line)"#")) 1)) input))

# Part 1
(def expand (- 2 1))
# Part 2
(def expand (- 1000000 1))

(defn
  expand-galaxy
  [[x y]]
  @[(+ x (* expand (count |(< (inc $) x) cols)))
    (+ y (* expand (count |(< (inc $) y) rows)))])

(def expanded-galaxies (map expand-galaxy galaxies))

(def distances (seq [[i [x y]] :pairs expanded-galaxies]
                 (map
                   (fn [[xx yy]] (+ (math/abs (- xx x)) (math/abs (- yy y))))
                   (array/slice expanded-galaxies (inc i)))))

(pp (reduce (fn [acc curr] (+ acc (sum curr))) 0 distances))
