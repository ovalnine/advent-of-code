(def input (slurp "inputs/20.txt"))

(def test-input ```
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a

```)

(def test-input-2 ```
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output

```)

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
  (table ;(catseq [[name value] :in (filter |(= "&" (first (last $))) (pairs modules))]
                  [name (table ;(flatten (map |[(first $) false] (filter |(find (fn [x] (= x name)) (last (last $))) (pairs modules)))))])))

(var low 0)
(var high 0)
(loop [i :range [0 100]]
  (def queue @[["broadcaster" false "button"]])
  (while (> (length queue) 0)
    (prompt :ret
      (def [sigkey sigvalue sigsrc] (array/unshift queue))
      (if sigvalue (++ high) (++ low))
      (unless (has-key? modules sigkey)
        (pp sigvalue)
        (return :ret))
      (def [mtype mout] (modules sigkey))
      (match mtype 
        "b" (array/push queue ;(map |[$ sigvalue sigkey] mout))
        "%"
        (do
          (def state (not (or (get states sigkey) false)))
          (unless sigvalue
            (set (states sigkey) state)
            (array/push queue ;(map |[$ state sigkey] mout))))
        "&"
        (do
          (def state (or (get states sigkey) @{}))
          (set (state sigsrc) sigvalue)
          (array/push queue ;(map |[$ (not (all truthy? (values state))) sigkey] mout)))))))

(pp (* low high))
