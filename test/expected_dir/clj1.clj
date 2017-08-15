clojure	comment	;;; Copyright (C) 2009 Brendan Ribera. All rights reserved.
clojure	comment	;;; Distributed under the MIT License; see the file LICENSE
clojure	comment	;;; at the root of this distribution.
clojure	code	(ns kdtree)
clojure	blank	
clojure	code	(defn dist-squared [a b]
clojure	code	    "Compute the K-dimensional distance between two points"
clojure	code	      (reduce + (for [i (range (count a))]
clojure	code	                                (let [v (- (nth a i)
clojure	code	                                            (nth b i))]
clojure	code	                                                  (* v v)))))
clojure	blank	
clojure	comment	;;; Simple accessors
clojure	code	(defn- node-value [n] (first n))
clojure	code	(defn- node-left  [n] (first (rest n)))
clojure	code	(defn- node-right [n] (first (rest (rest n))))
