:- use_module(library(lists)).

% Heuristic function that returns the number of queen pairs that threaten each other
/*heuristic(State, H) :-
    findall((I, J), (nth0(I, State, X), nth0(J, State, Y), I \= J, abs(X - Y) =:= abs(I - J)), Threats),
    length(Threats, H1),
    length(State, N),
    H is H1 + N.
*/

% A* search algorithm
a_star(Start, Path) :-
    heuristic(Start, H),
    a_star([(Start, H, 0)], [], Path).

a_star([(State, _, G) | _], _, Path) :-
    goal(State),
    reverse(G, Path).

a_star([(State, H, G) | Open], Closed, Path) :-
    findall((Next, H1, G1), (succ(State, Next), \+ member((Next, _, _), Closed),
    G1 is G + 1, heuristic(Next, H1)), Successors),
    append(Successors, Open, Open1),
    sort(Open1, Open2),
    a_star(Open2, [(State, H, G) | Closed], Path).

% Successor function that generates all valid next states
succ(State, Next) :-
    length(State, N),
    nth1(N, State, X),
    between(1, N, Y),
    \+ member(Y, State),
    X1 is X + 1,
    Y1 is Y - 1,
    Y2 is Y + 1,
    (X1 =:= Y ; X1 =:= Y1 ; X1 =:= Y2),
    replace(State, N, Y, Next).

% Replace the N-th element of a list with a new value
replace([_|T], 1, X, [X|T]).
replace([H|T], N, X, [H|R]) :-
    N > 1,
    N1 is N - 1,
    replace(T, N1, X, R).

% Goal predicate that checks if all queens are placed without threatening each other
goal(State) :-
    minacciate(R, State),
    length(R, 0).

% Test the algorithm with a 4x4 board
test() :-
    a_star([2, 4, 1, 3], Path),
    writeln(Path).