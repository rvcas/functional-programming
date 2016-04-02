-module(factserverinclass).
-export[start/0,fserver/0].

start() ->
    spawn(?MODULE,fserver,[]).

fserver() ->
    receive
	{Pid, fact, N} ->
	    Pid! {val_is, fact(N)},
	    fserver()
    end.

fact(0) -> 1;
fact(N) -> N*fact(N-1).
