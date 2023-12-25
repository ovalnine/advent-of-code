(def input (slurp "inputs/25.txt"))

(def grammar ~(some (group (* (<- :a+) ": " (some (* (<- :a+) (any " "))) "\n"))))

(def machine (peg/match grammar input))

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


(forever 
  (def temp (tabseq [[k vs] :pairs mach]
                    {k 1} (seq [v :in vs] {v 1})))

  (while (> (length temp) 2)
    (def mach-keys (keys temp))
    (def rand-key (mach-keys (math/rng-int (math/rng (os/time)) (length mach-keys))))
    (def rand-values (temp rand-key))
    (def rand-index (math/rng-int (math/rng (os/time)) (length rand-values)))
    (def rand-value (rand-values rand-index))
    
    (def new-key (table/to-struct (merge rand-key rand-value)))
    (def new-values (temp rand-value))
    (def new-values @[;rand-values ;new-values])
    (forever
      (if-let [i (find-index |(or (= $ rand-key) (= $ rand-value)) new-values)]
        (array/remove new-values i)
        (break)))
  
    (put temp new-key new-values)
    (put temp rand-key nil)
    (put temp rand-value nil)
    
    (loop [k :in (temp new-key)]
      (def v (temp k))
      (when-let [a (find-index |(= $ rand-key) v)]
        (array/remove v a)
        (array/push v new-key))
      (when-let [b (find-index |(= $ rand-value) v)]
        (array/remove v b)
        (array/push v new-key))))
  (def [ak av] (first (pairs temp)))
  (when (= (length av) 3)
    (pp (* (length (keys ak)) (length (keys (first av)))))
    (break)))
