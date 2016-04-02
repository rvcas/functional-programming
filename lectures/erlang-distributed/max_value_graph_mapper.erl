% $Id$
-module(max_value_graph_mapper).
-export([init/0, transform/2]).
-import(hailstone,[hailstoneMax/1]).

-spec init() -> ok.
init() ->
    ok.

-spec transform(State::any(), Value::pos_integer()) 
	       -> {any(), {pos_integer(), pos_integer()}}.
transform(State, N) ->
    {State, {N, hailstoneMax(N)}}.
