(def input (slurp "inputs/6.txt"))
(def input (string/trimr input))

(def grammar
  ~{:time (* "Time:" (group (repeat 4 (* :s+ (number :d+)))) :s*)
    :dist (* "Distance:" (group (repeat 4 (* :s+ (number :d+)))) :s*)
    :main (* :time :dist)})

(def [times distances] (peg/match grammar input))

(defn distance [hold-time duration] (* (- duration hold-time) hold-time))

(defn
  winning
  [time dist]
  (->> (range time)
       (map |(distance $ time))
       (filter |(> $ dist))
       (length)))

(defn
  array-number
  [arr]
  (->> (map string arr)
       (string/join)
       (scan-number)))

(defn zip [a b] (seq [i :keys a] @[(a i) (b i)]))

# Part 1
(pp (reduce |(* $0 (winning ;$1)) 1 (zip times distances)))

# Part 2
(pp (winning (array-number times) (array-number distances)))
