(defmodule DEL (import MAIN ?ALL) (import ENV ?ALL) (import AGENT ?ALL))


(defrule init-num-cell (declare (salience 50))
	(k-per-row (row ?r) (num ?n1))
	(k-per-col (col ?c) (num ?n2))
	(not (num-cell (x ?r) (y ?c)))
=>
	(assert (num-cell (x ?r) (y ?c) (num (+ ?n1 ?n2))))
)

(defrule modif-num-cell-1 (declare (salience 10))
	(k-per-row (row ?r) (num ?n1))
	(k-per-col (col ?c) (num ?n2))
	(not (num-cell (x ?r) (y ?c) (num ?num &: (= ?num 0))))
	?cell <- (num-cell (x ?r) (y ?c) (num ?n3 &: (neq ?n3 (+ ?n1 ?n2))))
=>
	(retract ?cell)
	(assert (num-cell (x ?r) (y ?c) (num (+ ?n1 ?n2))))
)

(defrule modif-num-cell-2 (declare (salience 10))
	(or
		(secure-guess (x ?r) (y ?c))
		(k-cell (x ?r) (y ?c))
	)
	?r1 <- (num-cell (x ?r) (y ?c) (num ?n &: (neq ?n 0)))
=>
	(retract ?r1)
    (assert (num-cell (x ?r) (y ?c) (num 0)))
)


;EXCLUSION RULES
(defrule exlude-cells-row (declare (salience 40))
	(k-per-row (row ?r) (num ?nr &:(= ?nr 0)))
	(k-per-col (col ?c))
	(not (k-cell (x ?r) (y ?c) (content ?t)))
	(not (secure-guess (x ?r) (y ?c)))
=>
	(assert (k-cell (x ?r) (y ?c) (content water)))
)


(defrule exlude-cells-col (declare (salience 40))
	(k-per-row (row ?r))
	(k-per-col (col ?c) (num ?nc &:(= ?nc 0)))
	(not (k-cell (x ?r) (y ?c) (content ?t)))
	(not (secure-guess (x ?r) (y ?c)))
=>
	(assert (k-cell (x ?r) (y ?c) (content water)))
)

(defrule unify-kcell (declare (salience 40))
	?r <- (k-cell (x ?x ) (y ?y) (content water))
	?r1 <- (k-cell (x ?x1 &:(eq ?x ?x1)) (y ?y1&: (eq ?y ?y1) ) (content water))
    (test(neq ?r ?r1))
=>
	retract ?r1
)


(defrule exlude-cell-sub-1 (declare (salience 40))
	(or
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content top))
		(k-cell (x ?x) (y ?y) (content right))
		(k-cell (x ?x) (y ?y) (content bot))
		(k-cell (x ?x) (y ?y) (content left))
		(k-cell (x ?x) (y ?y) (content middle))
		(secure-guess (x ?x) (y ?y))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 (+ ?x 1))) (y ?y1&: (= ?y1 (+ ?y 1))) (content ?t)))
		(test (< (+ ?x 1) 9))
		(test (< (+ ?y 1) 9))
	)

=>
	(assert (k-cell (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule exlude-cell-sub-2 (declare (salience 40))
	(or
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content top))
		(k-cell (x ?x) (y ?y) (content right))
		(k-cell (x ?x) (y ?y) (content bot))
		(k-cell (x ?x) (y ?y) (content left))
		(k-cell (x ?x) (y ?y) (content middle))
		(secure-guess (x ?x) (y ?y))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 (+ ?x 1))) (y ?y1&: (= ?y1 (- ?y 1))) (content ?t)))
		(test (< (+ ?x 1) 9))
		(test (>= (- ?y 1) 0))
	)

=>
	(assert (k-cell (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule exlude-cell-sub-3 (declare (salience 40))
	(or
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content top))
		(k-cell (x ?x) (y ?y) (content right))
		(k-cell (x ?x) (y ?y) (content bot))
		(k-cell (x ?x) (y ?y) (content left))
		(k-cell (x ?x) (y ?y) (content middle))
		(secure-guess (x ?x) (y ?y))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 (- ?x 1))) (y ?y1&: (= ?y1 (+ ?y 1))) (content ?t)))
		(test (>= (- ?x 1) 0))
		(test (< (+ ?y 1) 9))
	)
=>
	(assert (k-cell (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)
(defrule exlude-cell-sub-4 (declare (salience 40))
	(or
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content top))
		(k-cell (x ?x) (y ?y) (content right))
		(k-cell (x ?x) (y ?y) (content bot))
		(k-cell (x ?x) (y ?y) (content left))
		(k-cell (x ?x) (y ?y) (content middle))
		(secure-guess (x ?x) (y ?y))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 (- ?x 1))) (y ?y1&: (= ?y1 (- ?y 1))) (content ?t)))
		(test (>= (- ?x 1) 0))
		(test (>= (- ?y 1) 0))
	)

=>
	(assert (k-cell (x (- ?x 1)) (y (- ?y 1)) (content water)))
)
(defrule exlude-cell-sub-5 (declare (salience 40))
	(or
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content right))
		(k-cell (x ?x) (y ?y) (content top))
		(k-cell (x ?x) (y ?y) (content bot))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 ?x)) (y ?y1&: (= ?y1 (+ ?y 1))) (content ?t)))
		(test (< (+ ?y 1) 9))
	)

=>
	(assert (k-cell (x ?x) (y (+ ?y 1)) (content water)))
)
(defrule exlude-cell-sub-6 (declare (salience 40))
	(or
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content left))
		(k-cell (x ?x) (y ?y) (content top))
		(k-cell (x ?x) (y ?y) (content bot))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 ?x)) (y ?y1&: (= ?y1 (- ?y 1))) (content ?t)))
		(test (>= (- ?y 1) 0))
	)

=>
	(assert (k-cell (x ?x) (y (- ?y 1)) (content water)))
)
(defrule exlude-cell-sub-7 (declare (salience 40))
	(or
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content right))
		(k-cell (x ?x) (y ?y) (content left))
		(k-cell (x ?x) (y ?y) (content top))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 (- ?x 1))) (y ?y1&: (= ?y1 ?y)) (content ?t)))
		(test (>= (- ?x 1) 0))
	)

=>
	(assert (k-cell (x (- ?x 1)) (y ?y) (content water)))
)

(defrule exlude-cell-sub-8 (declare (salience 40))
	(or 
		(k-cell (x ?x) (y ?y) (content sub))
		(k-cell (x ?x) (y ?y) (content right))
		(k-cell (x ?x) (y ?y) (content left))
		(k-cell (x ?x) (y ?y) (content bot))
	)
	(and
		(not (k-cell (x ?x1&: (= ?x1 (+ ?x 1))) (y ?y1&: (= ?y1 ?y )) (content ?t)))
		(test (< (+ ?x 1) 9))
	)

=>
	(assert (k-cell (x (+ ?x 1)) (y ?y) (content water)))

)


(defrule update-krow-kcol (declare (salience 40))
	(or
		(secure-guess (x ?x) (y ?y))
		(k-cell (x ?x) (y ?y) (content ?t & ~water))
	)
	(not (modified (x ?x) (y ?y)))
	?r <- (k-per-row (row ?x) (num ?nr & :(> ?nr 0)))
	?c <- (k-per-col (col ?y) (num ?nc & :(> ?nc 0)))
=>	
	(modify ?r (num (- ?nr 1)))
	(modify ?c (num (- ?nc 1)))
	(assert (modified (x ?x) (y ?y)))
)

(defrule print-what-i-know-since-the-beginning
	(k-cell (x ?x) (y ?y) (content ?t) )
=>
)