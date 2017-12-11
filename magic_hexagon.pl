/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Magic Hexagon of order 3, solved with CLP(FD) constraints
   Written 2006 by Markus Triska triska@metalevel.at
   Public domain code.

   Place the integers 1,...,19 in the following grid so that the sum
   of all numbers in a straight line (there are lines of length 3, 4
   and 5) is equal to 38:

            A   B   C
          D   E   F   G
        H   I   J   K   L
          M   N   O   P
            Q   R   S
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- use_module(clpz).
:- use_module(library(lists)).

sum38(Vs) :- sum(Vs, #=, 38).

magic_hexagon(Vs) :-
        Vs = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S],
        Vs ins 1..19,
        all_different(Vs),
        maplist(sum38, [[A,B,C], [D,E,F,G], [H,I,J,K,L], [M,N,O,P], [Q,R,S],
                        [H,D,A], [M,I,E,B], [Q,N,J,F,C], [R,O,K,G], [S,P,L],
                        [C,G,L], [B,F,K,P], [A,E,J,O,S], [D,I,N,R], [H,M,Q]]).

%?- magic_hexagon(Vs), labeling([ff], Vs).
%@ Vs = [3, 17, 18, 19, 7, 1, 11, 16, 2, 5, 6, 9, 12, 4, 8, 14, 10, 13, 15] ;
%@ Vs = [3, 19, 16, 17, 7, 2, 12, 18, 1, 5, 4, 10, 11, 6, 8, 13, 9, 14, 15] .
%@ etc.
