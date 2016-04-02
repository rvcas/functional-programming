-module(patterns_tests).
-import(patterns,[matchlist/1]).
-export([main/0]).
main() ->
    compile:file(patterns),
    io:format("matchlist([4,0,2,0]) is ~p~n",[matchlist([4,0,2,0])]).
