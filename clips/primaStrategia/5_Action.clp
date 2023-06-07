;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  (defmodule ACTION (import MAIN ?ALL) (import ENV ?ALL) (import AGENT ?ALL))

(defrule solve (declare (salience 100))
	(status (step ?s)(currently running))
	(moves (guesses ?ng &:(= ?ng 0)) (fires ?nf &:(= ?nf 0)))
=>
	(assert (exec (step ?s) (action solve)))
	(pop-focus)
)

(defrule guess-known (declare (salience 50))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & ~water))
	(not (exec (action guess) (x ?x) (y ?y)))
 =>
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(pop-focus)
)

(defrule known-guess-1 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & top))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y)))
=> 
	(assert (secure-guess (x (+ ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule known-guess-2 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & bot))
	(not (exec (action guess) (x ?x1 &: (= ?x1 (- ?x 1))) (y ?y)))

=> 
	(assert (secure-guess (x (- ?x 1)) (y ?y)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule known-guess-3 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & right))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (- ?y 1)))))

=> 
	(assert (secure-guess (x ?x) (y (- ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)

(defrule known-guess-4 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & left))
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (+ ?y 1)))))
=> 
	(assert (secure-guess (x ?x) (y (+ ?y 1))))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)

(defrule known-guess-middle-border-1 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & middle))
	(or
		(test (or (= ?y 0) (= ?y 9)))
		(k-cell (x ?x) (y ?y1 &: (= ?y1 (+ ?y 1))) (content ?content & water))
		(k-cell (x ?x) (y ?y1 &: (= ?y1 (- ?y 1))) (content ?content & water))	
	)
	
	(not (exec (action guess) (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y)))
	(not (k-cell (x ?x2 &: (= ?x2 (+ ?x 1))) (y ?y) (content ?content & water)))
=> 
	(assert (secure-guess (x (+ ?x 1)) (y ?y)))
	(printout t "ciao1" crlf)
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)


(defrule known-guess-middle-border-2 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & middle))
	(or
		(test (or (= ?y 0) (= ?y 9)))
		(k-cell (x ?x) (y ?y1 &: (= ?y1 (+ ?y 1))) (content ?content & water))
		(k-cell (x ?x) (y ?y1 &: (= ?y1 (- ?y 1))) (content ?content & water))	
	)
	
	(not (exec (action guess) (x ?x1 &: (= ?x1 (- ?x 1))) (y ?y)))
	(not (k-cell (x ?x2 &: (= ?x2 (- ?x 1))) (y ?y) (content ?content & water)))

=> 
	(assert (secure-guess (x (- ?x 1)) (y ?y)))
	(printout t "ciao2" crlf)
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule known-guess-middle-border-3 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & middle))
	(or
		(test (or (= ?x 0) (= ?x 9)))
		(k-cell (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y) (content ?content & water))
		(k-cell (x ?x1 &: (= ?x1 (- ?x 1))) (y ?y) (content ?content & water))	
	)
	
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (+ ?y 1)))))
	(not (k-cell (x ?x) (y ?y2 &: (= ?y2 (+ ?y 1))) (content ?content & water)))
=> 
	(assert (secure-guess (x ?x) (y (+ ?y 1))))
	(printout t "ciao3" crlf)
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)

(defrule known-guess-middle-border-4 (declare (salience 49))
	(status (step ?s)(currently running))
	(k-cell (x ?x) (y ?y) (content ?t & middle))
	(or
		(test (or (= ?x 0) (= ?x 9)))
		(k-cell (x ?x1 &: (= ?x1 (+ ?x 1))) (y ?y) (content ?content & water))
		(k-cell (x ?x1 &: (= ?x1 (- ?x 1))) (y ?y) (content ?content & water))	
	)
	
	(not (exec (action guess) (x ?x) (y ?y1 &: (= ?y1 (- ?y 1)))))
	(not (k-cell (x ?x) (y ?y2 &: (= ?y2 (- ?y 1))) (content ?content & water)))
=> 
	(assert (secure-guess (x ?x) (y (- ?y 1))))
	(printout t "ciao4" crlf)
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)



