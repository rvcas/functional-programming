-module(countserver).
-export([start/1,cserver/1,add/1,get/1]).
% The state of this server is an integer.
start(State) ->
    spawn(?MODULE, cserver, [State]).

cserver(State) ->
    io:format("cserver's state is: ~w~n", [State]),
    receive
	{add} ->
	    cserver(State+1);
	{Pid,get} ->
	    Pid ! {value_is, State},
	    cserver(State)
    end.

add(Server) ->
    Server ! {add},
    ok.

get(Server) ->
    Server ! {self(), get},
    receive
	{value_is, Val} ->
	    Val
    end.

	
