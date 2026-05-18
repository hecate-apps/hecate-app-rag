%%% @doc Bridge between the rag_store and web SSE connections.
%%%
%%% Subscribes to ALL events in the `rag_store` ($all stream) and forwards
%%% each event into `app_ragd_web_events`. Lets sibling slices stay
%%% unaware of the SSE layer.
-module(app_ragd_event_bridge).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-define(STORE_ID, rag_store).
-define(SUB_NAME, <<"rag_web_event_bridge">>).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    %% TODO: subscribe to ?STORE_ID $all stream once the store is up.
    %% Mirrors app_marthad_event_bridge.
    {ok, #{}}.

handle_call(_Msg, _From, State) -> {reply, ok, State}.
handle_cast(_Msg, State)         -> {noreply, State}.

handle_info({evoq_event, _Envelope}, State) ->
    %% app_ragd_web_events:dispatch(Envelope),
    {noreply, State};
handle_info(_Other, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.
