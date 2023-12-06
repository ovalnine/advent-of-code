(def input (slurp "inputs/5.txt"))
(def input (string/trimr input))

(def grammar
  ~{:maps (some (* :map (any "\n")))
    :mapping (/ (* (number :d+) :s+ (number :d+) :s+ (number :d+)) ,|{:dest $0 :src $1 :len $2})
    :map (* (thru "map:\n") (group (some (* :mapping "\n"))) :s*)
    # Part 1
    :seeds-1 (* "seeds: " (group (some (/ (* (number :d+) (constant 1) :s*) ,|{:start $0 :length $1}))))
    # Part 2
    :seeds-2 (* "seeds: " (group (some (/ (* (number :d+) :s+ (number :d+) :s*) ,|{:start $0 :length $1}))))
    :main (/ (* :seeds-1 :maps) ,|{:seeds $0 :maps $&})
    })


(def {:seeds seeds :maps maps} ((peg/match grammar input) 0))

# Sort map ranges by source
(each m maps (sort-by |($ :src) m))

(defn in-range [v r] (and (>= v 0) (< v r)))

(defn
  transform
  [input mappings]
  (catseq [{:start start :length seed-len} :in input]
          (var start start)
          (var seed-len seed-len)
          (def mapped
            (seq [{:dest dest :src src :len map-len} :in mappings
                  :let [delta (- start src)]
                  :when (in-range delta map-len)]
              (def len (min (- map-len delta) seed-len))
              (+= start len)
              (-= seed-len len)
              @{:start (+ dest delta) :length len}))
          (when (empty? mapped) (array/push mapped @{:start start :length seed-len}))
          mapped))

(pp (min ;(map |($ :start) (reduce transform seeds maps))))
