(def input (slurp "inputs/5.txt"))
(def input (string/trimr input))

(def grammar
  ~{:number (/ (<- :d+) ,scan-number)
    :seeds (group (* "seeds:" (repeat 20 (* " " :number)) :empty))
    :maps (some (group (* :number " " :number " " :number "\n")))
    :empty (* "\n\n")
    :soil-map (group (* "seed-to-soil map:\n" :maps 1))
    :fert-map (group (* "soil-to-fertilizer map:\n" :maps 1))
    :watr-map (group (* "fertilizer-to-water map:\n" :maps 1))
    :ligt-map (group (* "water-to-light map:\n" :maps 1))
    :temp-map (group (* "light-to-temperature map:\n" :maps 1))
    :humi-map (group (* "temperature-to-humidity map:\n" :maps 1))
    :loct-map (group (* "humidity-to-location map:\n" :maps 1))
    :main (* :seeds (* :soil-map :fert-map :watr-map :ligt-map :temp-map :humi-map :loct-map 1))})

(def input (peg/match grammar input))

(defn
  convert
  [x tab]
  (def m (find (fn [[dest src rng]] (and (>= x src) (< x (+ src rng)))) tab))
  (if m (+ (- x (m 1)) (m 0)) x))

(defn
  convert-all
  [x tabs]
  (reduce (fn [y tab] (convert y tab)) x tabs))

(pp (min ;(map |(convert-all $ (array/slice input 1 -1)) (input 0))))
