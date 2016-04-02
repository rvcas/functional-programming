% $Id: resourcearbiter.erl,v 1.2 2013/04/24 01:03:56 leavens Exp leavens $
-module(resourcearbiter).
-export([start/0, init/0]).
-export_type([status/0]).

% The state of the resource arbiter is a tuple of the form
% {state, Status, Waiting, Next}
% where Status is of type status(),
-type status() :: free | inUse.
% Waiting is an ets ordered_set of pairs of the type {integer(), pid()},
% and Next is a pos_integer().

start() ->
    spawn(?MODULE, init, []).

init() ->
    WaitQ = ets:new(queue, [ordered_set]),
    loop({state, free, WaitQ, 1}).


loop({state, Status, Waiting, Next}) ->
    receive
	{Client, 'query'} ->
	    Client ! Status,
	    loop({state, Status, Waiting, Next});
	{Client, reserve} ->
	    case Status of
		free ->
		    Client ! reserved,
		    %% io:format("Pid ~p is now using the resource~n",[Client]),
		    loop({state, inUse, Waiting, Next});
		inUse ->
		    ets:insert(Waiting, {Next, Client}),
		    %% io:format("making ~p wait~n",[Client]),
		    loop({state, Status, Waiting, Next+1})
	    end;
	 {_Client, release} ->
	    %% assert Status == inUse
	    %% io:format("Client ~p releasing the resource~n",[Client]),
	    case ets:first(Waiting) of
		'$end_of_table' ->
		    loop({state, free, Waiting, Next});
		N ->
		    [{N, Pid}] = ets:lookup(Waiting, N),
		    Pid ! reserved,
		    ets:delete(Waiting, N),
		    %% io:format("Pid ~p is now using the resource~n",[Pid]),
		    loop({state, inUse, Waiting, Next})
	    end
    end.
