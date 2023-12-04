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
  (def card (peg/match card-grammar line))

  (var shift -1)
  (loop [no :in (card 1)]
    (if (has-value? (card 2) no) (+= shift 1)))
  (def pts (if (not= shift -1) (blshift 1 shift) 0))
  (+= s pts))
(pp s)

# Part 2
(def c (array/new-filled (length input) 0))
(loop [[i line] :pairs (reverse input)]
  (var wins 0)
  (def card (peg/match card-grammar line))
  (each no (card 1) (if (has-value? (card 2) no) (+= wins 1)))
  (var total 1)
  (loop [j :range [1 (inc wins)]]
    (+= total (c (- i j))))
  (put c i total))

(pp (+ ;c))
