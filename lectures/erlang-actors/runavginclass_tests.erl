% $Id: runavg_tests.erl,v 1.2 2013/04/17 01:04:30 leavens Exp leavens $
-module(runavginclass_tests).
-export([main/0]).
-define(RA, runavginclass).
-import(?RA, [note/1, average/0]).
-import(testing,[startTesting/1, run_tests/1, eqTest/3, dotests/2]).

main() ->
    startTesting("runavg_tests $Revision: 1.2 $"),
    compile:file(?RA),
    ?RA:start_link(),
    run_tests(tests()).

-spec tests() -> [testing:testCase(any())].
tests() ->
    [eqTest(average(),"==",0.0),
     eqTest(note(3.0),"==",ok),
     eqTest(note(4.0),"==",ok),
     eqTest(note(5.0),"==",ok),
     eqTest(average(),"==",4.0),
     eqTest(note(21.0),"==",ok),
     eqTest(average(),"==",10.0),
     eqTest(note(34.0),"==",ok),
     eqTest(average(),"==",20.0)
    ].
