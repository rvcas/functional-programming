%% $Id: mathserver.erl,v 1.1 2013/04/04 20:44:02 leavens Exp $
-module(mathserver).
-export([start/0]).

start() ->
    spawn(fun mserver/0).

mserver() ->
    receive {Pid, compute, Funs, Arg} ->
	    Pid!{ok,accumulate(lists:reverse(Funs),Arg)},
	    mserver()
    end.

accumulate([],Acc) ->
    Acc;
accumulate([F|Fs],Acc) ->
    accumulate(Fs,math:F(Acc)).
