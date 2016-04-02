% from section 22.1 of Armstrong's book "Programming Erlang" (3rd ed.)
-module(stateless1).
-export([start/2, rpc/2]).

start(Name, Mod) ->
    register(Name, 
             spawn(fun() -> loop(Name, Mod) 
                   end)).

rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
	{Name, Response} -> Response
    end.

loop(Name, Mod) ->
    receive
	{From, Request} ->
            Response = Mod:handle(Request),
            From ! {Name, Response},
            loop(Name, Mod)
    end.   
