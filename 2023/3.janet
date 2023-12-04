(def input (slurp "inputs/3.txt"))
(def input (string/trimr input))
(def input (string/split "\n" input))

(def number-grammar ~(any (+ (group (* ($) (<- :d+))) 1)))
(def symbol-grammar ~(to (if (not (+ "." :d)) 1)))
(def engine-grammar ~(any (+ (* ($) "*") 1)))

(def ii (- (length input) 1))
(def jj (- (length (input 0)) 1))

(var s 0)
(var engines (array/new (length input)))
(var dedup-engines (array/new (length input)))
(loop [i :keys input]
  (loop [part-number :in (peg/match number-grammar (input i))]

  (def ia (max (- i 1) 0))
  (def ib (min (+ i 1) ii))

  (def j (part-number 0))
  (def n (part-number 1))
  (def nn (scan-number n))

  (def ja (max (- j 1) 0))
  (def jb (min (+ ja (length n) 2) jj))

  (def a (string/slice (input ia) ja jb))
  (def c (string/slice (input i) ja jb))
  (def b (string/slice (input ib) ja jb))

  (def ea (map |(+ $ ja) (peg/match engine-grammar a)))
  (def ec (map |(+ $ ja) (peg/match engine-grammar c)))
  (def eb (map |(+ $ ja) (peg/match engine-grammar b)))

  (if-not (get engines ia) (put engines ia @[]))
  (if-not (get engines i) (put engines i @[]))
  (if-not (get engines ib) (put engines ib @[]))

  (array/push (engines ia) (map (fn [x] @[x nn]) ea))
  (array/push (engines i) (map (fn [x] @[x nn]) ec))
  (array/push (engines ib) (map (fn [x] @[x nn]) eb))

  (if (or
        (peg/match symbol-grammar a)
        (peg/match symbol-grammar c)
        (peg/match symbol-grammar b))
    (+= s (scan-number n)))))

(pp s)

(loop [i :keys engines]
  (def ddee @{})
  (def ee (array/concat ;(engines i)))
  (put dedup-engines i ddee)
  (loop [e :in ee]
    (def i (e 0))
    (if-not (get ddee i) (put ddee i @[]))
    (array/push (ddee i) (e 1))))

(var s 0)
(loop [dd :in dedup-engines
       d :in dd]
  (+= s (if (= 2 (length d)) (* ;d) 0)))

(pp s)
