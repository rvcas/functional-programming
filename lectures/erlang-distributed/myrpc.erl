% $Id$
-module(myrpc).
-export([rpc/2,rpc/3,ask/2]).

-type name() :: atom() | pid().

-spec rpc(name(), term()) -> term().
rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
	{Name, Response} -> Response
    end.

-spec rpc(name(), atom(), term()) -> term().
rpc(Name, MyName, Request) ->
    % io:format("myrpc:rpc sending to ~p {~p,~p}~n", [Name, MyName, Request]),
    Name ! {MyName, Request},
    receive
	{Name, Response} -> 
	    % io:format("myrpc:rpc received ~p from ~p~n", [Response, Name]),
	    Response
    end.

-spec ask(pid(), atom()) -> ok.
ask(MyInput, MyName) ->
    MyInput ! {MyName, get},
    ok.
