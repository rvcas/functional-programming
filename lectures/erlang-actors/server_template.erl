%%%-------------------------------------------------------------------
%%% @author Gary T. Leavens <leavens@LEAVENS-ND>
%%% @copyright (C) 2013, Gary T. Leavens
%%% @doc
%%%
%%% @end
%%% Created : 15 Apr 2013 by Gary T. Leavens <leavens@LEAVENS-ND>
%%%-------------------------------------------------------------------
-module(server_template).

-export([start/0, init/1]).


start() ->
    spawn(server_template, init, [self()]).

init(From) ->
    loop(From).

loop(From) ->
    receive
	_ ->
	    loop(From)
		end.
