% $Id: hailstone.erl,v 1.2 2013/04/14 14:29:28 leavens Exp leavens $
-module(hailstone).
-export([h/1,trajectoryTo1/1,hailstoneMax/1, steps/1, stoppingTime/1,
	graph/2, peaks/1, oddsTo/1, graphMaxPeaksTo/1, graphStoppingPeaksTo/1]).

% The basic h function
-spec h(pos_integer()) -> pos_integer().
h(N) -> 
    if N rem 2 =:= 1 -> (3*N+1) div 2;
       true -> N div 2
    end.

% returns the trajectory of the number N: [N, h(N), h(h(N)), ... 1]
-spec trajectoryTo1(pos_integer()) -> [pos_integer()].
trajectoryTo1(N) -> 
    if N > 1 -> [N|trajectoryTo1(h(N))];
       true -> [N]
    end.

% return the maximum number reached by N in its trajectory
-spec hailstoneMax(pos_integer()) -> pos_integer().
hailstoneMax(1) -> 1;
hailstoneMax(N) -> hailstoneMax(h(N),N).
-spec hailstoneMax(pos_integer(),pos_integer()) -> pos_integer().
hailstoneMax(N,Largest) ->
    if N > 1 ->
	    hailstoneMax(h(N),max(N,Largest));
       true ->
	    Largest
    end.

% steps is the number of steps a number takes to get to 1
% The algorithm is not very efficient in this case, 
% because we are usually interested in stopping time instead.
-spec steps(pos_integer()) -> pos_integer().
steps(N) -> length(trajectoryTo1(N)).

% stopping time is the number of iterations of h needed to fall below N.
-spec stoppingTime(pos_integer()) -> pos_integer().
stoppingTime(1) -> 0;
stoppingTime(N) -> stoppingTime(N, N, 0).
stoppingTime(N, OriginalN, Count) ->
    if N < OriginalN -> Count;
       true -> stoppingTime(h(N), OriginalN, Count+1)
    end.

% graph produces a list of argument-value pairs
-spec graph(fun((A) -> B), [A]) -> [{A,B}].
graph(F, Lst) -> lists:map(fun(X) -> {X, F(X)} end, Lst).

% peaks gives the argument-value pairs that have 
% a higher value than any previously seen.
-spec peaks([{A,B}]) -> [{A,B}].		 
peaks(GraphList) ->
    peaks(GraphList,-1).
peaks([],_MaxSoFar) -> [];
peaks([{Arg,Val}|Rest],MaxSoFar) -> 
    if Val > MaxSoFar ->
	    [{Arg,Val}|peaks(Rest,Val)];
       true -> peaks(Rest,MaxSoFar)
    end.

% return the list of odd numbers [1,3,5,..., N]    
-spec oddsTo(pos_integer()) -> [pos_integer()].
oddsTo(N) -> oddsTo(1,N).
oddsTo(M,N) ->
    if M < N ->
	    [M|oddsTo(M+2,N)];
       M =:= N -> [N];
       true -> []
    end.

% return a list of peak argument-value pairs for hailstoneMax up to N.
graphMaxPeaksTo(N) ->
    peaks(graph(fun hailstoneMax/1, oddsTo(N))).
% return a list of peak argument-value pairs for stoppingTime up to N.
graphStoppingPeaksTo(N) ->
    peaks(graph(fun stoppingTime/1, oddsTo(N))).
    
