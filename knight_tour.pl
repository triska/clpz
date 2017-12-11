/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Closed Knight's Tour.

   Written by Markus Triska (triska@metalevel.at) Nov. 2nd 2009
   Public domain code.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- use_module(clpz).
:- use_module(library(lists)).

n_tour(N, Ts) :-
        length(Ts, N),
        maplist(same_length(Ts), Ts),
        append(Ts, Vs),
        successors(Vs, N, 1),
        circuit(Vs).

successors([], _, _).
successors([V|Vs], N, K0) :-
        findall(Num, n_k_next(N, K0, Num), [Next|Nexts]),
        foldl(num_to_dom, Nexts, Next, Dom),
        V in Dom,
        K1 #= K0 + 1,
        successors(Vs, N, K1).

num_to_dom(N, D0, D0\/N).

n_x_y_k(N, X, Y, K) :- [X,Y] ins 1..N, K #= N*(Y-1) + X.

n_k_next(N, K, Next) :-
        n_x_y_k(N, X0, Y0, K),
        [DX,DY] ins -2 \/ -1 \/ 1 \/ 2,
        abs(DX) + abs(DY) #= 3,
        [X,Y] ins 1..N,
        X #= X0 + DX,
        Y #= Y0 + DY,
        n_x_y_k(N, X, Y, Next),
        label([DX,DY]).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   foldl/4
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

foldl(Goal_3, Ls, A0, A) :-
        foldl_(Ls, Goal_3, A0, A).

foldl_([], _, A, A).
foldl_([L|Ls], G_3, A0, A) :-
        call(G_3, L, A0, A1),
        foldl_(Ls, G_3, A1, A).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Text display.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

print_tour(Ts) :- print_tour(Ts, 3).

print_tour(Ts, I) :-
        tour_enumeration(Ts, Es),
        phrase(format_string(Ts, I, I), Fs),
        maplist(format(Fs), Es).

format_(Fs, Args, Xs0, Xs) :- format(codes(Xs0,Xs), Fs, Args).

format_string([], _, _) --> "\n".
format_string([_|Rest], N0, I) --> "~t~w~", call(format_("~w|", [N0])),
        { N1 #= N0 + I },
        format_string(Rest, N1, I).

tour_enumeration(Ts, Es) :-
        same_length(Ts, Es),
        maplist(same_length(Ts), Es),
        append(Ts, Vs),
        append(Es, Ls),
        foldl(vs_enumeration(Vs, Ls), Vs, 1-1, _).

vs_enumeration(Vs, Ls, _, V0-E0, V-E) :-
        E #= E0 + 1,
        nth1(V0, Ls, E0),
        nth1(V0, Vs, V).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Examples:

   ?- n_tour(N, Ts), maplist(label, Ts).
   %@ N = 0,
   %@ Ts = [] ;
   %@ N = 6,
   %@ Ts = [[9, 10, 7, 8, 16, 17], ..., , [27, 28, 20|...]] .

   ?- n_tour(6, Ts), maplist(label, Ts), print_tour(Ts).
   %@   1 30 25  6  3 32
   %@  26  7  2 31 24  5
   %@  29 36 27  4 33 16
   %@   8 19 34 15 12 23
   %@  35 28 21 10 17 14
   %@  20  9 18 13 22 11

   ?- time((n_tour(8, Ts), append(Ts, Vs), labeling([ff], Vs))).
   %@ % 4,191,339 inferences, 0.790 CPU in 0.807 seconds (98% CPU, 5305492 Lips)

   ?- n_tour(8, Ts), append(Ts, Vs), labeling([ff], Vs), print_tour(Ts).
   %@   1  4 63 28 31 26 19 22
   %@  62 29  2  5 20 23 32 25
   %@   3 64 39 30 27 56 21 18
   %@  38 61  6 53 40 33 24 55
   %@   7 52 41 34 57 54 17 46
   %@  60 37  8 49 44 47 14 11
   %@  51 42 35 58  9 12 45 16
   %@  36 59 50 43 48 15 10 13
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
