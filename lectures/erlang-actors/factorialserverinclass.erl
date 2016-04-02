-module(factorialserverinclass).
-import(stateless1, [rpc/2]).
-export([handle/1, fact/1]).

handle({fact, N}) when N >= 0 ->
    factorial(N).

%% client function
fact(N) when N >= 0 ->
    rpc(factserver, {fact, N}).

factorial(0) ->
    1;
factorial(N) -> N*factorial(N-1).

