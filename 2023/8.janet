(def input (slurp "inputs/8.txt"))

(def grammar
  ~{:paths (group (some (+ (/ (<- "L") 0) (/ (<- "R") 1))))
    :node (* (<- :w+) " = (" (<- :w+) ", " (<- :w+) ")" :s)
    :network (/ (group (some (/ :node ,|@{$0 (tuple $1 $2)}))) ,|(merge ;$))
    :main (* :paths :s+ :network)})

(def [paths network] (peg/match grammar input))

(defn
  distance
  [start condition]
  (var key start)
  (var node (network key))
  (var c 0)
  (while (not (condition key)) 
    (loop [path :in paths
           :until (condition key)]
      (+= c 1)
      (set key (node path))
      (set node (network key))))
  c)

# Part 1

(pp (distance "AAA" (fn [x] (= x "ZZZ"))))

# Part 2

# This part is solved this way
# given the property that each
# path from intial XXA -> XXZ
# is cyclical.

(pp (->> (filter |(= (last $) 65) (keys network))
         (map |(distance $ (fn [x] (= (last x) 90))))
         (reduce math/lcm 1 )))
