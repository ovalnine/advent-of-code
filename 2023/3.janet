(def input (slurp "inputs/3.txt"))
(def input (string/trimr input))

(def grammar
  ~{:nothing (+ "." "\n")
    :symbol (group (* (constant :symbol) (line) (column) '1))
    :number (group (* (constant :number) (line) (column) (/ (<- :d+) ,scan-number) (column)))
    :main (some (+ :nothing :number :symbol))})

(def input (peg/match grammar input))

(def symbols (filter |(= (first $) :symbol) input))
(def numbers (filter |(= (first $) :number) input))

(defn
  adjacent-symbol?
  [[_ row col-up value col-dn]]
  (some (fn [[_ r c]] (and
                        (>= r (- row 1))
                        (<= r (+ row 1))
                        (>= c (- col-up 1))
                        (<= c col-dn))) symbols))

(var s 0)
(loop [n :in numbers]
  (if (adjacent-symbol? n)
    (+= s (n 3))))

(pp s)

# Part 2
(def engines (filter |(= "*" ($ 3)) symbols))

(defn
  adjacent-numbers
  [[_ row col _]]
  (filter
    (fn
      [[_ r cu v cd]]
      (and
        (>= r (- row 1))
        (<= r (+ row 1))
        (or
          (and
            (>= cu (- col 1))
            (<= cu (+ col 1)))
          (and
            (>= (- cd 1) (- col 1))
            (<= (- cd 1) (+ col 1)))))) numbers))

(var s 0)
(loop [e :in engines]
  (def nn (adjacent-numbers e))
  (+= s (if (= (length nn) 2) (* ;(map |($ 3) nn)) 0)))

(pp s)
