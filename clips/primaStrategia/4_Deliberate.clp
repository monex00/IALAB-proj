(defmodule DEL (import MAIN ?ALL) (import ENV ?ALL) (import AGENT ?ALL))



(defrule update-krow-kcol (declare (salience 45))
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


;EXCLUSION RULES


(defrule unify-kcell (declare (salience 40))
	?r <- (k-cell (x ?x ) (y ?y) (content water))
	?r1 <- (k-cell (x ?x1 &:(eq ?x ?x1)) (y ?y1&: (eq ?y ?y1) ) (content water))
    (test(neq ?r ?r1))
=>
	retract ?r1
)

