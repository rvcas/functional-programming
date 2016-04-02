% from section 22.1 of Armstrong's book "Programming Erlang" (3rd ed.)
-module(server1).
-export([start/2, rpc/2]).

start(Name, Mod) ->
    register(Name, 
             spawn(fun() -> loop(Name, Mod, Mod:init()) 
                   end)).

rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
	{Name, Response} -> Response
    end.

loop(Name, Mod, State) ->
    receive
	{From, Request} ->
            {Response, NewState} = Mod:handle(Request, State),
            From ! {Name, Response},
            loop(Name, Mod, NewState)
    end.   
