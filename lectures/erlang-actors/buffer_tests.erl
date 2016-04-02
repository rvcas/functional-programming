% $Id: buffer_tests.erl,v 1.1 2013/11/08 12:02:43 leavens Exp leavens $
-module(buffer_tests).
-export([main/0]).
-import(buffer,[start/1,add/1,fetch/1]).
-import(testing,[eqTest/3,dotests/2]).

-spec main() -> integer().
main() ->
    dotests("buffer_tests $Revision: 1.1 $", tests()).

-spec tests() -> [testing:testCase(any())].
tests() ->
    B1 = buffer:start(0),
    B2 = buffer:start(1),
    [eqTest(fetch(B1),"==",0),
     eqTest(fetch(B2),"==",1),
     % wrapping side effecting calls to add in a function call
     (fun() -> add(B1), add(B1), eqTest(fetch(B1),"==",2) end)(),
     eqTest(fetch(B2),"==",1),
     (fun() -> add(B2), eqTest(fetch(B2),"==",2) end)(),
     eqTest(fetch(B1),"==",2)
    ].
