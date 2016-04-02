-module(quiz_tests).
-import(quiz,[add/2]).
-export([main/0]).
main() ->
    compile:file(quiz),
    io:format("add(3,4) is ~p~n",[add(3,4)]).
