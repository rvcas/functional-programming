% $Id$
-module(max_value_peak_consumer).
-export([init/0, consume/2]).

-spec init() -> {pos_integer(), pos_integer()}.
init() ->
    {1,1}.

-spec consume(State::{pos_integer(), pos_integer()},
	      Value::{pos_integer(), pos_integer()}) ->
		     {pos_integer(), pos_integer()}.
consume({Arg, ArgValue}, {NewArg, NewValue}) ->
    if NewValue > ArgValue ->
	    io:format("new peak (for arg ~p) is: ~p~n", [NewArg, NewValue]),
	    {NewArg, NewValue};
       true -> {Arg, ArgValue}
    end.
