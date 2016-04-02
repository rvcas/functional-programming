-module(recursion).
-export([mylength/1,len/1]).

% fully recursive 
mylength([]) ->
    0;
mylength([_|T]) ->
    1+ mylength(T).

% tail recursive
len(Ls) ->
    len(Ls,0).
% note that the helper has the same name but a different number of arguments
len([],N) -> N;
len([_|T],N) -> len(T,N+1).

