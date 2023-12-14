(def input (slurp "inputs/13.txt"))

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

# Part 2

(defn
  compare-count
  [x y]
  (count |(not= $0 $1) x y))

(defn
  smudged-reflections
  [v]
  (filter
    truthy?
    (seq [i :range [0 (dec (length v))]
          :let [a (v i)
                b (v (inc i))]]
      (when (< (compare-count a b) 2) i))))

(defn
  smudged-mirror
  [index valley]
  (var result false)
  (loop [offset :range [0 (inc index)]]
    (if-let [a (get valley (- index offset))
             b (get valley (+ (inc index) offset))
             cc (compare-count a b)]
      (cond
        (= cc 1) (set result true)
        (> cc 1) (break (set result false)))
      (break)))
  result)

(def mirrors
  (seq [rows :in valleys
        :let [cols (columns rows)]]
    (def cols-mirror (find |(smudged-mirror $ cols) (smudged-reflections cols)))
    (def rows-mirror (find |(smudged-mirror $ rows) (smudged-reflections rows)))
    (if cols-mirror (inc cols-mirror) (* 100 (inc rows-mirror)))))

(pp (sum mirrors))
