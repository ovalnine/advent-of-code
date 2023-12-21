(def input (slurp "inputs/20.txt"))

(def grammar
  ~{:output (* (<- :a+) (any ", "))
    :module (group (+ (<- (* (constant "b") "broadcaster")) (* (<- (+ "%" "&")) (<- :a+))))
    :main (some (/ (* :module " -> " (group (some :output)) 1) ,|{(last $0) [(first $0) $1]}))})

(def modules (merge ;(peg/match grammar input)))

(defn array/unshift [arr]
  (def [sig] (array/slice arr 0 1))
  (array/remove arr 0)
  sig)

(def states
  (tabseq
    [[mname [mtype mout]] :pairs modules]
    mname (tabseq
            [[name _] :in (filter (fn [[_ [_ out]]] (find |(= $ mname) out)) (pairs modules))]
            name false)))

# Hardcoded modules for my input (change to inputs of "rx")
(def memo @{"ch" false "gh" false "sv" false "th" false})
(var c 0)
(var low 0)
(var high 0)
(forever
  (when (= c 1000) (pp (* low high)))
  (++ c)
  (when (all truthy? memo) (break))
  (def queue @[["broadcaster" false "button"]])
  (while (> (length queue) 0)
    (prompt :ret
      (def [sigkey sigvalue sigsrc] (array/unshift queue))
      (if sigvalue (++ high) (++ low))
      (unless (has-key? modules sigkey)
        (return :ret))
      (def [mtype mout] (modules sigkey))
      (match mtype 
        "b" (array/push queue ;(map |[$ sigvalue sigkey] mout))
        "%"
        (do
          (def state (states sigkey))
          (def sig (not (state sigsrc)))
          (unless sigvalue
            (set (state sigsrc) sig)
            (array/push queue ;(map |[$ sig sigkey] mout))))
        "&"
        (do
          (def state (states sigkey))
          (set (state sigsrc) sigvalue)
          (def sigout (all truthy? (values state)))
          (array/push queue ;(map |[$ (not sigout) sigkey] mout))
          (when (and (has-key? memo sigkey) (not sigout))
            (unless (memo sigkey) (set (memo sigkey) c))))))))

(pp (* ;(values memo)))
