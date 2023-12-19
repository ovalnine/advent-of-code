(def input (slurp "inputs/18.txt"))
(def input (string/trimr input))
(def input (string/split "\n" input))

(defn vector [[dir len]]
  #(def len (inc len))
  (match dir
    "U"
    {:x 0 :y (- len)}
    "L"
    {:x (- len) :y 0}
    "D"
    {:x 0 :y len}
    "R"
    {:x len :y 0}))

(defn color-vector [s]
  (string
    (match (last s) 48 "R" 49 "D" 50 "L" 51 "U")
    " "
    (scan-number (string/slice s 0 (dec (length s))) 16)))

(defn solve [plan]
  (var [x y] [0 0])
  (def coords
    (seq [{:x i :y j} :in (map vector plan)]
      @{:x (+= x i) :y (+= y j)}))
  
  (def a (array/slice coords 0 (length coords)))
  (def b @[;(array/slice coords 1 (length coords)) (coords 0)])
  
  (def p (reduce (fn [acc curr] (+ acc (curr 1))) 0 plan))
  (def s (map |(- (* ($0 :x) ($1 :y)) (* ($0 :y) ($1 :x))) a b))
  (+ (/ (+ (sum s) p) 2) 1))

(def grammar-1 ~(* (<- (set "ULDR")) 1 (number :d+)))
(def plan (map |(peg/match grammar-1 $) input))

(pp (solve plan))

# Part 2
(def grammar-2 ~(* (thru "#") (<- (to ")"))))
(def plan (map |((peg/match grammar-2 $) 0) input))
(def plan (map |(peg/match grammar-1 (color-vector $)) plan))

(pp (solve plan))

