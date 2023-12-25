(math/seedrandom (os/cryptorand 8))
(def input (slurp "inputs/25.txt"))

(def test-input ```
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr

```)

(def grammar ~(some (group (* (<- :a+) ": " (some (* (<- :a+) (any " "))) "\n"))))

(def machine (peg/match grammar test-input))

(def mach (distinct (flatten machine)))

(def machine (tabseq [[k & vs] :in machine] k vs))

(def mach (tabseq [k :in mach]
                  k (do
                      (def result @[])
                      (when-let [v (get machine k)]
                        (array/push result ;v))
                      (loop [[nk nv] :pairs machine]
                        (when (find |(= k $) nv)
                          (array/push result nk)))
                      result)))

(def mach (tabseq [[k vs] :pairs mach]
                     {k 1} (seq [v :in vs] {v 1})))

(while (> (length mach) 2)
  (def mach-keys (keys mach))
  (def rand-key (mach-keys (math/rng-int (math/rng (os/time)) (length mach-keys))))
  (def rand-values (mach rand-key))
  (def rand-index (math/rng-int (math/rng (os/time)) (length rand-values)))
  (def rand-value (rand-values rand-index))
  (def rand-rest (array/remove rand-values rand-index))
  
  (def new-key (table/to-struct (merge rand-key rand-value)))
  (def new-values (mach rand-value))
  (def new-values (array/remove new-values (find-index |(= $ rand-key) new-values)))
  (put mach new-key (distinct @[;rand-rest ;new-values]))
  (put mach rand-key nil)
  (put mach rand-value nil)
  
  (loop [k :in (mach new-key)]
    (def v (mach k))
    (when-let [a (find-index |(= $ rand-key) v)]
      (array/remove v a))
    (when-let [b (find-index |(= $ rand-value) v)]
      (array/remove v b))
    (array/push v new-key)))

(each p (pairs mach) (pp p))
