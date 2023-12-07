(def input (slurp "inputs/6.txt"))
(def input (string/trimr input))

(def grammar
  ~{:time (* "Time:" (group (repeat 4 (* :s+ (<- :d+)))) :s*)
    :dist (* "Distance:" (group (repeat 4 (* :s+ (<- :d+)))) :s*)
    :main (* :time :dist)})

(def [times distances] (peg/match grammar input))

# Part 1

(defn
  distance
  [hold-time duration]
  (* (- duration hold-time) hold-time))

(defn
  winning
  [time dist]
  (->> (range time)
       (map |(distance $ time))
       (filter |(> $ dist))
       (length)))

(pp (->> (map |@[(scan-number $0) (scan-number $1)] times distances)
         (reduce |(* $0 (winning ;$1)) 1)))

# Part 2

(defn
  quadratic-solver
  (a b c)
  (def root (math/sqrt (+ (* b b) (- (* 4 a c)))))
  (def two-a (* 2 a))
  (def lo (/ (+ (- b) root) two-a))
  (def hi (/ (- (- b) root) two-a))
  [lo hi])

(def a -1)
(def b (scan-number (string/join times)))
(def c (scan-number (string/join distances)))

(def [lo hi] (quadratic-solver a b (- c)))

(pp (math/ceil (- hi lo)))

