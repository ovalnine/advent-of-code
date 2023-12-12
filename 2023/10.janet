(def input (slurp "inputs/10.txt"))

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

(def grid (peg/match grammar input))

(var [x y] (peg/match ~(some (+ (* (column) (line) "S") 1)) input))
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

# Part 2
(defn
  vertical?
  [pipe]
  (and (has-value? pipe :u) (has-value? pipe :d)))

(defn
  horizontal?
  [pipe]
  (and (has-value? pipe :r) (has-value? pipe :l)))

(defn
  flow
  [pipe]
  (find |(or (= $ :d) (= $ :u)) pipe))

(var f false)
(var fl nil)
(var a 0)
(loop [[j row] :pairs area]
  (set f false)
  (set fl nil)
  (loop [[i l] :pairs row]
    (when (= l 1)
      (if fl
        (when (not (horizontal? ((grid j) i)))
          (when (not= fl (flow ((grid j) i)))
            (set f (not f)))
          (set fl nil))
        (if (vertical? ((grid j) i))
          (set f (not f))
          (set fl (flow ((grid j) i))))))
    (when (and f (= l 0)) (+= a 1))))

(pp a)
