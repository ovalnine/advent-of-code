(def input (slurp "inputs/22.txt"))

(defn get2 [a x y]
  (get (get a y) x))

(defn set2 [a x y value]
  (set ((a y) x) value))

(defn top-rays [rays [{:x sx :y sy} {:x ex :y ey}]]
  (def f (get2 rays sx sy))
  (var [deps level] [@[(f :brick)] (f :level)])
  (loop [j :range [sy (inc ey)]]
    (loop [i :range [sx (inc ex)]
           :let [{:brick b :level l} (get2 rays i j)]]
      (unless (has-value? deps b)
        (match (compare l level)
          0 (array/push deps b)
          1 (do (set deps @[b]) (set level l))))))
  {:deps deps :level level})

(defn mat/fill [rays [{:x sx :y sy} {:x ex :y ey}] value]
  (loop [j :range [sy (inc ey)]]
    (loop [i :range [sx (inc ex)]]
           (set2 rays i j value))))

(def grammar
  ~{:coord (/ (* (number :d+) 1 (number :d+) 1 (number :d+)) ,|{:x $0 :y $1 :z $2})
    :brick (group (* :coord "~" :coord "\n"))
    :main (some :brick)})

(def bricks (peg/match grammar input))
(sort-by |(min ((first $) :z) ((last $) :z)) bricks)

(def rays @[])
(loop [i :range [0 10]]
  (array/push rays (array/new-filled 10 {:brick 0 :level 0})))

(def deps @{0 @[]})
(def inv-deps @{})

(loop [[i brick] :pairs bricks
       :let [ii (inc i)
             tops (top-rays rays brick)]]
  (set (inv-deps ii) (tops :deps))
  (loop [d :in (tops :deps)]
    (if (has-key? deps d)
      (array/push (deps d) ii)
      (set (deps d) @[ii])))
  (def height (- ((last brick) :z) ((first brick) :z)))
  (def new-level (+ height (inc (tops :level))))
  (mat/fill rays brick {:brick ii :level new-level}))

(var s @{})
(loop [i :range [1 (inc (length bricks))]]
  (when (> (length (inv-deps i)) 1)
    (each d (inv-deps i) (put s d true))))

(loop [i :range [1 (inc (length bricks))]]
  (when (= (length (inv-deps i)) 1)
    (put s (first (inv-deps i)) nil)))

(def nil-above (inc (- (length bricks) (length (keys deps)))))
(def multi-below (length (keys s)))

(pp (+ nil-above multi-below))

(defn array/unshift [arr]
  (def [sig] (array/slice arr 0 1))
  (array/remove arr 0)
  sig)

# Part 2

(defn fall [i deps inv-deps]
  (unless (get deps i) (break 0))
  (def queue @[;(get deps i)])
  (def fallen @{i true})
  (while (> (length queue) 0)
    (def curr (array/unshift queue))
    (def dep (get deps curr))
    (def inv (inv-deps curr))
    (when (all |(has-key? fallen $) inv)
      (put fallen curr true)
      (when dep
        (each d dep (array/push queue d)))))
  (dec (length (keys fallen))))

(pp (sum (map |(fall $ deps inv-deps) (range 1 (inc (length bricks))))))
