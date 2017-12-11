/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Magic Square CLP(FD) formulation.
   Written 2015 by Markus Triska (triska@metalevel.at)
   Public domain code.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- use_module(clpz).
:- use_module(library(lists)).

magic_square(N, Square) :-
        length(Square, N),
        maplist(same_length(Square), Square),
        append(Square, Vs),
        Sq #= N^2,
        Vs ins 1..Sq,
        all_different(Vs),
        Sum #= N*(Sq + 1) // 2,
        maplist(sum_eq(Sum), Square),
        transpose(Square, TSquare),
        maplist(sum_eq(Sum), TSquare),
        square_diagonal(Square, Ds),
        sum_eq(Sum, Ds),
        reverse(Square, RSquare),
        square_diagonal(RSquare, RDs),
        sum_eq(Sum, RDs).

sum_eq(Sum, List) :- sum(List, #=, Sum).

square_diagonal(Rows, Ds) :- foldl(diagonal, Rows, Ds, [], _).

diagonal(Row, D, Prefix0, Prefix) :-
        append(Prefix0, [D|_], Row),
        same_length([_|Prefix0], Prefix).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   foldl/5
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

foldl(Goal_4, Ks, Ls, A0, A) :-
        foldl_(Ks, Ls, Goal_4, A0, A).

foldl_([], [], _, A, A).
foldl_([K|Ks], [L|Ls], G_4, A0, A) :-
        call(G_4, K, L, A0, A1),
        foldl_(Ks, Ls, G_4, A1, A).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Examples:

   ?- magic_square(N, S), append(S, Vs), label(Vs), maplist(portray_clause, S).
   %@ N = 0,
   %@ S = Vs, Vs = [] ;
   %@ [1].
   %@ N = 1,
   %@ S = [[1]],
   %@ Vs = [1] ;
   %@ [2,7,6].
   %@ [9,5,1].
   %@ [4,3,8].
   %@ N = 3,
   %@ S = [[2, 7, 6], [9, 5, 1], [4, 3, 8]],
   %@ Vs = [2, 7, 6, 9, 5, 1, 4, 3, 8] .

   ?- magic_square(4, S), append(S, Vs), label(Vs), maplist(portray_clause, S).
   %@ [1,2,15,16].
   %@ [12,14,3,5].
   %@ [13,7,10,4].
   %@ [8,11,6,9].
   %@ S = [[1, 2, 15, 16], [12, 14, 3, 5], [13, 7, 10, 4], [8, 11, 6, 9]],
   %@ Vs = [1, 2, 15, 16, 12, 14, 3, 5, 13|...] .
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
