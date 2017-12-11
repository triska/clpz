/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Relation between a natural number N and its factorial F.

   CLP(Z) constraints allow for a concise declarative solution that
   can be used in all directions.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- use_module(clpz).

n_factorial(0, 1).
n_factorial(N, F) :-
        N #> 0,
        N1 #= N - 1,
        F #= N * F1,
        n_factorial(N1, F1).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Examples:

   ?- n_factorial(47, F).
   %@ F = 258623241511168180642964355153611979969197632389120000000000 ;
   %@ false.

   ?- n_factorial(N, 1).
   %@ N = 0 ;
   %@ N = 1 ;
   %@ false.

   ?- n_factorial(N, F).
   %@ N = 0,
   %@ F = 1 ;
   %@ N = F, F = 1 ;
   %@ N = F, F = 2 ;
   %@ N = 3,
   %@ F = 6 .
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */