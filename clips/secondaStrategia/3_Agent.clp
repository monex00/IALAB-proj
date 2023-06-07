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

(defrule go-on-del  (declare (salience 30))
  (status (step ?s))
=>
    (printout t "go on del" ?s crlf crlf)

  (focus DEL)
)


(defrule go-on-action  (declare (salience 20))
    (status (step ?s))

 =>

    ;(printout t crlf crlf)
    (printout t "go on action" ?s crlf crlf)
    (focus ACTION)
)



(defrule ret-from-action  (declare (salience 20))
  (status (step ?s))
  (exec (action ?a) (x ?x) (y ?y) (step ?s))
=>

(printout t "return from action" ?s " " ?a "in " ?x "-" ?y  crlf)

  (pop-focus)
)