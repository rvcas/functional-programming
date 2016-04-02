-module(closuredemo).
-export([cadd/1,main/0]).

main() ->
    (cadd(5))(3).

cadd(N) ->
    fun(M) ->
	    N + M 
    end.

% Can't do the following, as a closure can't refer to undetermined variables
%% recurdemo() ->
%%     Recur = fun() ->
%% 		    Recur() 
%% 	    end,
%%     Recur().
