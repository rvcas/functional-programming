% $Id: gauge_server.erl,v 1.1 2013/04/17 00:25:59 leavens Exp leavens $
-module(gauge_server).
-export([init/0, count/0, value/0, changeTo/1, handle/2]).
-import(server1, [rpc/2]).

%% Calls that clients can make on this server
count() -> rpc(gauge_server, count).
value() -> {value_is, N} = rpc(gauge_server, value), N.
changeTo(NewValue) -> rpc(gauge_server, {changeTo, NewValue}).

%% callback routines
init() -> {state, 0}.
handle(count, {state, Counter}) -> {counted, {state, Counter+1}};
handle(value, {state, Counter}) -> {{value_is, Counter}, {state, Counter}};
handle({changeTo, New}, {state, _Counter}) -> {ok, {state, New}}.




