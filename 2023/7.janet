(def input (slurp "inputs/7.txt"))

(def grammar
  ~{:cards (group (repeat 5 (<- :w)))
    :main (some (/ (* :cards :s (number :d+) :s)  ,|@{:hand $0 :bet $1 :freq (frequencies $0)}))})

(def cards (peg/match grammar input))

(def cv @{"A" 14 "K" 13 "Q" 12 "J" 11 "T" 10 "9" 9  "8" 8  "7" 7  "6" 6  "5" 5 "4" 4  "3" 3  "2" 2})

(defn 
  hand-rank
  [a b]
  (->> (map |(compare $0 $1) (sorted (values a) >) (sorted (values b) >))
       (find |(not= 0 $0))))

(defn
  card-rank
  [a b cv]
  (->> (map |(compare (cv $0) (cv $1)) a b)
       (find |(not= 0 $0))))

(defn
  rank
  [a b c]
  (= -1 (or (hand-rank (a :freq) (b :freq)) (card-rank (a :hand) (b :hand) c))))

(sort cards |(rank $0 $1 cv))

(pp (sum (map (fn [[i {:bet bet}]] (* (inc i) bet)) (pairs cards))))

# Part 2
(def cv @{"A" 14 "K" 13 "Q" 12 "T" 10 "9" 9  "8" 8  "7" 7  "6" 6  "5" 5 "4" 4  "3" 3  "2" 2 "J" 1})

(defn higher [x] (->> (pairs x)
                        (filter |(not= (first $) "J"))
                        (sort-by |(last $))
                        (last)))

(loop [{:freq freq} :in cards]
  (def max-p (higher freq))
  (when (and max-p (has-key? freq "J"))
    (+= (freq (first max-p)) (freq "J"))
    (put freq "J" nil)))

(sort cards |(rank $0 $1 cv))

(pp (sum (map (fn [[i {:bet bet}]] (* (inc i) bet)) (pairs cards))))
