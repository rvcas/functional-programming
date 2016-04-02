% $Id$
% A generalized producer module
-module(producer).
-export([start_link/3]).

-spec start_link(Node::atom(), Name::atom(),
		 Mod::atom()) -> pid().
start_link(Node, Name, Mod) ->
    register(Name,
	     spawn_link(Node, 
			fun() -> loop(Name, 
				      Mod, 
				      Mod:init()) 
			end)).

-spec loop(Name::pid(), Mod::atom(),
	   State::any()) -> no_return().
loop(Name, Mod, State) ->
    receive
	{From, get} ->
	    {Value, NewState} = Mod:produce(State),
	    % io:format("producer ~p produces ~p~n", [Name, Value]),
	    From ! {Name, {put, Value}},
	    loop(Name, Mod, NewState)
    end.
