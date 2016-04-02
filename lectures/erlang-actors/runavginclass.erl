%%%-------------------------------------------------------------------
%%% @author Gary T. Leavens 
%%% @copyright (C) 2015, Gary T. Leavens
%%% @doc
%%%
%%% @end
%%% Created :  9 Apr 2015 by Gary T. Leavens
%%%-------------------------------------------------------------------
-module(runavginclass).
-behaviour(gen_server).

%% API
-export([start_link/0, note/1, average/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).
% API 
-define(SERVER, runavg).

%%%===================================================================
%%% API
%%%===================================================================
note(Measurement) ->
    gen_server:call(?SERVER, {note, Measurement}).
average() ->
    {average_is, Avg} = gen_server:call(?SERVER, average),
    Avg.

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

% The state is a tuple of an int and 3 floats, with the int
% maintaining the number of measurements, and the floats being such
% that the leftmost float represents the oldest noted measurement.
-record(state, {meas=0, first=0.0, second=0.0, third=0.0}).

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
    {ok, #state{meas=0, first=0.0, second=0.0, third=0.0}}.

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
handle_call({note, V}, _From, 
	    #state{meas=N, first=_First, second=Second, third=Third}) ->
    Reply = ok,
    {reply, Reply, #state{meas=N+1, first=Second, second=Third, third=V}};
handle_call(average, _From, 
	    #state{meas=N, first=First, second=Second, third=Third}) ->
     Reply = {average_is, (First+Second+Third)/3.0},
     {reply, Reply, #state{meas=N, first=First, second=Second, third=Third}}.


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
handle_cast(_Msg, State) ->
    {noreply, State}.

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

%%%===================================================================
%%% Internal functions
%%%===================================================================
