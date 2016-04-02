% $Id: gauge_server_tests.erl,v 1.1 2013/04/17 00:25:59 leavens Exp leavens $
-module(gauge_server_tests).
-export([main/0]).
-import(gauge_server,[count/0,value/0,changeTo/1]).
-import(testing,[startTesting/1,run_tests/1,eqTest/3,dotests/2]).

main() ->
    startTesting("gauge_server_tests $Revision: 1.1 $"),
    server1:start(gauge_server, gauge_server),
    run_tests(tests()).

-spec tests() -> [testing:testCase(any())].
tests() ->
    [eqTest(value(),"==",0),
     eqTest(count(),"==",counted),
     eqTest(value(),"==",1),
     eqTest(count(),"==",counted),
     eqTest(value(),"==",2),
     eqTest(changeTo(17),"==",ok),
     eqTest(value(),"==",17),
     eqTest(count(),"==",counted),
     eqTest(value(),"==",18)
    ].
