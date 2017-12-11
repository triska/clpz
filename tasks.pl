/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Task scheduling example.

   Written May 2016 by Markus Triska (triska@metalevel.at)
   Public domain code.

   The cumulative/2 constraint is used to express non-overlapping
   tasks with a resource consumption limit. The min/1 labeling option
   is used to find schedules that minimize the total duration.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- use_module(clpz).
:- use_module(library(lists)).

tasks(Tasks, Starts, End) :-
        Tasks = [task(_,3,_,1,_),
                 task(_,4,_,1,_),
                 task(_,2,_,1,_),
                 task(_,3,_,1,_)],
        maplist(task_start, Tasks, Starts),
        Starts ins 0..100,
        cumulative(Tasks, [limit(2)]),
        foldl(max_end, Tasks, 0, End).

task_start(task(Start,_,_,_,_), Start).

max_end(task(_,_,End,_,_), E0, E) :-
        E #= max(E0, End).

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
   ?- tasks(Tasks, Starts, End), labeling([min(End)], Starts).
   %@ Tasks = [task(0, 3, 3, 1, _G32), task(0, 4, 4, 1, _G41), task(4, 2, 6, 1, _G50), task(3, 3, 6, 1, _G59)],
   %@ Starts = [0, 0, 4, 3],
   %@ End = 6 .
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */