prova(Cammino):-
    iniziale(S0),
    risolvi([[S0,[]]],[],CamminoAlContrario),
    inverti(CamminoAlContrario,Cammino),
    write(Cammino).
    

% risolvi([[S,PathToS]|Coda],Visitati,Cammino):-

risolvi([[S,PathToS]|_],_,PathToS):-
    findall(finale(S),finale(S),L),
    length(L,Len),
    Len > 0,!.

risolvi([[S,PathToS]|Coda],Visitati,Cammino):-
    % length(Cammino, Costo),
    CostInc is 0,
    findall([Az, H], (applicabile(Az,S), trasforma(Az, S, Snuovo), calcolaEuristica(Snuovo, CostInc, H)), ListaAzioniEuristiche),
    % write(ListaAzioniEuristiche), nl,
    sort(2, @=<, ListaAzioniEuristiche, SortedAzioniEuristiche),
    generaStatiFigli(S, SortedAzioniEuristiche, Visitati, PathToS, ListaNuoviStati),
    append(Coda,ListaNuoviStati,NuovaCoda),
    risolvi(NuovaCoda,[S|Visitati],Cammino).

generaStatiFigli(_,[],_,_,[]):-!.
generaStatiFigli(S,[[Az,_]|AltreAzioni],Visitati,PathToS,[[Snuovo,[Az|PathToS]]|ListaStati]):-
    trasforma(Az,S,Snuovo),
    \+member(Snuovo,Visitati),!,
    generaStatiFigli(S,AltreAzioni,Visitati,PathToS,ListaStati).
generaStatiFigli(S,[_|AltreAzioni],Visitati,PathToS,ListaRis):-
    generaStatiFigli(S,AltreAzioni,Visitati,PathToS,ListaRis).

inverti(L,InvL):-inver(L,[],InvL).
inver([],Temp,Temp).
inver([H|T],Temp,Ris):-inver(T,[H|Temp],Ris).

% Calcola la l'euristica per il finale migliore, quello stimato più vicino 
calcolaEuristica(pos(X,Y), Costo, H) :-
  findall(finale(pos(Xf, Yf)),finale(pos(Xf, Yf)), [Testa | Coda]),
  returnMaggiore(pos(X,Y), [Testa | Coda], Costo, H), !.

returnMaggiore(pos(X,Y), [finale(pos(Xf, Yf)) | []], Costo, H) :- H is abs(X - Xf) + abs(Y - Yf) + Costo, !.
returnMaggiore(pos(X,Y), [finale(pos(Xf, Yf)) | Coda], Costo, H) :-
  returnMaggiore(pos(X,Y), Coda, Costo, H1),
  H2 is abs(X - Xf) + abs(Y - Yf) + Costo,
  H1 >= H2,
  H is H2.

returnMaggiore(pos(X,Y), [finale(pos(Xf, Yf)) | Coda], Costo, H) :-
    returnMaggiore(pos(X,Y), Coda, Costo, H1),
    H2 is abs(X - Xf) + abs(Y - Yf) + Costo,
    H1 < H2,
    H is H1.
 

euristica(pos(X,Y), H) :- finale(pos(Xf, Yf)), H is abs(X - Xf) + abs(Y - Yf).

