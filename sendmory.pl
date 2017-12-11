/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Cryptoarithmetic puzzle: Assign one of the digits 0,..,9 to each of
   the letters S,E,N,D,M,O,R and Y in such a way that the following
   calculation is valid, and no leading zeroes appear.

   Written 2007 by Markus Triska (triska@metalevel.at)
   Public domain code.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- use_module(clpz).

puzzle([S,E,N,D] + [M,O,R,E] = [M,O,N,E,Y]) :-
        Vars = [S,E,N,D,M,O,R,Y],
        Vars ins 0..9,
        all_different(Vars),
                  S*1000 + E*100 + N*10 + D +
                  M*1000 + O*100 + R*10 + E #=
        M*10000 + O*1000 + N*100 + E*10 + Y,
        M #\= 0, S #\= 0.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Examples:

   ?- puzzle(As+Bs=Cs).
   %@ As = [9, X1, X2, X3],
   %@ Bs = [1, 0, X4, X1],
   %@ Cs = [1, 0, X2, X1, X5],
   %@ X1 in 4..7,
   %@ all_different([9, X1, X2, X3, 1, 0, X4, X5]),
   %@ 91*X1+X3+10*X4#=90*X2+X5,
   %@ X2 in 5..8,
   %@ X3 in 2..8,
   %@ X4 in 2..8,
   %@ X5 in 2..8.

   ?- puzzle(As+Bs=Cs), label(As).
   %@ As = [9, 5, 6, 7],
   %@ Bs = [1, 0, 8, 5],
   %@ Cs = [1, 0, 6, 5, 2] ;
   %@ false.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
