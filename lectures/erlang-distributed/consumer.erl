% $Id$
% A generalized consumer module
-module(consumer).
-import(myrpc,[ask/2]).
-export([start_link/5]).

-spec start_link(atom(), atom(), atom(), atom(),
		pos_integer()) -> no_return().
start_link(Node, MyName, Mod, MyInput, BuffSize) ->
    register(MyName,
	     spawn_link(Node, 
			fun() -> 
				init(MyName, Mod,
				     MyInput, BuffSize) 
			end)).

-spec init(atom(), atom(), atom(), pos_integer()) -> no_return().
init(MyName, Mod, MyInput, BuffSize) ->
    %% establish the invariant that the number of outstanding requests
    %% to MyInput is equal to BuffSize
    lists:foreach(fun(_) -> ask(MyInput, MyName) end, 
		  lists:seq(1, BuffSize)),
    loop(MyName, Mod, MyInput, Mod:init()).

-spec loop(atom(), atom(), atom(), any()) -> no_return().
loop(MyName, Mod, MyInput, State) ->
    receive
	{_, terminate} -> 
	    io:format("finishing!~n", []), 
	    exit(done);
	{MyInput, {put, Value}} ->
	    %% io:format("consumer got value ~p from ~p~n", [Value, MyInput]),
	    ask(MyInput, MyName),
	    NewState = Mod:consume(State, Value),
	    %% io:format("consumer looping with new state ~p~n", [NewState]),
	    loop(MyName, Mod, MyInput, NewState)
    end.
