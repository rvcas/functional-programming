-module(spawndemo).
-export([main/0]).

main() ->
    _Other = spawn(fun rest/0),
    io:format("message from process ~w~n", [self()]).

rest() ->
    timer:sleep(200),
    io:format("message from process ~w~n", [self()]).
    
