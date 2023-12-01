(def input (string/trimr (slurp "inputs/3.txt")))

# Part1
(def coords @['(0 0)])

(loop [c :in input]
  (let 
    [peek (array/peek coords)
     x (first peek)
     y (last peek)]
    (do
      (if (= c 62)
        (let [n (tuple (+ x 1) y)]
          (array/push coords n)))
      (if (= c 60)
        (let [n (tuple (- x 1) y)]
          (array/push coords n)))
      (if (= c 94)
        (let [n (tuple x (+ y 1))]
          (array/push coords n)))
      (if (= c 118)
        (let [n (tuple x (- y 1))]
          (array/push coords n)))
      )))

(pp (length (frequencies coords)))

# Part 2
