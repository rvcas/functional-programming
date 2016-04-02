% $Id$
% A generalized filterer module
-module(filterer).
-export([start_link/6]).

-spec start_link(atom(), atom(), atom(), pid(), pid(), pos_integer())
		-> no_return().
start_link(Node, MyName, Mod, MyOutput, MyInput, Size) ->
    register(MyName,
	     spawn_link(Node, 
			fun() -> 
				init(MyName, Mod, MyOutput, MyInput, Size)
			end)).

-spec init(atom(), atom(), pid(), pid(), pos_integer()) -> no_return().
init(MyName, Mod, MyOutput, MyInput, Size) ->
    lists:foreach(fun(_) -> ask(MyInput, MyName) end,
		 lists:seq(1, Size)),
    loop(MyName, Mod, MyOutput, 
	 MyInput, Mod:init()).
			 
-spec ask(pid(), atom()) -> ok.
ask(MyInput, MyName) ->
    MyInput ! {MyName, get},
    ok.

-spec loop(atom(), atom(), pid(), pid(), any()) -> no_return().
loop(MyName, Mod, MyOutput, MyInput, State) ->
    %% invariant: the number of requests outstanding to MyInput is
    %% always the same (the number Size above).
    receive
	{MyOutput, get} ->
            NewState
                = get_reply(MyName, Mod, MyOutput, MyInput, State),
            loop(MyName, Mod, MyOutput, MyInput, NewState)
    end.

-spec get_reply(atom(), atom(), pid(), pid(), any()) -> any().
get_reply(MyName, Mod, MyOutput, MyInput, State) ->
    receive
	{MyInput, {put, Value}} ->
	    ask(MyInput, MyName),  % reestablish invariant
	    case Mod:check_transform(State, Value) of
		{true, NewState, Result} ->
		    MyOutput ! {MyName, Result},
		    NewState;
		{false, NewState} ->
		    get_reply(MyName, Mod, MyOutput, MyInput, NewState)
	    end
    end.
