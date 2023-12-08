(def input (slurp "inputs/8.txt"))

(def grammar
  ~{:paths (group (some (+ (/ (<- "L") 0) (/ (<- "R") 1))))
    :node (* (<- :w+) " = (" (<- :w+) ", " (<- :w+) ")" :s)
    :network (/ (group (some (/ :node ,|@{$0 (tuple $1 $2)}))) ,|(merge ;$))
    :main (* :paths :s+ :network)})
    # :main (* :direction :s :network)})

(def test-input ```
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)

```)

(def [paths network] (peg/match grammar test-input))

# (var key "AAA")
# (var node (network key))
# (var c 0)
# (while (not= key "ZZZ")
#   (loop [path :in paths
#          :until (= key "ZZZ")]
#     (+= c 1)
#     (set key (node path))
#     (set node (network key))))
# (pp c)

(var key (filter |(= (last $) 65) (keys network)))
(var node (map network (filter |(= (last $) 65) (keys network))))
(var c 0)
(while (some |(not= (last $) 90) key)
  (loop [path :in paths
         :until (all |(= (last $) 90) key)]
    (+= c 1)
    (set key (map |($ path) node))
    (set node (map network key))
    (pp key)
    (pp node)))

(pp c)
# (pp key)
# (pp node)
