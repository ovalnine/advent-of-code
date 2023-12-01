(def input (string/trimr (slurp "inputs/2.txt")))
(def sides (string/split "\n" input))
(def sides (map (fn [a] (string/split "x" a)) sides))
(def sides (map (fn [a] (map (fn [b] (scan-number b)) a)) sides))

# Part1
(defn
  sa
  "Surface area"
  [a b c]
  (+ (* 2 a b) (* 2 a c) (* 2 b c)))

(defn
  ss
  "Smallest side"
  [a b c]
  (let
    [s (sort @[a b c])]
    (* (s 0) (s 1))))

(defn
  paper
  "Calcs the surface area of the box"
  [s]
  (+ (sa ;s) (ss ;s)))

(def output (reduce2 + (map |(paper $) sides)))

(pp output)

# Part2
(defn
  sp
  "Smallest perimeter"
  [a b c]
  (let
    [s (sort @[a b c])]
    (+ (* 2 (s 0)) (* 2 (s 1)))))

(defn
  vl
  "Volume"
  [a b c]
  (* a b c))

(defn
  ribbon
  "Calcs the ribbon length"
  [s]
  (+ (sp ;s) (vl ;s)))

(def output (reduce2 + (map |(ribbon $) sides)))

(pp output)
