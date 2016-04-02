-module(bufferinclass).
-export([start/0, loop/1, add/2, fetch/1]).

start() ->
    InitList = [],
    spawn(?MODULE, loop, [InitList]).

% The state of the server is a list of the values
% added to the buffer and not yet fetched.
% The first element of the list is what will be 
% returned by fetch next.
loop(List) ->
    receive
	{Pid, fetch} when List =/= [] ->
	    case List of
		([V|Vs]) ->
		    Pid ! {self(), value_is, V},
		    loop(Vs)
	    end;
	{Pid, add, Val} ->
	    Pid ! {self(), added},
	    loop(List ++ [Val])
    end.

%% Functions for the convenience of clients
add(BuffId, Val) ->
    BuffId ! {self(), add, Val},
    receive
	{BuffId, added} ->
	    ok
    end.

fetch(BuffId) ->
    BuffId ! {self(), fetch},
    receive
	{BuffId, value_is, V} ->
	    V
    end.
    
