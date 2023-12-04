(def input (slurp "inputs/4.txt"))
(def input (string/trimr input))
(def input (string/split "\n" input))

(def card-grammar
  ~{:number (* (some " ") (cmt (<- :d+) ,scan-number))
    :card-no (* "Card" :number ":")
    :winning-numbers (repeat 10 :number)
    :scratch-numbers (repeat 25 :number)
    :main (* :card-no (group :winning-numbers) " |" (group :scratch-numbers))})

(var s 0)
(loop [line :in input]
  (def [no ww ss] (peg/match card-grammar line))
  (def c (count |(has-value? ss $) ww))
  (+= s (if (not (zero? c)) (blshift 1 (- c 1)) 0)))
(pp s)

# Part 2
(def cards (array/new-filled (length input) 0))
(loop [[i l] :pairs (reverse input)]
  (def [no ww ss] (peg/match card-grammar l))
  (def c (count |(has-value? ss $) ww))
  (put cards i (+ 1 ;(array/slice cards (- i c) i))))

(pp (+ ;cards))
