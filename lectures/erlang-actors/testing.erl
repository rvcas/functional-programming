% $Id: testing.erl,v 1.5 2013/04/11 02:20:13 leavens Exp leavens $
-module(testing).
-import(io, [write/1, nl/0, put_chars/1]).
-export([eqTest/3, gTest/4, assertTrue/1, assertFalse/1,
	 run_test/1, run_tests/1, dotests/2,
	 run_test_list/2, startTesting/1, doneTesting/1]).
-export_type([testCase/1]).

-type testCase(A) :: {'test',fun((A,A) -> boolean()),fun(() -> A),string(),A}.

% eqTest makes an equality test.
-spec eqTest(A,string(),A) -> testCase(A).
eqTest(Code,Connective,Expected) ->
    {test, fun(X,Y) -> X == Y end, Code, Connective, Expected}.

% gTest constructs a test case (in the most general way).
-spec gTest(fun((A,A)->boolean()), A, string(), A) -> testCase(A).
gTest(Comp,Code,Connective,Expected) ->
    {test, Comp, Code, Connective,Expected}.

% Assertions, which make test cases
-spec assertTrue(boolean()) -> testCase(boolean()).
-spec assertFalse(boolean()) -> testCase(boolean()).
assertTrue(B) -> {test, fun(X,Y) -> X == Y end, B, "==", true}.
assertFalse(B) -> {test, fun(X,Y) -> X == Y end, B, "==", false}.

% For running a single test case, use the following.
% The number returned is the number of test cases that failed.
-spec run_test(testCase(_)) -> integer().
run_test({test,Comp,Code,Connective,Expected}) ->
    Result = Comp(Code,Expected),
    case Result of
	true -> writeln(Code);
	false -> put_chars(failure()),
		 writeln(Code)
    end,
    put_chars("      "),
    put_chars(Connective),
    put_chars(" "),
    writeln(Expected),
    case Result of
	true -> 0;
	false -> 1
    end.

% The following will run an entire list of tests.
-spec run_tests([testCase(_)]) -> integer().
run_tests(Ts) ->  
    Errs = run_test_list(0,Ts),
    doneTesting(Errs).

% A version of run_tests with more labeling.
-spec dotests(string(),[testCase(_)]) -> integer().
dotests(Name,Ts) ->
    startTesting(Name),
    run_tests(Ts).

% A way to run a list of tests
-spec run_test_list(integer(),[testCase(_)]) -> integer().
run_test_list(Errs_so_far,[]) -> Errs_so_far;
run_test_list(Errs_so_far,[T|Ts]) ->
    Err_count = run_test(T),
    run_test_list(Errs_so_far + Err_count, Ts).


% Print a newline and a message that testing is beginning.
-spec startTesting(string()) -> integer().
startTesting(Name) -> nl(),
		      put_chars("Testing "),
		      put_chars(Name),
		      put_chars("..."),
		      nl().

% Print information about the tests.
-spec doneTesting(integer()) -> integer().
doneTesting(Fails) ->
    put_chars("Finished with "),
    write(Fails),
    put_chars(" "),
    put_chars(case Fails of
	      1 -> "failure!";
	      _ -> "failures!"
	  end),
    nl(),
    Fails.

% hidden functions below

% write Term out, followed by a newline
writeln(Term) ->
    io:format("~p~n",[Term]).

% the failure string
failure() -> "FAILURE: ".

