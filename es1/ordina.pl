% given a list ordinate it

ordina([],[]).
ordina([X],[X]).

ordina([X,Y|T],Ord) :-
    X > Y,
    ordina([Y|T],Ord1),
    aggiungi([X],Ord1,Ord).

ordina([X,Y|T],Ord) :-
    X =< Y,
    ordina([X|T],Ord1),
    aggiungi([Y],Ord1,Ord).

aggiungi([], L, L).
aggiungi([X], [], [X]).

aggiungi([X], [H|T], L) :-
    X =< H,
    append([X], [H|T], L).

aggiungi([X], [H|T], L) :-
    X > H,
    aggiungi([X], T, L1),
    append([H], L1, L).
    



    



