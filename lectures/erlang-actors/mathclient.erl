%% $Id: mathclient.erl,v 1.1 2013/04/04 20:44:02 leavens Exp $
-module(mathclient).
-export([compute/3]).

% compute, by using the math server P, the composition of the functions Funs
% as applied to the value Val.
compute(P,Funs,Val) ->
    P!{self(),compute,Funs,Val},
    receive
	{ok,Res} ->
	     Res
    end.
