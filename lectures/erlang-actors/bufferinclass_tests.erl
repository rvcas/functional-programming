% $Id: buffer_tests.erl,v 1.1 2013/11/08 12:02:43 leavens Exp leavens $
-module(bufferinclass_tests).
-export([main/0]).
-import(bufferinclass,[start/0,add/2,fetch/1]).
-import(testing,[eqTest/3,dotests/2]).

-spec main() -> integer().
main() ->
    compile:file(bufferinclass),
    dotests("buffer_tests $Revision: 1.1 $", tests()).

-spec tests() -> [testing:testCase(any())].
tests() ->
    B1 = bufferinclass:start(),
    B2 = bufferinclass:start(),
    [% wrapping side effecting calls to add in a function call
     (fun() -> add(B1,1), add(B1,0), eqTest(fetch(B1),"==",1) end)(),
     (fun() -> add(B2,5), add(B2,3), eqTest(fetch(B2),"==",5) end)(),
     (fun() -> add(B2,7), eqTest(fetch(B2),"==",3) end)(),
     eqTest(fetch(B1),"==",0)
    ].
