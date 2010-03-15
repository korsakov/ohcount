;;; Copyright (C) 2009 Brendan Ribera. All rights reserved.
;;; Distributed under the MIT License; see the file LICENSE
;;; at the root of this distribution.
(ns kdtree)

(defn dist-squared [a b]
    "Compute the K-dimensional distance between two points"
      (reduce + (for [i (range (count a))]
                                (let [v (- (nth a i)
                                            (nth b i))]
                                                  (* v v)))))

;;; Simple accessors
(defn- node-value [n] (first n))
(defn- node-left  [n] (first (rest n)))
(defn- node-right [n] (first (rest (rest n))))
