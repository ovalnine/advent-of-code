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
# The map has 2 special properties
# - Starts at the center
# - Grows in a diamond-shape
# This means that the growth is quadratic as the area of the squared-diamond grows
# The requested number of steps is a multiple of 131(length of a side of the map)
# plus an offset of 65(distance from the center/start of the map to one of the sides)
# If we can interpolate out the curve by f(65 + x * 131) in x=[0,1,2]
# then we can find f(...) where x = 202300

(defn lagrange-interpolation "Lagrange Interpolation for x [0 1 2]" [a b c]
  [(+ (/ a 2) (- b) (/ c 2))
   (+ (* -3 (/ a 2)) (* 2 b) (- (/ c 2)))
   a])

(def center (start :x))
(def x (/ (- 26501365 center) 131))
(def param (map |(solve garden start (+ center (* $ (length garden)))) (range 0 3)))
(def [a b c] (lagrange-interpolation ;param))
(pp (+ (* a x x) (* b x) c))
