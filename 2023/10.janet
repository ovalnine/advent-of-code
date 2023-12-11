(def input (slurp "inputs/10.txt"))

(def test-input ```
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...

```)

(def convert {"|" [:u :d]
      "-" [:l :r]
      "L" [:u :r]
      "J" [:u :l]
      "7" [:d :l]
      "F" [:d :r]
      "." []
      "S" @[]})

(def grammar
  ~{:tile (/ (<- (set "|-LJ7F.S")) ,convert)
    :main (some (+ (group (some :tile)) 1)) })

(def grid (peg/match grammar test-input))

(var [x y] (peg/match ~(some (+ (* (column) (line) "S") 1)) test-input))
(-= x 1)
(-= y 1)


(var s ((grid y) x))
(when (and (not= (length grid) y) (has-value? ((grid (inc y)) x) :u)) (array/push s :d))
(when (and (not= 0 y) (has-value? ((grid (dec y)) x) :d)) (array/push s :u))
(when (and (not= (length (grid 0)) x) (has-value? ((grid y) (inc x)) :l)) (array/push s :r))
(when (and (not= 0 x) (has-value? ((grid y) (dec x)) :r)) (array/push s :l))

(defn
  opposite
  [x]
  (case x
    :u :d
    :d :u
    :l :r
    :r :l))

(defn
  position
  [dir pos]
  (when (= dir :u) (-= (pos :y) 1))
  (when (= dir :d) (+= (pos :y) 1))
  (when (= dir :l) (-= (pos :x) 1))
  (when (= dir :r) (+= (pos :x) 1)))

# Needed for part 2
(def area (seq [i :in (range (length grid))]
            (array/new-filled (length (grid 0)) 0)))

(def pos @{:x x :y y})
(var dir nil)
(var steps 0)
(while true
  (def tile ((grid (pos :y)) (pos :x)))
  (set ((area (pos :y)) (pos :x)) 1)
  (set dir (find |(not= (opposite $) dir) tile))
  (position dir pos)
  (+= steps 1)
  (when (and (= (pos :x) x) (= (pos :y) y)) (break)))

# Part 1
(pp (/ steps 2))

(var f false)
(var p1 0)
(var a 0)
(var c 0)
(loop [[j row] :pairs area]
  (set f false)
  (set p1 0)
  (set a 0)
  (pp row)
  (loop [[i p0] :pairs row]
  (when
    (and (= p1 0) (= p0 1))
    (when f 
      # (pp @[j i a])
      (+= c a))
    (set f (not f)))
  (when
    (and (= p0 0) f)
    # (pp @["a" j i])
    (+= a 1))
  (set p1 p0)))

(pp c)
