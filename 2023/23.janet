(def input (slurp "inputs/23.txt"))

(def trails (peg/match ~(some (group (* (some (<- (set "#.><^v"))) 1))) input))
(def trails2 (peg/match ~(some (group (* (some (/ (<- (set "#.><^v")) ,|(if (= $ "#") "#" "."))) 1))) input))

(defn get2 [mat x y]
  (get (get mat y) x))

(defn hike [trails pos end visited compress memo]
  (def {:x x :y y :i i :j j} pos)
  (when (and (= x (end :x)) (= y (end :y))) (break 1))

  (when (has-key? visited {:x x :y y}) (break nil))
  (put visited {:x x :y y} true)

  (def paths [{:x (+ x i) :y (+ y j) :i i :j j}
              {:x (+ x j) :y (- y i) :i j :j (- i)}
              {:x (- x j) :y (+ y i) :i (- j) :j i}])

  (def intersection? (not= 2 (count |(= "#" (get2 trails ($ :x) ($ :y))) paths)))

  (when (and intersection? (not (has-key? memo (compress :pos))))
    (def origin (compress :pos))
    (def c (compress :count))
    (def inv-pos {:x (pos :x) :y (pos :y) :i (- (pos :i)) :j (- (pos :j))})
    (def inv-origin {:x (origin :x) :y (origin :y) :i (- (origin :i)) :j (- (origin :j))})
    (put memo origin {:pos pos :count c})
    (put memo inv-pos {:pos inv-origin :count c}))

  (def m (->> (-> |(do
                     (def t (get2 trails ($ :x) ($ :y)))
                     (when
                       (or
                         (= t ".")
                         (and (= t ">") (pos? ($ :i)))
                         (and (= t "<") (neg? ($ :i)))
                         (and (= t "v") (pos? ($ :j)))
                         (and (= t "^") (neg? ($ :j))))

                       (def compress
                         (if intersection?
                           {:pos {:x (pos :x) :y (pos :y) :i ($ :i) :j ($ :j)} :count 0}
                           {:pos (compress :pos) :count (inc (compress :count))}))

                       (def memoed (get memo (compress :pos)))
                       (if memoed
                         (do
                           (def c (hike trails (memoed :pos) end visited {:pos (compress :pos) :count (memoed :count)} memo))
                           (when c 
                             (+ (memoed :count) c)))
                         (hike trails $ end visited compress memo))))
                  (map paths))
              (filter truthy?)
              (splice)
              (max)))

  (put visited {:x x :y y} nil)

  (when m (+ 1 m)))

(def pos {:x 1 :y 0 :i 0 :j 1})
(def obj {:x (- (length (trails 0)) 2) :y (dec (length trails))})

(pp (dec (hike trails pos obj @{} {:pos pos :count 0} @{})))

# Part 2 implementation took way too long to run (22m), so maybe I can improve this somehow
# but it gets the right answer for now
(pp (dec (hike trails2 pos obj @{} {:pos pos :count 0} @{})))
