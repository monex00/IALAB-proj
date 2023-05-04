% 20 squadre
% 38 partite, 19 andata 19 ritorno
% ogni squadra ha un suo stadio 
% 2 squadre su 20 condividono lo stesso stadio ;fiorentina;inter;verona;juventus;lazio;lecce;milan;monza;napoli;roma;salernitana;sampdoria;sassuolo;spezia;torino;udinese


squadra(atalanta;bologna;cremonese;empoli).
stadio(1..4).

giocaIn(atalanta,1).
giocaIn(bologna,3).
giocaIn(cremonese,2).
giocaIn(empoli,4).
% giocaIn(fiorentina,5).
% giocaIn(inter,6).
% giocaIn(verona,7).
% giocaIn(lazio,8).
% giocaIn(lecce,9).
% giocaIn(milan,10).
% giocaIn(monza,11).
% giocaIn(napoli,12).
% giocaIn(udinese,13).
% giocaIn(roma,14).
% giocaIn(salernitana,15).
% giocaIn(sampdoria,16).
% giocaIn(sassuolo,17).
% giocaIn(spezia,18).
% giocaIn(torino,19).
% giocaIn(juventus,19).

giornataA(1..3).
giornataR(20..38).

% per ogni squadra(x) gioca contro ogni squadra(y) nello stadio(z) con y<>x e z<>w dove w è lo stadio di y
% x non gioca in andata contro y in w e non giocano in ritorno in z -> controllo che non faccia un ritorno nelle andate e che non ci sia un ritorno che sia uguale all'andata, ovvero che avviene nello stesso stadio
0 {giocaControA(X,Y,Z):squadra(Y),stadio(Z),giocaIn(X,Z),X<>Y,stadio(W),giocaIn(Y,W),not giocaControA(X,Y,W),not giocaControA(Y,X,W),not giocaControR(X,Y,Z)} 3:-squadra(X).


% {giocaControA(X,Y,Z):squadra(Y),stadio(Z),giocaIn(X,Z), X<>Y,stadio(W),giocaIn(Y,W),W==Z,not giocaControA(Y,X,Z)} 1:-squadra(X).

% permette di gestire l'eccezzione delle due solo squadre con stadio uguale
giocaControA(X,Y,Z):-squadra(X),squadra(Y),stadio(Z),giocaIn(X,Z), X<>Y,stadio(W),giocaIn(Y,W),W==Z,not giocaControA(Y,X,Z).

#show giocaControA/3. 

% conta le partite giocate in andata
quantiA(C):- C = #count{giocaControA(X,Y,Z):squadra(X),squadra(Y),stadio(Z),giocaControA(X,Y,Z)}.

% vincolo i modelli a 6 partite in andata
:-quantiA(C),C<6.
 
 #show quantiA/1.

%GIRONI
% ogni partita di andata è assegnata ad un girone
 1 {giocaControAin(X,Y,Z,G):giornataA(G)} 1:- squadra(X),squadra(Y),stadio(Z),giocaControA(X,Y,Z).

% 2 partite per giornata, nella stessa giornata non giocano le stesse squadre nello stesso stadio
 2 {giocaControAin(X,Y,Z,G):squadra(X),squadra(Y),stadio(Z),stadio(W),squadra(D),squadra(T),giocaControAin(D,T,W,G),giocaControA(X,Y,Z),W<>Z,D<>X,T<>Y,T<>X,D<>Y} 2:- giornataA(G).

% :-giornataA(G),squadra(X),squadra(Y),squadra(D),squadra(T),stadio(Z),stadio(W),giocaIn(D,W),giocaIn(X,Z),giocaControAin(D,T,W,G),giocaControAin(X,Y,Z,G),W==Z.

  #show giocaControAin/4.

% giocaControA(X,Y,Z):-squadra(Y),squadra(X),stadio(Z),giocaIn(Y,Z), X<>Y, not giocaControA(Y,X,Z).


% stessa cosa per il ritorno
0 {giocaControR(Y,X,Z):squadra(X),stadio(Z),giocaIn(Y,Z), X<>Y,stadio(W),giocaIn(X,W),not giocaControR(Y,X,W),not giocaControR(X,Y,W),not giocaControA(Y,X,Z)} 3:-squadra(Y).


#show giocaControR/3.

giocaControR(Y,X,Z):-squadra(Y),squadra(X), stadio(Z),giocaIn(Y,Z), X<>Y,stadio(W),giocaIn(X,W),W==Z,not giocaControR(X,Y,Z).

quantiR(C):- C = #count{giocaControR(X,Y,Z):squadra(X),squadra(Y),stadio(Z),giocaControR(X,Y,Z)}.
:-quantiR(C),C<6.

#show quantiR/1.

% giocaControA(X,Y,Z):-squadra(X),squadra(Y),stadio(Z), not giocaControR(X,Y,Z).
