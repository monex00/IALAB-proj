;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate modified
	(slot x)
	(slot y)
)

(deftemplate secure-guess
	(slot x)
	(slot y)
)


;EXCLUSION RULES
(defrule exlude-cells-row (declare (salience 40))
	(k-per-row (row ?r) (num ?nr &:(= ?nr 0)))
	(k-per-col (col ?c))
	(not (k-cell (x ?r) (y ?c) (content ?t)))
	(not (secure-guess (x ?r) (y ?c)))
=>
	(printout t "I know that cell " ?r ", " ?c " is empty." crlf)
	(assert (k-cell (x ?r) (y ?c) (content water)))
)


(defrule exlude-cells-col (declare (salience 40))
	(k-per-row (row ?r))
	(k-per-col (col ?c) (num ?nc &:(= ?nc 0)))
	(not (k-cell (x ?r) (y ?c) (content ?t)))
	(not (secure-guess (x ?r) (y ?c)))
=>
	(printout t "I know that cell " ?r ", " ?c " is empty." crlf)
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
	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
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
	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
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
	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
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
	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
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
	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
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
	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
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
	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
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

	(printout t "I know that cell " ?x ", " ?y " is empty around sub." crlf)
)

(defrule guess-known (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & ~water))
	(not (exec (action guess) (x ?x) (y ?y)))
 =>
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(printout t "guessed [" ?x ", " ?y ", " ?t "]." crlf)
	(pop-focus)
)

(defrule known-guess-1 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & top))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y)))
=> 
	(assert (secure-guess (x (+ ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule known-guess-2 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & bot))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (- ?x 1))) (y ?y)))

=> 
	(assert (secure-guess (x (- ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule known-guess-3 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & right))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (- ?y 1)))))

=> 
	(assert (secure-guess (x ?x) (y (- ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)

(defrule known-guess-4 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & left))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (+ ?y 1)))))
=> 
	(assert (secure-guess (x ?x) (y (+ ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
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
	(printout t "I modified [" ?x ", " ?y "] with [" ?nr ", " ?nc "]"  crlf)
)

(defrule print-what-i-know-since-the-beginning
	(k-cell (x ?x) (y ?y) (content ?t) )
=>
	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
)

(defrule fire-highest-knum (declare (salience 30))
	(moves (fires ?nf & :(> ?nf 0)) (guesses ?ng))
	(status (step ?s)(currently running))
	?r1 <- (k-per-row (row ?r) (num ?num1)) 
	?c1 <- (k-per-col (col ?c) (num ?num2)) 
	(not(k-per-row (row ?r2 &: (neq ?r2 ?r)) (num ?n2 &:(> ?n2 ?num1 )))) 
	(not(k-per-col (col ?c2 &: (neq ?c2 ?c)) (num ?n3 &:(> ?n3 ?num2 ))))
	(not(k-cell (x ?r) (y ?c) (content ?t)))
	(not (exec (action fire) (x ?r) (y ?c)))
 => 
	(assert (exec (step ?s) (action fire) (x ?r) (y ?c)))
	(printout t "I know that cell [" ?r ", " ?c "] is prob higher with num [" ?num1 ", " ?num2 "]" crlf) 
	(pop-focus)
)

(defrule fire-middle-border (declare (salience 30))
	(status (step ?s)(currently running))
	(k-cell (x ?x ) (y ?y & 0|9) (content middle))
	(not (exec  (action guess) (x ?x1&:(= ?x1 (+ ?x 1))) (y ?y))) 
 =>
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(printout t "guessed [" ?x ", " ?y "]." crlf)
	(pop-focus)
) 


(defrule inerzia0 (declare (salience 10))
	(status (step ?s)(currently running))
	(moves (fires 0) (guesses ?ng&:(> ?ng 0)))
=>
	(assert (exec (step ?s) (action guess) (x 0) (y 0)))
	
     (pop-focus)

)

(defrule inerzia0-bis (declare (salience 10))
	(status (step ?s)(currently running))
	(moves (guesses 0))
=>
	(assert (exec (step ?s) (action unguess) (x 0) (y 0)))
     (pop-focus)

)
