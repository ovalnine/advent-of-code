(def input (slurp "inputs/9.txt"))

(def grammar ~(some (+ (group (some (+ (/ (<- (* (at-most 1 "-") :d+)) ,scan-number) " "))) 1)))

(def history (peg/match grammar input))

(defn
  steps
  [a]
  (seq [i :range [1 (length a)] :let [j (dec i)]] (- (a i) (a j))))

(defn
  stepper
  [a]
  (def output @[@[;a]])
  (while true
    (array/push output (steps (last output)))
    (when (= (sum (last output)) 0) (break)))
  output)

(defn
  for-prediction
  [a]
  (reduce (fn [acc curr] (+ (last curr) acc)) 0 (reverse (stepper a))))

(defn
  back-prediction
  [a]
  (reduce (fn [acc curr] (- (first curr) acc)) 0 (reverse (stepper a))))

# Part 1
(pp (sum (map for-prediction history)))

# Part 2
(pp (sum (map back-prediction history)))


