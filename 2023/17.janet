(def input (slurp "inputs/17.txt"))

(def test-input ```
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533

```)

(def blocks (peg/match ~(some (+ (group (some (number :d))) 1)) test-input))

(def cols (length (blocks 0)))
(def rows (length blocks))
(def end @{:x (dec cols) :y (dec rows)})

(defn path [{:x x :y y} visited {:x cx :y cy} memo]
  (def heat-loss (get (get blocks y) x))
  (unless heat-loss
    (break math/inf))
  (when (has-key? visited [x y])
    (break math/inf))
  (when (or (> cx 3) (> cy 3) (< cx -3) (< cy -3))
    (break math/inf))
  (when (and (= x (end :x)) (= y (end :y)))
    (break heat-loss))

  (when-let [min-heat-loss (get memo [x y cx cy])]
    (break (+ heat-loss min-heat-loss)))

  (def visited (merge visited {[x y] true}))
  (def min-heat-loss
    (min (path {:x (inc x) :y y} visited {:x (if (pos? cx) (inc cx) 1) :y 0} memo)
         (path {:x (dec x) :y y} visited {:x (if (neg? cx) (dec cx) -1) :y 0} memo)
         (path {:x x :y (inc y)} visited {:x 0 :y (if (pos? cy) (inc cy) 1)} memo)
         (path {:x x :y (dec y)} visited {:x 0 :y (if (neg? cy) (dec cy) -1)} memo)))
  (set (memo [x y cx cy]) min-heat-loss)
  (+ heat-loss min-heat-loss))

(def start @{:x 0 :y 0})
(def memo @{})
(pp (path start @{} @{:x 0 :y 0} memo))
