(def input (slurp "inputs/7.txt"))

(def test-input ```
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483

```)

(def grammar
  ~{:cards (group (repeat 5 (<- :w)))
    :main (some (/ (* :cards :s (number :d+) :s)  ,|@{:hand $0 :bet $1 :freq (frequencies $0)}))})

(def cards (peg/match grammar input))

(def card-value
  {"A" 14
   "K" 13
   "Q" 12
   "J" 11
   "T" 10
   "9" 9
   "8" 8
   "7" 7
   "6" 6
   "5" 5
   "4" 4
   "3" 3
   "2" 2})

(defn 
  card-rank
  [{:freq a :hand ha} {:freq b :hand hb}]
  (def max-a (max ;(values a)))
  (def max-b (max ;(values b)))
  (def len-a (length a))
  (def len-b (length b))
  (or 
    (< max-a max-b)
    (and 
      (= max-a max-b)
      (or 
        (> len-a len-b)
        (and 
          (= len-a len-b)
          (= -1 (find |(not= 0 $) (map |(compare (card-value $0) (card-value $1)) ha hb))))))))

(sort cards card-rank)

(def test-card @{"2" 2 "J" 1 "3" 2 "4" 4})

(pp (sort test-card))
(pp (first test-card))

(var s 0)
(loop [[i card] :pairs cards]
  (+= s (* (card :bet) (+ i 1))))

(pp s)



