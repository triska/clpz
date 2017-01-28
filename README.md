# CLP(Z) &mdash; Constraint Logic Programming over Integers

This repository contains information about **CLP(Z)**.

CLP(Z) requires **SICStus Prolog**.

The latest version of `library(clpz)` is available from:
[**metalevel.at/clpz.pl**](http://www.metalevel.at/clpz.pl)

The present implementation builds upon a decade of experience with a
precursor library which I developed for a different Prolog system.
CLP(Z) is the *more recent* and conceptually *more advanced*
implementation. To keep track of recent developments, use&nbsp;CLP(Z).

**Current developments**:

  - increase [**logical purity**](https://www.metalevel.at/prolog/purity) of the implementation
  - work on *stronger propagation*
  - *correct* all reported issues.
  - *add* new constraints.

CLP(Z) is being developed for inclusion in
[**GUPU**](http://www.complang.tuwien.ac.at/ulrich/gupu/).

An introduction to declarative integer arithmetic is available from
[**metalevel.at/prolog/clpfd**](https://www.metalevel.at/prolog/clpfd)

For more information about pure Prolog, read [**The Power of Prolog**](https://www.metalevel.at/prolog).

## Using CLP(Z) constraints

CLP(Z) is an instance of the general CLP(.) scheme, extending logic
programming with reasoning over specialised domains.

In the case of CLP(Z), the domain is the set of **integers**. CLP(Z)
is a generalisation of CLP(FD), which already ships with
SICStus&nbsp;Prolog.

CLP(Z) constraints like `(#=)/2`, `(#\=)/2`, and `(#<)/2` are meant
to be used as pure alternatives for lower-level arithmetic primitives
over integers. Importantly, they can be used in *all directions*.

For example, consider a rather typical definition of `n_factorial/2`:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N #> 0,
            N1 #= N - 1,
            n_factorial(N1, F1),
            F #= N * F1.

CLP(Z) constraints allow us to quite *freely exchange* the order
of&nbsp;goals, obtaining for example:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N #> 0,
            N1 #= N - 1,
            F #= N * F1,
            n_factorial(N1, F1).

This works in all directions, for example:

    ?- n_factorial(47, F).
    258623241511168180642964355153611979969197632389120000000000 ;
    false.

and also:

    ?- n_factorial(N, 1).
    N = 0 ;
    N = 1 ;
    false.

and also in the most general case:

    ?- n_factorial(N, F).
    N = 0,
    F = 1 ;
    N = F, F = 1 ;
    N = F, F = 2 ;
    N = 3,
    F = 6 .

The advantage of using `(#=)/2` to express *arithmetic equality* is
clear: It is a more general alternative for lower-level predicates.

## An impure alternative: Low-level integer arithmetic

Suppose for a moment that CLP(Z) constraints were not available in
your Prolog system, or that you do not want to use them. How do we
formulate `n_factorial/2` with more primitive integer arithmetic?

In our first attempt, we simply replace the declarative CLP(Z)
constraints by lower-level arithmetic predicates and obtain:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N > 0,
            N1 is N - 1,
            F is N * F1,
            n_factorial(N1, F1).

Unfortunately, this does not work at all, because lower-level
arithmetic predicates are *moded*: This means that their arguments
must be sufficiently instantiated at the time they are invoked. In
fact, SWI-Prolog does not even compile the above code but yields an
error at compilation time. Therefore, we must reorder the goals
and&nbsp;&mdash; somewhat annoyingly&nbsp;&mdash; change this for
example to:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N > 0,
            N1 is N - 1,
            n_factorial(N1, F1),
            F is N * F1.

Naive example queries inspired more by *functional* than by
*relational* thinking may easily mislead us into believing that this
version is working correctly:

    ?- n_factorial(6, F).
    F = 720 ;
    false.

Another example:

    ?- n_factorial(3, F).
    F = 6 ;
    false.

But what about *more general* queries? For example:

    ?- n_factorial(N, F).
    N = 0,
    F = 1 ;
    ERROR: n_factorial/2: Arguments are not sufficiently instantiated

Unfortunately, this version thus cannot be directly used to enumerate
more than one solution, which is another severe drawback in comparison
with the pure version.

You can make the deficiency a lot worse by arbitrarily adding
a&nbsp;`!/0` somewhere. Using `!/0` is a quite reliable way to destroy
almost all declarative properties of your code in most cases, and this
example is no exception:

    n_factorial(0, 1) :- !.
    n_factorial(N, F) :-
            N > 0,
            N1 is N - 1,
            n_factorial(N1, F1),
            F is N * F1.

This version appears in several places. The fact that the following
interaction *incorrectly* tells us that there is exactly one solution of
the factorial relation is apparently no cause for concern there:

    ?- n_factorial(N, F).
    N = 0,
    F = 1.

Zero and one are the only important integers in any case, if you are
mostly interested in programming at a very low level.

For more usable and general programs, I therefore recommend you stick
to CLP(Z) constraints for integer arithmetic. You can place pure
goals in any order without changing the declarative meaning of your
program, just as you would expect from logical conjunction. For
example:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N #> 0,
            N1 #= N - 1,
            n_factorial(N1, F1),
            F #= N * F1.

Reordering pure goals can change **termination properties**, but it
cannot incorrectly lead to failure where there is in fact a solution.
Therefore, we get with the above CLP(Z) version for example:

    ?- n_factorial(N, 3).
    <loops>

And now we can reason completely declaratively about the code: Knowing
that (a)&nbsp;CLP(Z) constraints are *pure* and can thus be reordered
quite liberally and (b)&nbsp;that posting CLP(Z) constraints *always
terminates*, we *know* that placing CLP(Z) constraints earlier can at
most *improve*, never *worsen* the desirable termination properties.

Therefore, we change the definition to the version shown initially:

    n_factorial(0, 1).
    n_factorial(N, F) :-
            N #> 0,
            N1 #= N - 1,
            F #= N * F1,
            n_factorial(N1, F1).

The sample query now terminates:

    ?- n_factorial(N, 3).
    false.

Using CLP(Z) constraints has allowed us to improve the termination
properties of this predicate by purely declarative reasoning.

## Acknowledgments

I am extremely grateful to:

[**Ulrich Neumerkel**](http://www.complang.tuwien.ac.at/ulrich/), who
introduced me to constraint logic programming.

[**Nysret Musliu**](http://dbai.tuwien.ac.at/staff/musliu/), my thesis
advisor, whose interest in combinatorial tasks and constraint
satisfaction highly motivated me to work in this area.

[**Mats Carlsson**](https://www.sics.se/~matsc/), the designer and
main implementor of SICStus Prolog and its superb [CLP(FD)
library](https://sicstus.sics.se/sicstus/docs/latest4/html/sicstus.html/lib_002dclpfd.html#lib_002dclpfd)
which spawned my interest in constraints.
