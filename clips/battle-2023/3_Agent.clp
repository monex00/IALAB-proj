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

(deftemplate num-cell
	(slot x)
	(slot y)
	(slot num) ;somma k per riga/colonna
)


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
	?r1 <- (num-cell (x ?r) (y ?c))
=>
	(modify ?r1 (num 0))
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

(defrule known-guess-middle-border-1 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y & 0|9) (content ?t & middle))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y)))
=> 
	(assert (secure-guess (x (+ ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)


(defrule known-guess-middle-border-2 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y & 0|9) (content ?t & middle))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (- ?x 1))) (y ?y)))
=> 
	(assert (secure-guess (x (- ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule known-guess-middle-border-3 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x & 0|9) (y ?y) (content ?t & middle))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (+ ?y 1)))))
=> 
	(assert (secure-guess (x ?x) (y (+ ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)

(defrule known-guess-middle-border-4 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x & 0|9) (y ?y) (content ?t & middle))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (- ?y 1)))))
=> 
	(assert (secure-guess (x ?x) (y (- ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)


(defrule guess-middle-hor1 (declare (salience 20))
	(status (step ?s)(currently running))
	(k-cell (x ?x & ~0 & ~9) (y ?y & ~0 & ~9) (content ?t & middle))
	(not (exec (action guess) (x ?x) (y ?y1 &:(= ?y1 (- ?y 1) ))))
	(not (k-cell (x ?x1 &: (= ?x1 ?x)) (y ?y1 &: (= ?y1 (- ?y 1))) (content ?t1 & water)))
	(or
		(not (exec (action guess) (x ?x1 &:(= ?x1 (- ?x 1) )) (y ?y )))
		(not (exec (action guess) (x ?x1 &:(= ?x1 (+ ?x 1) )) (y ?y )))	
	)
	

	(or
		(or
			(k-cell (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y) (content ?t1 & water))
			(k-cell (x ?x2 &: (= ?x2 (- ?x 1))) (y ?y) (content ?t2 & water))
		)
		(and
			(num-cell (x ?x3 &: (= ?x3 (+ ?x 1))) (y ?y) (num ?num1))
			(num-cell (x ?x4 &: (= ?x4 (- ?x 1))) (y ?y) (num ?num2))
			(num-cell (x ?x) (y ?y3 &: (= ?y3 (- ?y 1))) (num ?num3 &: (>= ?num3 ?num2)&: (>= ?num3 ?num1)))
			(num-cell (x ?x) (y ?y4 &: (= ?y4 (+ ?y 1))) (num ?num4 &: (>= ?num4 ?num1)&: (>= ?num4 ?num2)))		
		)
	)
=> 
	(assert (secure-guess (x ?x) (y (- ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-middle-hor2 (declare (salience 20))
	(status (step ?s)(currently running))
	(k-cell (x ?x & ~0 & ~9) (y ?y & ~0 & ~9) (content ?t & middle))
	(not (exec (action guess) (x ?x) (y ?y1 &:(= ?y1 (+ ?y 1) ))))
	(not (k-cell (x ?x1 &: (= ?x1 ?x)) (y ?y1 &: (= ?y1 (+ ?y 1))) (content ?t1 & water)))

	(or
		(not (exec (action guess) (x ?x1 &:(= ?x1 (- ?x 1) )) (y ?y )))
		(not (exec (action guess) (x ?x1 &:(= ?x1 (+ ?x 1) )) (y ?y )))	
	)
	(or
		(or
			(k-cell (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y) (content ?t1 & water))
			(k-cell (x ?x2 &: (= ?x2 (- ?x 1))) (y ?y) (content ?t2 & water))
		)
		(and
			(num-cell (x ?x3 &: (= ?x3 (+ ?x 1))) (y ?y) (num ?num1))
			(num-cell (x ?x4 &: (= ?x4 (- ?x 1))) (y ?y) (num ?num2))
			(num-cell (x ?x) (y ?y3 &: (= ?y3 (- ?y 1))) (num ?num3 &: (>= ?num3 ?num2) &: (>= ?num3 ?num1)))
			(num-cell (x ?x) (y ?y4 &: (= ?y4 (+ ?y 1))) (num ?num4 &: (>= ?num4 ?num1) &: (>= ?num4 ?num2)))
		)
	)
=> 
	(assert (secure-guess (x ?x) (y (+ ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)

(defrule guess-middle-ver1 (declare (salience 20))
	(status (step ?s)(currently running))
	(k-cell (x ?x & ~0 & ~9) (y ?y & ~0 & ~9) (content ?t & middle))
	(not (exec (action guess) (x ?x1 &:(= ?x1 (- ?x 1) )) (y ?y )))
	(not (k-cell (x ?x1 &: (= ?x1 (- ?x 1))) (y ?y) (content ?t1 & water)))
	(or
		(not (exec (action guess) (x ?x) (y ?y1 &:(= ?y1 (- ?y 1) ))))
		(not (exec (action guess) (x ?x) (y ?y1 &:(= ?y1 (+ ?y 1) ))))
	)

	(or
		(or
			(k-cell (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y) (content ?t1 & water))
			(k-cell (x ?x2 &: (= ?x2 (- ?x 1))) (y ?y) (content ?t2 & water))
		)
		(and
			(num-cell (x ?x) (y ?y3 &: (= ?y3 (- ?y 1))) (num ?num3 ))
			(num-cell (x ?x) (y ?y4 &: (= ?y4 (+ ?y 1))) (num ?num4 ))
			(num-cell (x ?x3 &: (= ?x3 (+ ?x 1))) (y ?y) (num ?num1&: (>= ?num1 ?num3) &: (>= ?num1 ?num4)))
			(num-cell (x ?x4 &: (= ?x4 (- ?x 1))) (y ?y) (num ?num2&: (>= ?num2 ?num3) &: (>= ?num2 ?num4)))		
		)
	)
=> 
	(assert (secure-guess (x (- ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule guess-middle-ver2 (declare (salience 20))
	(status (step ?s)(currently running))
	(k-cell (x ?x & ~0 & ~9) (y ?y & ~0 & ~9) (content ?t & middle))
	(not (exec (action guess) (x ?x1 &:(= ?x1 (+ ?x 1) )) (y ?y )))
	(not (k-cell (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y) (content ?t1 & water)))
	(or
		(not (exec (action guess) (x ?x) (y ?y1 &:(= ?y1 (- ?y 1) ))))
		(not (exec (action guess) (x ?x) (y ?y1 &:(= ?y1 (+ ?y 1) ))))
	)
	(or
		(or
			(k-cell (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y) (content ?t1 & water))
			(k-cell (x ?x2 &: (= ?x2 (- ?x 1))) (y ?y) (content ?t2 & water))
		)
		(and
			
			(num-cell (x ?x) (y ?y3 &: (= ?y3 (- ?y 1))) (num ?num3 ))
			(num-cell (x ?x) (y ?y4 &: (= ?y4 (+ ?y 1))) (num ?num4 ))
			(num-cell (x ?x3 &: (= ?x3 (+ ?x 1))) (y ?y) (num ?num1&: (>= ?num1 ?num3) &: (>= ?num1 ?num4)))
			(num-cell (x ?x4 &: (= ?x4 (- ?x 1))) (y ?y) (num ?num2&: (>= ?num2 ?num3) &: (>= ?num2 ?num4)))
		)
	)
=> 
	(assert (secure-guess (x (+ ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
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


(defrule known-guess-on-3-1 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & top))
	(secure-guess (x ?x5 &: (= ?x5 (+ ?x 1))) (y ?y))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (+ ?x 2))) (y ?y)))
	(num-cell (x ?x3 &: (= ?x3 (+ ?x 2))) (y ?y) (num ?num3 &:(> ?num3 0)))
	(not (num-cell (x ?x4 &: (neq ?x4 ?x3)) (y ?y) (num ?num4 &:(> ?num4 ?num3))))
=> 
	(assert (secure-guess (x (+ ?x 2)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 2)) (y ?y)))
	(pop-focus)
)

(defrule known-guess-on-3-2 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & bot))
	(secure-guess (x ?x5 &: (= ?x5 (- ?x 1))) (y ?y))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (- ?x 2))) (y ?y)))
	(num-cell (x ?x3 &: (= ?x3 (- ?x 2))) (y ?y) (num ?num3 &:(> ?num3 0)))
	(not (num-cell (x ?x4 &: (neq ?x4 ?x3)) (y ?y) (num ?num4 &:(> ?num4 ?num3))))
=> 
	(assert (secure-guess (x (- ?x 2)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (- ?x 2)) (y ?y)))
	(pop-focus)
)


(defrule known-guess-on-3-3 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & right))
	(secure-guess (x ?x) (y ?y5 &: (= ?y5 (- ?y 1))))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (- ?y 2)))))
	(num-cell (x ?x) (y ?y3 &: (= ?y3 (- ?y 2))) (num ?num3 &:(> ?num3 0)))
	(not (num-cell (x ?x) (y ?y4 &: (neq ?y4 ?y3)) (num ?num4 &:(> ?num4 ?num3))))

=> 
	(assert (secure-guess (x ?x) (y (- ?y 2))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 2))))
	(pop-focus)
)

(defrule known-guess-on-3-4 (declare (salience 40))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & left))
	(secure-guess (x ?x) (y ?y5 &: (= ?y5 (+ ?y 1))))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (+ ?y 2)))))
	(num-cell (x ?x) (y ?y3 &: (= ?y3 (+ ?y 2))) (num ?num3 &:(> ?num3 0)))
	(not (num-cell (x ?x) (y ?y4 &: (neq ?y4 ?y3)) (num ?num4 &:(> ?num4 ?num3))))

=> 
	(assert (secure-guess (x ?x) (y (+ ?y 2))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 2))))
	(pop-focus)
)


(defrule fire-highest-knum (declare (salience 30))
	(moves (fires ?nf & :(> ?nf 0)) (guesses ?ng))
	(status (step ?s)(currently running))
	?r1 <- (k-per-row (row ?r) (num ?num1)) 
	?c1 <- (k-per-col (col ?c) (num ?num2)) 
	(not (k-per-row (row ?r2 &: (neq ?r2 ?r)) (num ?n2 &:(> ?n2 ?num1 )))) 
	(not (k-per-col (col ?c2 &: (neq ?c2 ?c)) (num ?n3 &:(> ?n3 ?num2 ))))
	(not (k-cell (x ?r) (y ?c)))
	(not (exec (action fire) (x ?r) (y ?c)))
 => 
	(assert (exec (step ?s) (action fire) (x ?r) (y ?c)))
	(printout t "I know that cell [" ?r ", " ?c "] is prob higher with num [" ?num1 ", " ?num2 "]" crlf) 
	(pop-focus)
)


(defrule solve (declare (salience 100))
	(status (step ?s)(currently running))
	(moves (guesses ?ng &:(= ?ng 0)) (fires ?nf &:(= ?nf 0)))
=>
	(assert (exec (step ?s) (action solve)))
	(pop-focus)
)

(defrule guess-highest-knum (declare (salience 5))
	(moves (guesses ?nf & :(> ?nf 0)) (fires ?ng))
	(status (step ?s)(currently running))
	?n1 <- (num-cell (x ?x) (y ?y) (num ?num &:(> ?num 0)))
	(not (num-cell (x ?x1 & ~?x) (y ?y1 & ~?y) (num ?num1 &:(> ?num1 ?num))))
	(not (k-cell (x ?x) (y ?y)))
	(not (exec (action guess) (x ?x) (y ?y)))
 => 
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(modify ?n1 (num 0))
	(pop-focus)
)
