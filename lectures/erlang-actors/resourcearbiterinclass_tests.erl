% $Id: resourcearbiter_tests.erl,v 1.3 2013/11/15 14:26:20 leavens Exp leavens $
-module(resourcearbiterinclass_tests).
-export([main/0]).
-import(resourcearbiterinclass,[start/0]).
-import(resourcearbiterclientinclass,[check/1,reserve/1,release/1,critical/2]).
-import(testing,[startTesting/1,run_tests/1,eqTest/3,dotests/2]).

main() ->
    compile:file(resourcearbiterinclass),
    compile:file(resourcearbiterclientinclass),
    startTesting("resourcearbiter_tests $Revision: 1.3 $"),
    RA1 = start(),
    RA2 = start(),
    run_tests(makeTests(RA1,RA2)).

-spec makeTests(pid(),pid()) -> [testing:testCase(atom())].
makeTests(RA1,RA2) ->
    [eqTest(check(RA1),"==",free),
     eqTest(check(RA2),"==",free),
     begin
	 reserve(RA1),
	 FirstCheck = check(RA1), % inUse
	 SecondCheck = check(RA2), % free
	 release(RA1),
	 ThirdCheck = check(RA1), % free
	 eqTest([FirstCheck, SecondCheck, ThirdCheck], 
		"==", [inUse, free, free])
     end,
     begin
	 critical(RA2,fun () -> eqTest(check(RA2),"==",inUse) end),
	 CheckRA2 = check(RA2), % free
	 reserve(RA2),
         CheckAgain = check(RA2), % inUse
	 release(RA2),
         Check3 = check(RA2), % free
	 eqTest([CheckRA2, CheckAgain, Check3], "==", [free, inUse, free])
     end,
     begin
	 reserve(RA2),
	 RA2Status0 = check(RA2), % inUse
	 CId = spawn(fun () -> clientaction(RA2) end),
	 RA2Status1 = check(RA2), % inUse still
	 release(RA2),
	 RA2Status3 = check(RA2), % inUse
	 CId ! {self(), status},
	 RA2Status4 = receive {CId, Status} -> Status end, % inUse
	 RA2Status5 = check(RA2),
	 eqTest([RA2Status0, RA2Status1, RA2Status3, RA2Status4, RA2Status5],
		"==", [inUse, inUse, inUse, inUse, free])
     end
    ].

clientaction(RA) ->
    critical(RA, fun () -> 
			 receive {Pid, status} -> 
				 Pid ! {self(), check(RA)} 
			 end
		 end).
    %%io:format("finished critical section~n",[]).
