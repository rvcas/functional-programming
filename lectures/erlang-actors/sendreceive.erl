-module(sendreceive).
-export([demo1/0,demo2/0]).

demo1() ->
    FS = spawn(fun factServer/0),
    FS! {self(), fact, 7},
    receive
	{ok, M} -> M
    end.

factServer() ->
    receive
	{Pid, fact, N} when N >= 0 ->
	    Pid ! {ok, factorial(N)};
	{Pid, fact, _N} ->  % _N < 0
	    Pid ! {wrong, 0}
    end.

factorial(0) -> 1;
factorial(N) -> N*factorial(N-1).
    
% Below, note the use of variables defined outside the scope of receive's
demo2() ->
    Me = self(),
    FS = spawn(
           fun () -> 
		   receive {Me, fact, N,N} -> 
			   Me!{self(), ok, factorial(N)} % can't use FS here
		   end
	   end),
    FS! {Me, fact, 7, 7},
    receive
	{FS, ok, M} -> M
    end.
