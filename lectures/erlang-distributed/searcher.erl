% $Id$
-module(searcher).
-export([start/0, init/1]).

start() ->
    spawn(searcher, init, [self()]).

init(Coordinator) ->
    
    loop(Coordinator).

loop(Coordinator) ->
    receive
	 ->
	    loop(From)
		end.

check_with_coordinator(Coordinator, {state, Interval, MPeaks, SPeaks}) ->
    Coordinator ! {self(), check_in, Interval, MPeaks, SPeaks},
    receive
	{Coordinator, search, 
	 {interval, Start, End} = Interval,
	 {max_peaks, MaxArgValPairs} = MVPeaks,
	 {stopping_time_peaks, StoppingArgValPairs} = STPeaks} ->
	    {state, {Interval, MVPeaks, STPeaks}};
	{Coordinator, continue} ->
	    {state, 
