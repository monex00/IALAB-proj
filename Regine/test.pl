%state = [R1, R2, R3, R4, R5, R6, R7, R8] rappesenta la colonna della regina allariga R1, R2, R3, R4, R5, R6, R7, R8

% check minaccia
minaccia_colonna(R1, R2, State) :- nth1(R1, State, C1), nth1(R2, State, C2), C1 = C2.
minaccia_diagonale(R1, R2, State) :- nth1(R1, State, C1), nth1(R2, State, C2), D is abs(C1 - C2), R is abs(R1 - R2), D = R.

minaccia(R1, R2, State) :- 
    minaccia_colonna(R1, R2, State);
    minaccia_diagonale(R1, R2, State).
    
%heuristic e goal
minacciate(R, State) :- 
    findall((R1, R2), (nth1(R1, State, _), nth1(R2, State, _), R1 < R2, minaccia(R1, R2, State)), R),
    length(R, N),
    write(N).

heuristic(State, H) :- 
    findall((R1, R2), (nth1(R1, State, _), nth1(R2, State, _), R1 < R2, minaccia(R1, R2, State)), R),
    length(R, H1),
    H is H1.

goal(State) :- 
    findall((R1, R2), (nth1(R1, State, _), nth1(R2, State, _), R1 < R2, minaccia(R1, R2, State)), R),
    length(R, 0),
    write(State).

%utils
copy(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).

modify_at_index(Index, Value, L, R) :- accMod(Index, Value, L, R, 1).

accMod(_, _, [], [], _).
accMod(I, V, [_|T], [V|R], I) :- I1 is I + 1, accMod(I, V, T, R, I1).
accMod(I, V, [H|T], [H|R], C) :- C \= I, C1 is C + 1, accMod(I, V, T, R, C1).

/* order(State, R) :-
    order_by_heuristic(State, R1),
    reset(R1, R).

reset([], []).
reset([(R1, _)|R2], [R1|R3]) :- reset(R2, R3). */

/* insert_list(E, H, [], [(E, H)]).
insert_list(E, H, [(E1, H1)|T], [(E, H), (E1, H1)|T]) :- H =< H1.
insert_list(E, H, [(E1, H1)|T], [(E1, H1)|R]) :- H > H1, insert_list(E, H, T, R). 

order_by_heuristic([], []).
order_by_heuristic([H|T], R) :- 
    heuristic(H, H1),
    order_by_heuristic(T, R1),
    insert_list(H, H1, R1, R).
*/

%azioni
applicabile(giu, R, State) :-
    nth1(R, State, C),
    C1 is C - 1,
    C1 > 0.

applicabile(su, R, State) :-
    nth1(R, State, C),
    C1 is C + 1,
    length(State, N),
    C1 =< N.

trasforma(giu, R, State, R1) :-
    nth1(R, State, C),
    C1 is C - 1,
    modify_at_index(R, C1, State, R1).

trasforma(su, R, State, R1) :-
    nth1(R, State, C),
    C1 is C + 1,
    modify_at_index(R, C1, State, R1).


%ricerca A*
/* a_star(Start, Solution) :-
    a_star([Start], [], Solution).

a_star([State|_], _, State) :- goal(State).

a_star([State|T], Closed, Solution) :-
    findall(R1, (applicabile(A, R, State), trasforma(A, R, State, R1), \+ member(R1, Closed)), R),
    order(R, R1),
    write_first(R1),
    write('\n'),
    append(T, R1, T1),
    a_star(T1, [State|Closed], [State|Solution]). */

%ricerca BFS
risolvi([[S,PathToS]|_],_,PathToS):-goal(S),!.
risolvi([[S,PathToS]|Coda],Visitati,Cammino):-
    findall((Az, R),applicabile(Az, R, S),ListaAzioniApplicabili),
    generaStatiFigli(S,ListaAzioniApplicabili,Visitati,PathToS,ListaNuoviStati),
    order(ListaNuoviStati, ListaNuoviStatiOrdinati),
    /* write_first(ListaNuoviStati), */
    /* write('\n'), */
    append(Coda,ListaNuoviStatiOrdinati,NuovaCoda),
    risolvi(NuovaCoda,[S|Visitati],Cammino).

generaStatiFigli(_,[],_,_,[]):-!.
generaStatiFigli(S,[(Az, R)|AltreAzioni],Visitati,PathToS,[[Snuovo,[(Az,R)|PathToS]]|ListaStati]):-
    trasforma(Az,R,S,Snuovo),
    \+member(Snuovo,Visitati),!,
    /*  write(Snuovo),
    write('-->'),
    write_first(Visitati),
    write('\n'), */
    generaStatiFigli(S,AltreAzioni,Visitati,PathToS,ListaStati).

generaStatiFigli(S,[_|AltreAzioni],Visitati,PathToS,ListaRis):-
    generaStatiFigli(S,AltreAzioni,Visitati,PathToS,ListaRis).

%stati in questo formato di esempio: [[[2,1,1,1],[(giu,3),(giu,4),(su,1),(giu,3),(giu,4),(giu,4),(giu,2)]],[[3,1,2,1],[(su,1),(giu,4),(su,1),(giu,3),(giu,4),(giu,4),(giu,2)]]]

%ordinamento frontiera
order(State, R) :-
    ordina_stati_by_heuristic(State, R1),
    reset(R1, R).

reset([], []).
reset([(R1, _)|R2], [R1|R3]) :- reset(R2, R3).

ordina_stati_by_heuristic([], []).
ordina_stati_by_heuristic([[H|A]|T], R) :- 
    heuristic(H, H1),
    ordina_stati_by_heuristic(T, R1),
    insert_list([H|A], H1, R1, R).

insert_list(E, H, [], [(E, H)]).
insert_list(E, H, [(E1, H1)|T], [(E, H), (E1, H1)|T]) :- H =< H1.
insert_list(E, H, [(E1, H1)|T], [(E1, H1)|R]) :- H > H1, insert_list(E, H, T, R).

%inverti([],[]).
%inverti([H|T],Res):-inverti(T,InvT),append(InvT,[H],Res).
inverti(L,InvL):-inver(L,[],InvL).
inver([],Temp,Temp).
inver([H|T],Temp,Ris):-inver(T,[H|Temp],Ris).

write_first([]).
write_first([R1|_]) :- write(R1).

%funzionante da 4 in giù quindi o 4 o 1 in quanto 2 e 3 non sono soluzioni
test():-
    risolvi([[[1,1,1],[]]], [], R),
    /*  inverti(R, R1), */
    write('\n'),
    write(R1).
