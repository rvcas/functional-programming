-module(resourcearbiterinclass).
-export([start/0, arbiter/1]).

% The state is
%    a queue of Pids of the waiting processes,
%       which is represented by a list,
%       where the head of the list is the next process
%       to get the resource, and
%    a status (free or inUse)

% invariant: when status is free, then queue is [],
% and no process in the Queue is using the resource

start() ->
    spawn(?MODULE, arbiter, [{[], free}]).

arbiter({Queue, Status}) ->
    % io:format("arbiter running with queue ~p~n", [Queue]),
    % io:format("and status: ~p~n", [Status]),
    receive
	{Pid, status} ->
	    Pid ! {self(), status_is, Status},
	    arbiter({Queue, Status});
	{Pid, reserve} ->
	    case Status of
		free ->
		    Pid ! {self(), reserved},
		    arbiter({Queue, inUse});
		inUse ->
		    arbiter({Queue ++ [Pid], Status})
	    end;
	{Pid, release} ->
	    Pid! {self(), thanks},
	    case Queue of
		[P|Ps] ->
		    P ! {self(), reserved},
		    arbiter({Ps, inUse});
		[] ->
		    arbiter({[], free})
	    end
    end.
