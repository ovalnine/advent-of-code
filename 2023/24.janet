(def input (slurp "inputs/24.txt"))

(def test-input ```
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3

```)
(def input (string/trimr input))
(def input (string/split"\n" input))
(def hailstones (map (fn [x] (map (fn [y] (map |(scan-number (string/trim $)) (string/split "," y))) (string/split "@" x))) input))

(defn b [x y m]
  (- y (* m x)))

(defn intersection [[a b] [c d]]
  (/ (- d b) (- a c)))

(defn past? [[x y] [i j] [a b]]
  (when (and (pos? i) (pos? j)) (break (not (and (> a x) (> b y)))))
  (when (and (pos? i) (neg? j)) (break (not (and (> a x) (< b y)))))
  (when (and (neg? i) (pos? j)) (break (not (and (< a x) (> b y)))))
  (when (and (neg? i) (neg? j)) (break (not (and (< a x) (< b y)))))
  (when (and (pos? i) (zero? j)) (break (not (> a x))))
  (when (and (neg? i) (zero? j)) (break (not (< a x))))
  (when (and (zero? i) (pos? j)) (break (not (> b y))))
  (when (and (zero? i) (neg? j)) (break (not (< b y)))))

(def inters (catseq [ii :range [0 (length hailstones)]]
                (seq [jj :range [(inc ii) (length hailstones)]]
                  (def [[ax ay az] [ai aj ak]] (hailstones ii))
                  (def [[bx by bz] [bi bj bk]] (hailstones jj))
                  (def ma (/ aj ai))
                  (def mb (/ bj bi))
                  (def ba (b ax ay ma))
                  (def bb (b bx by mb))
                  (def x (intersection [ma ba] [mb bb]))
                  (def y (+ (* ma x) ba))
                  (def pa (past? [ax ay] [ai aj] [x y]))
                  (def pb (past? [bx by] [bi bj] [x y]))
                  {:x x :y y :past (or pa pb)})))

(def min-limit 200000000000000)
(def max-limit 400000000000000)

(pp (count |(and
               (> ($ :x) min-limit)
               (< ($ :x) max-limit)
               (> ($ :y) min-limit)
               (< ($ :y) max-limit)
               (not ($ :past)))
            inters))
