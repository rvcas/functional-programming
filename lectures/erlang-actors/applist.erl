-module(applist).
-export([fromList/1,toList/1,appendAL/2,addToEnd/2]).
-export_type([applist/1]).

% An append list is represented by a closure that takes a list to append.
-type applist(A) :: {applist, [A], fun(([A]) -> [A])}.

-spec fromList([A]) -> applist(A).
fromList(Lst) -> 
    {applist, Lst, fun (Tail) -> lists:append(Lst,Tail) end.

-spec toList(applist(A)) -> [A].
toList(AL) -> AL([]).

-spec appendAL(applist(A),applist(A)) -> applist(A).
appendAL(AL1, AL2) -> fun(Tail) -> AL1(AL2(Tail)) end.

-spec addToEnd(applist(A), A) -> applist(A).
addToEnd(AL, X) -> fun(Tail) -> AL([X|Tail]) end.

-spec isEmptyAL(applist(A)) -> boolean().
isEmptyAL(AL) ->
    toList(AL) =:= [].

-spec headAL(applist(A)) -> A.
headAL(AL) ->
    [X|_] = toList(AL),
    X.

-spec tailAL(applist(A)) -> applist(A).
headAL(AL) ->
    [_|Tail] = toList(AL),
    Tail

	    
	     
