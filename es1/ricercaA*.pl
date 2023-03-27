% Definizione dell'euristica: conta il numero di sintomi mancanti nella storia clinica del paziente
h(State, H) :-
    patient_history(Patient, History),
    findall(Symptom, (symptom(Symptom), not(member(Symptom, History))), MissingSymptoms),
    length(MissingSymptoms, H).

% Definizione della funzione di transizione: seleziona un sintomo non ancora presente nella storia clinica del paziente
transition(State, NextState, Cost) :-
    patient_history(Patient, History),
    symptom(Symptom),
    not(member(Symptom, History)),
    append(History, [Symptom], NewHistory),
    NextState = [Patient, NewHistory],
    Cost is 1.

% Definizione della funzione di costo: tutti i passi costano 1
cost(_, _, 1).

% Implementazione dell'algoritmo A*
astar(Start, Path) :-
    h(Start, H),
    astar([[Start, [], 0, H]], [], Path).

astar([[State, _, G, _] | _], _, Path) :-
    patient_history(_, State),
    reverse(State, Path).
astar([[State, Path, G, H] | Queue], Closed, FinalPath) :-
    findall([NextState, [State | Path], NewG, NextH],
            (transition(State, NextState, StepCost),
             NewG is G + StepCost,
             h(NextState, NextH),
             not(member([NextState, _, _, _], Closed)),
             not(member([NextState, _, _, _], Queue)),
             F is NewG + NextH),
            Successors),
    sort(Successors, SortedSuccessors),
    append(SortedSuccessors, Queue, NewQueue),
    astar(NewQueue, [[State, Path, G, H] | Closed], FinalPath).
