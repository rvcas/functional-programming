% $Id: printer.erl,v 1.1 2013/04/04 20:44:02 leavens Exp $
-module(printer).
-export([start/1, init/1]).

% The state of the printer consists of a tuple with 2 Pids:
%   {Me, Spooler}
% where Me is this server's Pid, and Spooler is the Pid of the spooler.

start(Spooler) ->
    spawn(printer, init, [Spooler]).

init(Spooler) ->
    loop({self(), Spooler}).

loop({Me, Spooler}) ->
    grab(Spooler, Me),
    loop({Me, Spooler}).

grab(Spooler, Me) ->
    Spooler!{Me, grab},
    receive
	{job, Str, N} ->
	    io:format("JOB ~p~n", [N]),
	    io:format("~s~n", [Str]);
	Msg -> io:format("printer got bad message: ~p~n", [Msg])
    after 900000 ->
	    io:format("printer timed out!~n")
    end.
