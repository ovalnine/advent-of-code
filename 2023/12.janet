(def input (slurp "inputs/12.txt"))

(def test-input ```
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1

```)


(def grammar
  ~{:damaged (group (some (* (number :d+) 1)))
    :springs (/ (<- (to " ")) ,|(map string/from-bytes (string/bytes $)))
    :main (some (+ (group (* :springs 1 :damaged)) 1))})

(def springs (peg/match grammar input))

(defn
  matcher 
  [springs groups acc memo]
  (def k [springs groups acc])
  (when-let [x (in memo k)]
    (break x))

  (set (memo k)
    (match springs 
      [s & ss]
      (match s
        "?"
        (+
          (matcher (array/concat @["."] ss) groups acc memo)
          (matcher (array/concat @["#"] ss) groups acc memo))
        "."
        (match groups 
          [g & gg]
          (cond
            (= acc 0) (matcher ss groups 0 memo)
            (= acc g) (matcher ss gg 0 memo)
            0)
          # empty-groups
          (matcher ss () acc memo))
        "#"
        (matcher ss groups (inc acc) memo))
      # empty-springs 
      (cond
        (and (= (length groups) 0) (= acc 0)) 1
        (and (= (length groups) 1) (= acc (groups 0))) 1
        0)
      )))

(def springs (map |@[(array/slice (catseq [_ :range [0 5]] (array/concat @["?"] ($ 0))) 1)
                     (catseq [_ :range [0 5]] ($ 1))] springs))

(pp (sum (map |(matcher ($ 0) ($ 1) 0 @{}) springs)))

  
