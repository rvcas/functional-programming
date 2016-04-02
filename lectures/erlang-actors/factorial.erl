%% $Id: factorial.erl,v 1.2 2013/04/04 21:32:15 leavens Exp leavens $
-module(factorial).
-export([fact/1,mult_server/0]).

%% Author: Gene Sher and Gary T. Leavens 
% We start off by building a process that answers to the rpc call {factorial,Num},
% and then calculates the factorial. We then develop the concurrent function.

% The algorithm is simple: we break the number into two parts,
% and then calculate each part, and multiply the solutions together.

fact(0) -> 1;
fact(N) -> 
    Me = self(),
    P1 = spawn(fun mult_server/0),
    P2 = spawn(fun mult_server/0),
    P1!{Me, N, N div 2 + 1},
    P2!{Me, N div 2, 1},
    receive
	V1 ->
	    receive V2 ->
		    V1 * V2
	    end
    end.

mult_server() ->
    receive
	{Pid,N,M} ->
	    Pid ! multiply_from_to(N,M,1)
    end.

multiply_from_to(N,M,Acc) ->
    if N < M -> Acc;
       true -> multiply_from_to(N-1,M,N*Acc)
    end.
