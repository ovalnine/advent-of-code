(def input (slurp "inputs/16.txt"))

(def grid (peg/match ~(some (+ (group (some (<- (set ".|-/\\")))) 1)) input))

(defn ray [pos delta memo]
  (def mirror (get (get grid (pos :y)) (pos :x)))
  (unless mirror (break))

  # hit mirror from same direction
  (def k [(pos :x) (pos :y) (delta :x) (delta :y)])
  (if-let [m (get memo k)] (break) (set (memo k) true))

  (match mirror
    "."
    (ray @{:x (+ (pos :x) (delta :x))  :y (+ (pos :y) (delta :y))} @{:x (delta :x) :y (delta :y)} memo)
    "|"
    (match delta 
      {:x _ :y 0}
      (do
         (ray @{:x (pos :x) :y (+ (pos :y) (delta :x))} @{:x (delta :y) :y (delta :x)} memo)
         (ray @{:x (pos :x) :y (- (pos :y) (delta :x))} @{:x (delta :y) :y (- (delta :x))} memo))
      {:x 0 :y _}
      (ray @{:x (+ (pos :x) (delta :x))  :y (+ (pos :y) (delta :y))} @{:x (delta :x) :y (delta :y)} memo))
    "-"
    (match delta
      {:x 0 :y _}
      (do
         (ray @{:x (+ (pos :x) (delta :y)) :y (pos :y)} @{:x (delta :y) :y (delta :x)} memo)
         (ray @{:x (- (pos :x) (delta :y)) :y (pos :y)} @{:x (- (delta :y)) :y (delta :x)} memo))
      {:x _ :y 0}
      (ray @{:x (+ (pos :x) (delta :x))  :y (+ (pos :y) (delta :y))} @{:x (delta :x) :y (delta :y)} memo))
    "/"
    (match delta
      {:x _ :y 0}
      (ray @{:x (pos :x) :y (- (pos :y) (delta :x))} @{:x (delta :y) :y (- (delta :x))} memo)
      {:x 0 :y _}
      (ray @{:x (- (pos :x) (delta :y)) :y (pos :y)} @{:x (- (delta :y)) :y (delta :x)} memo))
    "\\"
    (match delta
      {:x _ :y 0}
      (ray @{:x (pos :x) :y (+ (pos :y) (delta :x))} @{:x (delta :y) :y (delta :x)} memo)
      {:x 0 :y _}
      (ray @{:x (+ (pos :x) (delta :y)) :y (pos :y)} @{:x (delta :y) :y (delta :x)} memo))))

(def config @{:pos @{:x 0 :y 0} :delta @{:x 1 :y 0} :memo @{}})
(ray (config :pos) (config :delta) (config :memo))
(pp (length (distinct (map |[($ 0) ($ 1)] (keys (config :memo))))))

# Part 2

(def rows (length grid))
(def cols (length (grid 0)))
(def config
  (array/concat
    (seq [j :range [0 rows]] @{:pos @{:x 0 :y j} :delta @{:x 1 :y 0} :memo @{}})
    (seq [j :range [0 rows]] @{:pos @{:x (dec cols) :y j} :delta @{:x -1 :y 0} :memo @{}})
    (seq [i :range [0 cols]] @{:pos @{:x i :y 0} :delta @{:x 0 :y 1} :memo @{}})
    (seq [i :range [0 cols]] @{:pos @{:x i :y (dec rows)} :delta @{:x 0 :y -1} :memo @{}})))

(def energies (seq [c :in config]
                (ray (c :pos) (c :delta) (c :memo))
                (length (distinct (map |[($ 0) ($ 1)] (keys (c :memo)))))))

(pp (max ;energies))
