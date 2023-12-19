(def input (slurp "inputs/17.txt"))

(def blocks (peg/match ~(some (+ (group (some (number :d))) 1)) input))

# Naive priority-queue
(defn heapq/bsearch-index [q e]
  (var left 0)
  (var right (length q))

  (while (< left right)
    (var middle (math/floor (/ (+ left right) 2)))
    (if (< ((q middle) :p)  (e :p))
      (set left (inc middle))
      (set right middle)))
  left)

# :p stands for priority
(defn heapq/push [q e] 
  (if-let [i (heapq/bsearch-index q e)]
    (array/insert q i e)
    (array/push q e)))

(defn heapq/pop [q]
  (def result (first q))
  (array/remove q 0)
  result)

(def cols (length (blocks 0)))
(def rows (length blocks))
(def ex (dec cols))
(def ey (dec rows))

# Part 1
(def minl 1)
(def maxl 4)
# Part 2
(def minl 4)
(def maxl 11)
(var queue @[{:x 0 :y 0 :i 1 :j 0 :p 0} {:x 0 :y 0 :i 0 :j 1 :p 0}])
(var memo @{})

# Dijkstra's algorithm + adding all consecutive/straight-line nodes to the queue
(forever
  (prompt :loop
    (def {:x x :y y :i i :j j :p heat} (heapq/pop queue))

    (when (and (= x ex) (= y ey))
      (pp heat)
      (break :loop))
    (when (get memo [x y i j]) (return :loop))
    (set (memo [x y i j]) heat)

    (loop [k :range [minl maxl]]
      (match [i j]
        [1 0]
        (do
          (when (get (get blocks (+ y k)) x)
            (heapq/push queue {:x x :y (+ y k) :i 0 :j 1 :p (+ heat ;(map |((blocks (+ y $)) x) (range 1 (inc k))))}))
          (when (get (get blocks (- y k)) x)
            (heapq/push queue {:x x :y (- y k) :i 0 :j 1 :p (+ heat ;(map |((blocks (- y $)) x) (range 1 (inc k))))})))
        [0 1]
        (do
          (when (get (get blocks y) (+ x k))
            (heapq/push queue {:x (+ x k) :y y :i 1 :j 0 :p (+ heat ;(map |((blocks y) (+ x $)) (range 1 (inc k))))}))
          (when (get (get blocks y) (- x k))
            (heapq/push queue {:x (- x k) :y y :i 1 :j 0 :p (+ heat ;(map |((blocks y) (- x $)) (range 1 (inc k))))})))))

    (return :loop)))
