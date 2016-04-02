-module(db).
-export([start/0,stop/0,retrieve/1,insert/2,custom/1]).

start() ->
    register(db, spawn(fun() ->
                loop(dict:new())
                end)
            ),
    {started}.
    

insert(Key, Value) ->
    rpc({insert, Key, Value}).

retrieve(Key) ->
    rpc({retrieve, Key}).

stop() ->
    rpc({stop}).

custom(Pul) ->
    rpc(Pul).

rpc(Request) ->
    db ! {self(), Request},
    receive
    {db, Reply} ->
        Reply
    end.

loop(Dictionary) ->
    receive
        {Client, {insert, Key, Value}} ->
            NewD = dict:store(Key, Value, Dictionary),
            Client ! {db, done},
            loop(NewD);
        {Client, {retrieve, Key}} ->
            Value = dict:find(Key, Dictionary),
            case Value of
                {ok,Val} ->
                    Client ! {db, Val};
                error ->
                    Client ! {db, undefined}
            end,
            loop(Dictionary);
        {Client, {stop}} ->
            Client ! {db, stopped}
    end.