%% $Id: factclient.erl,v 1.2 2013/04/04 21:32:15 leavens Exp leavens $
-module(factclient).
-export([getfact/2]).

getfact(Server, N) ->
    Server!{self(), compute, N},
    receive
	{ok, Result} ->
	    Result
    end.
