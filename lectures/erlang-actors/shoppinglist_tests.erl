% $Id: shoppinglist_tests.erl,v 1.1 2013/04/17 00:41:54 leavens Exp leavens $
-module(shoppinglist_tests).
-export([main/0]).
-import(shoppinglist,[add/1,getList/0,clear/0]).
-import(testing,[startTesting/1,run_tests/1,eqTest/3,dotests/2]).

main() ->
    startTesting("shoppinglist_tests $Revision: 1.1 $"),
    server1:start(shoppinglist, shoppinglist),
    run_tests(tests()).

-spec tests() -> [testing:testCase(any())].
tests() ->
    [eqTest(getList(),"==",[]),
     eqTest(add(milk),"==",added),
     eqTest(getList(),"==",[milk]),
     eqTest(add(oj),"==",added),
     eqTest(getList(),"==",[oj,milk]),
     eqTest(clear(),"==",cleared),
     eqTest(getList(),"==",[]),
     eqTest(add(turpintine),"==",added),
     eqTest(getList(),"==",[turpintine])
    ].
