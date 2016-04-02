-module(factorialserverinclass_tests).
-export([main/0,tests/0]).
-import(testing, [eqTest/3, dotests/2]).
-import(stateless1, [start/2]).
-import(factorialserverinclass, [fact/1]).

-define(FSI, factorialserverinclass).
main() ->
    compile:file(?FSI),
    start(factserver, ?FSI),
    dotests("factorialserverinclass tests", tests()).

tests() ->
    [eqTest((fun() -> fact(3) end)(), "==", 6),
     eqTest((fun() -> fact(4) end)(), "==", 24),
     eqTest((fun() -> fact(5) end)(), "==", 120)
     ].
