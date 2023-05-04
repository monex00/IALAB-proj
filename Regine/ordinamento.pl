#merge sort ricorsivo:

merge_sort([],[]).
merge_sort([X],[X]).

merge_sort(List,Sorted):-
    List=[_,_|_], # verifica che la lista abbia almeno due elementi
    divide(List,L1,L2),
    merge_sort(L1,Sorted1),
    merge_sort(L2,Sorted2),
    merge(Sorted1,Sorted2,Sorted).

divide([],[],[]).
divide([X],[X],[]).
divide([X,Y|T],[X|L1],[Y|L2]):-
    divide(T,L1,L2).

merge([],L,L).
merge(L,[],L):-L\=[]. # L\=[] significa che L non è una lista vuota, \= è il not unificatore, quindi L\=[] significa che L non è vuota
merge([X|T1],[Y|T2],[X|T]):-
    X=<Y,
    merge(T1,[Y|T2],T).

merge([X|T1],[Y|T2],[Y|T]):-
    X>Y,
    merge([X|T1],T2,T).

test():-
    merge_sort([4,3,2,1,0],L),
    write(L).

ins_sort([],[]).
ins_sort([X],[X]).
#ins_sort(List, Sorted):-
  
