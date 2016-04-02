% $Id: shoppinglist.erl,v 1.1 2013/04/17 00:41:54 leavens Exp leavens $
-module(shoppinglist).
-export([init/0,handle/2,add/1,getList/0,clear/0]).
-import(server1,[rpc/2]).

%% Client API
add(Item) -> rpc(?MODULE, {add, Item}).
getList() -> {list_is, Lst} = rpc(?MODULE, getList), Lst.
clear() -> rpc(?MODULE, clear).

%% Hooks from server1
init() -> [].

handle({add, Item}, Lst) -> {added, [Item|Lst]};
handle(getList, Lst) -> {{list_is, Lst}, Lst};
handle(clear, _Lst) -> {cleared, []}.


