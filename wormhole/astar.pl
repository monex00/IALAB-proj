prova(Cammino):-
    iniziale(S0),
    risolvi([[S0,[]]],[],CamminoAlContrario),
    inverti(CamminoAlContrario,Cammino).

% risolvi([[S,PathToS]|Coda],Visitati,Cammino):-
risolvi([[S,PathToS]|_],_,PathToS):-finale(S),!.
risolvi([[S,PathToS]|Coda],Visitati,Cammino):-
    findall([Az, H], (applicabile(Az,S), trasforma(Az, S, Snuovo), euristica(Snuovo, H)), ListaAzioniEuristiche),
    sort(2, @=<, ListaAzioniEuristiche, SortedAzioniEuristiche),
    % write(SortedAzioniEuristiche), nl, nl,
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

% Esempio di funzione euristica (distanza Manhattan)
euristica(pos(X,Y), H) :- finale(pos(Xf, Yf)), H is abs(X - Xf) + abs(Y - Yf).
