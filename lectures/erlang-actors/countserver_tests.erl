% $Id: countserver_tests.erl,v 1.1 2013/11/08 12:02:43 leavens Exp leavens $
-module(countserver_tests).
-export([main/0]).
-import(countserver,[start/1,add/1,get/1]).
-import(testing,[eqTest/3,dotests/2]).
-compile({no_auto_import,[get/1]}).

-spec main() -> integer().
main() ->
    dotests("countserver_tests $Revision: 1.1 $", tests()).

-spec tests() -> [testing:testCase(any())].
tests() ->
    CS1 = countserver:start(0),
    CS2 = countserver:start(1),
    [eqTest(get(CS1),"==",0),
     eqTest(get(CS2),"==",1),
     % wrapping side effecting calls to add in a function call
     (fun() -> add(CS1), add(CS1), eqTest(get(CS1),"==",2) end)(),
     eqTest(get(CS2),"==",1),
     (fun() -> add(CS2), eqTest(get(CS2),"==",2) end)(),
     eqTest(get(CS1),"==",2)
    ].