(defrule fire-highest-knum-1 (declare (salience 29))
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

(defrule fire-highest-knum-2 (declare (salience 28))
	(moves (fires ?nf & :(> ?nf 0)) (guesses ?ng))
	(status (step ?s)(currently running))
	?r1 <- (k-per-row (row ?r) (num ?num1)) 
	?c1 <- (k-per-col (col ?c) (num ?num2)) 
	(not (k-per-row (row ?r2 &: (neq ?r2 ?r)) (num ?n2 &:(> ?n2 ?num1 )))) 
	(not (k-per-col (col ?c2 &: (neq ?c2 ?c)) (num ?n3 &:(> ?n3 ?num2 ))))
	(or
		(k-cell (x ?r) (y ?c))
		(exec (action fire) (x ?r) (y ?c))
	)
	
	(k-per-col (col ?c3 &: (neq ?c3 ?c)))
	(not (k-cell (x ?r) (y ?c3)))
 => 
	(assert (exec (step ?s) (action fire) (x ?r) (y ?c3)))
	(printout t "I know that cell [" ?r ", " ?c "] is prob higher with num [" ?num1 ", " ?num2 "]" crlf) 
	(pop-focus)
)

(defrule fire-highest-knum-3 (declare (salience 28))
	(moves (fires ?nf & :(> ?nf 0)) (guesses ?ng))
	(status (step ?s)(currently running))
	?r1 <- (k-per-row (row ?r) (num ?num1)) 
	?c1 <- (k-per-col (col ?c) (num ?num2)) 
	(not (k-per-row (row ?r2 &: (neq ?r2 ?r)) (num ?n2 &:(> ?n2 ?num1 )))) 
	(not (k-per-col (col ?c2 &: (neq ?c2 ?c)) (num ?n3 &:(> ?n3 ?num2 ))))
	(or
		(k-cell (x ?r) (y ?c))
		(exec (action fire) (x ?r) (y ?c))
	)
	
	(k-per-row (row ?r3 &: (neq ?r3 ?r)))
	(not (k-cell (x ?r3) (y ?c)))
 => 
	(assert (exec (step ?s) (action fire) (x ?r3) (y ?c)))
	(printout t "I know that cell [" ?r ", " ?c "] is prob higher with num [" ?num1 ", " ?num2 "]" crlf) 
	(pop-focus)
)


(defrule guess-highest-krow-kcol (declare (salience 4))
	(moves (guesses ?nf & :(> ?nf 0)) (fires ?ng))
	(status (step ?s)(currently running))
	?r1 <- (k-per-row (row ?r) (num ?num1)) 
	?c1 <- (k-per-col (col ?c) (num ?num2)) 
	(not (k-per-row (row ?r2 &: (neq ?r2 ?r)) (num ?n2 &:(> ?n2 ?num1 )))) 
	(not (k-per-col (col ?c2 &: (neq ?c2 ?c)) (num ?n3 &:(> ?n3 ?num2 ))))
	(not (k-cell (x ?r) (y ?c)))
	(not (exec (action guess) (x ?r) (y ?c)))
 => 
	(assert (exec (step ?s) (action guess) (x ?r) (y ?c)))	
	(printout t "I know that cell [" ?r ", " ?c "] is prob higher with num [" ?num1 ", " ?num2 "]" crlf) 
	(pop-focus)
)

(defrule guess-highest-knum-2 (declare (salience 3))
	(moves (guesses ?nf & :(> ?nf 0)) (fires ?ng))
	(status (step ?s)(currently running))
	?r1 <- (k-per-row (row ?r) (num ?num1)) 
	?c1 <- (k-per-col (col ?c) (num ?num2)) 
	(not (k-per-row (row ?r2 &: (neq ?r2 ?r)) (num ?n2 &:(> ?n2 ?num1 )))) 
	(not (k-per-col (col ?c2 &: (neq ?c2 ?c)) (num ?n3 &:(> ?n3 ?num2 ))))
	(or
		(k-cell (x ?r) (y ?c))
		(exec (action guess) (x ?r) (y ?c))
	)
	
	(k-per-col (col ?c3 &: (neq ?c3 ?c)))
	(not (k-cell (x ?r) (y ?c3)))
 => 
	(assert (exec (step ?s) (action guess) (x ?r) (y ?c3)))
	(printout t "I know that cell [" ?r ", " ?c "] is prob higher with num [" ?num1 ", " ?num2 "]" crlf) 
	(pop-focus)
)

(defrule guess-highest-knum-3 (declare (salience 3))
	(moves (guesses ?nf & :(> ?nf 0)) (fires ?ng))
	(status (step ?s)(currently running))
	?r1 <- (k-per-row (row ?r) (num ?num1)) 
	?c1 <- (k-per-col (col ?c) (num ?num2)) 
	(not (k-per-row (row ?r2 &: (neq ?r2 ?r)) (num ?n2 &:(> ?n2 ?num1 )))) 
	(not (k-per-col (col ?c2 &: (neq ?c2 ?c)) (num ?n3 &:(> ?n3 ?num2 ))))
	(or
		(k-cell (x ?r) (y ?c))
		(exec (action guess) (x ?r) (y ?c))
	)
	
	(k-per-row (row ?r3 &: (neq ?r3 ?r)))
	(not (k-cell (x ?r3) (y ?c)))
 => 
	(assert (exec (step ?s) (action guess) (x ?r3) (y ?c)))
	(printout t "I know that cell [" ?r ", " ?c "] is prob higher with num [" ?num1 ", " ?num2 "]" crlf) 
	(pop-focus)
)
