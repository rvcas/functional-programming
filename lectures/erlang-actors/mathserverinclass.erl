%% $Id: mathserver.erl,v 1.1 2013/04/04 20:44:02 leavens Exp $
-module(mathserverinclass).
-export([start/0]).

start() ->
    spawn(fun mserver/0).

mserver() ->
    receive {Pid, compute, Funs, Arg} ->
	    Pid!{ok,accumulate(Funs,Arg)},
	    mserver()
    end.

accumulate(Funs,Arg) ->
    lists:foldr(fun (Nm,Res) ->
			math:Nm(Res)
		end,
		Arg,
		Funs).
