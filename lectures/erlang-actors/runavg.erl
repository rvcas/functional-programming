%%% $Id: runavg.erl,v 1.1 2013/04/17 01:02:33 leavens Exp leavens $
%%%-------------------------------------------------------------------
%%% @author Gary T. Leavens
%%% @doc A simple example of the use of Erlang's gen_server module.
%%% This tracks a running average of 3 floats. Floats are sent to
%%% the server by using the function note/1. 
%%% The current average can be obtained by calling average/0. 
%%% @end
%%%-------------------------------------------------------------------
-module(runavg).
-behaviour(gen_server).

%% API
-export([start_link/0, note/1, average/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

% the state is a tuple of 3 floats, with the leftmost being the oldest
% starting out as {0.0, 0.0, 0.0}

%%%===================================================================
%%% API
%%%===================================================================

note(Measurement) ->
     gen_server:call(?MODULE, {note, Measurement}).
average() ->
    gen_server:call(?MODULE, average).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    {ok, {0.0, 0.0, 0.0}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({note,Measurement}, _From, {_M1,M2,M3}) ->
    Reply = ok,
    {reply, Reply, {M2,M3,Measurement}};
handle_call(average, _From, {M1,M2,M3}) ->
    Avg = (M1+M2+M3)/3.0,
    {reply, Avg, {M1,M2,M3}}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({note,Measurement}, {_M1,M2,M3}) ->
    {noreply, {M2,M3,Measurement}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
