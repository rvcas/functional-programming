% $Id: printspooler.erl,v 1.1 2013/04/04 21:38:57 leavens Exp leavens $
-module(printspooler).
-export([start/0,init/0]).

% The state of this server is a record of the form
% {queue, JobsQueue, PrinterQueue, Next}
% where JobsQueue is an ets ordered_set containing pairs of the form {J,String},
%    where J is the job number and String is the contents to be printed,
% and PrinterQueue is an ets set containing Pids for waiting printer processes,
% and Next is the number of the next job number that will be given out.

start() ->
    spawn(?MODULE, init, []).

init() ->
    % the ets tables have to be created in the new process!
    JobsQueue = ets:new(queue, [ordered_set]),
    PrinterQueue = ets:new(waiting, [set]),
    loop({queue, JobsQueue, PrinterQueue, 1}).

loop({queue, Jobs, Printers, Next}) ->
    io:format("printspooler loop: ~p~n", 
	      [{queue, ets:tab2list(Jobs), printers, ets:tab2list(Printers)}]),
    receive
	{Client, print, Str} ->
	    Client!{job_received, Next},
	    case ets:first(Printers) of
		'$end_of_table' -> % no printers waiting for work
		    ets:insert(Jobs, {Next, Str});
		Printer -> 
		    ets:delete(Printers, Printer),
		    Printer!{job, Str, Next}
	    end,
	    loop({queue, Jobs, Printers, Next+1});

	{Printer, grab} ->
	    case ets:first(Jobs) of
		'$end_of_table' -> % no jobs ready to print
		    ets:insert(Printers, {Printer});
		K -> 
		    Printer!{job, ets:lookup(Jobs, K), K},
		    ets:delete(Jobs, K)
	    end,
	    loop({queue, Jobs, Printers, Next});

	{Client, status} ->
	    Client!{status, {queue, ets:tab2list(Jobs), printers, ets:tab2list(Printers)}},
	    loop({queue, Jobs, Printers, Next})
    end.
    
