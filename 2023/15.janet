(def input (slurp "inputs/15.txt"))
(def input (string/trimr input))
(def input (string/split "," input))

(def test-input ```
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7

```)
(def test-input (string/trimr test-input))
(def test-input (string/split "," test-input))

(defn
  byte-hash
  [x]
  (% (* x 17) 256))

(defn
  buffer-hash
  [x]
  (reduce (fn [acc curr] (byte-hash (+ acc curr))) 0 x))

(pp (sum (map buffer-hash input)))

(defn
  focal-length
  [x]
  (def grammar ~(* (<- (+ (to "=") (to "-"))) (+ (if "=" (* 1 (number :d))) (if "-" (* 1 (constant nil))))))
  (peg/match grammar x))

# Part 2
(def boxes (array/new 256))

(loop [i :in input]
  (def [l fl] (focal-length i))
  (def h (buffer-hash l))
  (unless (get boxes h) (set (boxes h) @[]))
  (def box (boxes h))
  (if fl
    (do
      (def index (find-index |(= l (first $)) box))
      (if index
        (set (box index) (tuple l fl))
        (array/push box (tuple l fl))))
    (do
      (def index (find-index |(= l (first $)) box))
      (when index
        (array/remove box index)))))

(pp (sum (catseq [[i box] :pairs boxes]
            (if
              box
              (seq [[j lens] :pairs box]
                (* (inc i) (inc j) (last lens)))
              0))))
