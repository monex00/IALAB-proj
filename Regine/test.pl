%state = [R1, R2, R3, R4, R5, R6, R7, R8] rappesenta la colonna della regina allariga R1, R2, R3, R4, R5, R6, R7, R8

% due regina si minacciano se si trovano sulla stessa riga, stessa colonna o stessa diagonale

minaccia_colonna(R1, R2, State) :- nth1(R1, State, C1), nth1(R2, State, C2), C1 = C2.

minaccia_diagonale(R1, R2, State) :- nth1(R1, State, C1), nth1(R2, State, C2), D is abs(C1 - C2), R is abs(R1 - R2), D = R.

minaccia(R1, R2, State) :- 
    minaccia_colonna(R1, R2, State);
    minaccia_diagonale(R1, R2, State).
    
%scorro state a coppie e verifico se le regine si minacciano con findall
minacciate(R, State) :- 
    findall((R1, R2), (nth1(R1, State, _), nth1(R2, State, _), R1 < R2, minaccia(R1, R2, State)), R),
    length(R, N),
    write(N).


heuristic(State, H) :- 
    findall((R1, R2), (nth1(R1, State, _), nth1(R2, State, _), R1 < R2, minaccia(R1, R2, State)), R),
    length(R, H1),
    length(State, H2),
    H is H1 + H2.

goal(State) :- 
    findall((R1, R2), (nth1(R1, State, _), nth1(R2, State, _), R1 < R2, minaccia(R1, R2, State)), R),
    length(R, 0).
