% $Id$
% A generalized map
-module(mapper).
-import(myrpc,[ask/2]).
-export([start_link/6]).

-spec start_link(atom(), atom(), atom(), atom(), atom(), pos_integer())
		-> no_return().
start_link(Node, MyName, Mod, MyOutput, MyInput, Size) ->
    register(MyName,
	     spawn_link(Node, 
			fun() -> init(MyName, Mod, MyOutput, 
				      MyInput, Size)
			      end)).

-spec init(atom(), atom(), pid(), pid(), pos_integer()) -> no_return().
init(MyName, Mod, MyOutput, MyInput, Size) ->
    %% establish the invariant that the number of outstanding requests
    %% to MyInput is equal to Size
    lists:foreach(fun(_) -> ask(MyInput, MyName) end, 
		  lists:seq(1, Size)),
    loop(MyName, Mod, MyOutput, MyInput, Mod:init()).

-spec loop(atom(), atom(), atom(), atom(), any()) -> no_return().
loop(MyName, Mod, MyOutput, MyInput, State) ->
    %% invariant: the number of requests outstanding to MyInput is
    %% always the same (the number Size above).
    receive
	{MyOutput, get} ->
	    % now we must obtain something from our input...
	    % io:format("mapper received get message from ~p~n", [MyOutput]),
	    receive
		{MyInput, {put, Value}} ->
		    % io:format("mapper received put message from ~p~n", [MyInput]),
		    ask(MyInput, MyName), % maintain invariant
		    {NewState, Result}
			= Mod:transform(State, Value),
		    % io:format("mapper sending to ~p {put, ~p}~n", [MyOutput, Result]),
		    MyOutput ! {MyName, {put, Result}},
		    loop(MyName, Mod, MyOutput, MyInput, NewState)
	    end
    end.
