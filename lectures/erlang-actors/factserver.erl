%% $Id: factserver.erl,v 1.2 2013/04/04 21:32:15 leavens Exp leavens $
-module(factserver).
-export([start/0]).
-import(factorial,[fact/1]).

start() ->
    spawn(fun server/0).

server() ->
    receive
	{Pid, compute, N} ->
	    Pid!{ok, fact(N)}
    end,
    server().

