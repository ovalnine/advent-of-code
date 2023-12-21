(def input (slurp "inputs/21.txt"))

(def test-input ```
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........

```)

(def garden (peg/match ~(some (* (group (some (<- (set ".#S")))) "\n")) input))

(defn array/unshift [arr]
  (def [sig] (array/slice arr 0 1))
  (array/remove arr 0)
  sig)

(defn get2 [mat {:x x :y y}]
  (def rows (length mat))
  (def cols (length (mat 0)))
  (var y (% y rows))
  (var x (% x cols))
  (when (neg? y) (+= y rows))
  (when (neg? x) (+= x cols))
  (get (get mat y) x))

(defn even-parity [{:x x :y y}]
  (or (and (even? x) (even? y)) (and (odd? x) (odd? y))))

(defn odd-parity [{:x x :y y}]
  (or (and (odd? x) (even? y)) (and (even? x) (odd? y))))

(defn solve [garden start limit]
  (def visited @{start true})
  (def queue @[[start 0]])
  (while (> (length queue) 0)
    (prompt :ret
      (def [pos level] (array/unshift queue))
  
      (when (= level limit)
        (return :ret))
  
      (def npos {:x (pos :x) :y (dec (pos :y))})
      (def spos {:x (pos :x) :y (inc (pos :y))})
      (def wpos {:x (dec (pos :x)) :y (pos :y)})
      (def epos {:x (inc (pos :x)) :y (pos :y)})
      (def [n s w e] (map |(get2 garden $) [npos spos wpos epos]))
      (when (and (or (= n ".") (= n "S")) (not (has-key? visited npos)))
        (set (visited npos) true)
        (array/push queue [npos (inc level)]))
      (when (and (or (= s ".") (= s "S")) (not (has-key? visited spos)))
        (set (visited spos) true)
        (array/push queue [spos (inc level)]))
      (when (and (or (= w ".") (= w "S")) (not (has-key? visited wpos)))
        (set (visited wpos) true)
        (array/push queue [wpos (inc level)]))
      (when (and (or (= e ".") (= e "S")) (not (has-key? visited epos)))
        (set (visited epos) true)
        (array/push queue [epos (inc level)]))))
  (if (odd? limit)
    (length (filter odd-parity (keys visited)))
    (length (filter even-parity (keys visited)))))

(def start (map dec (peg/match ~(some (+ (* (column) (line) "S") 1)) input)))
(def start {:x (first start) :y (last start)})

# Part 1
(pp (solve garden start 64))

# Part 2
(def center (start :x))
(pp "Use these parameters to interpolate with wolfram at {0,P0 1,P1 2,P2} and solve for x=202300")
(pp "(The value 202300 comes from 26501365 = 65 + 202300 * 131)")
(pp ["P0" (solve garden start (+ center (* 0 (length garden))))
     "P1" (solve garden start (+ center (* 1 (length garden))))
     "P2" (solve garden start (+ center (* 2 (length garden))))])
