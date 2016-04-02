% $Id$
-module(shoppinglistinclass).
-export([init/0, handle/2]).
-import(server1, [rpc/2]).

-define(SERVER, shoppinglist).
%% Calls that clients can make on this server
add(Item) ->
    rpc(?SERVER, {add, Item}).
getList() ->
    {list_is, List} = rpc(?SERVER, getList),
    List.
clear() ->
    rpc(?SERVER, clear),
    ok.

%% callback routines
init() -> [].

handle({add, Item}, State) ->
    {added, [Item|State]};
handle(getList, State) ->
    {{list_is, State}, State};
handle(clear, _State) ->
    {cleared, init()}.





