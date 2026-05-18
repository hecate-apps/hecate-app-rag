%%% @doc Fan-out registry for SSE subscribers.
-module(app_ragd_web_events).
-behaviour(gen_server).

-export([start_link/0, subscribe/1, dispatch/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-record(state, {subscribers = [] :: [pid()]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

subscribe(Pid) when is_pid(Pid) ->
    gen_server:cast(?MODULE, {subscribe, Pid}).

dispatch(Payload) ->
    gen_server:cast(?MODULE, {dispatch, Payload}).

init([]) ->
    {ok, #state{}}.

handle_call(_Msg, _From, State) -> {reply, ok, State}.

handle_cast({subscribe, Pid}, #state{subscribers = Subs} = State) ->
    erlang:monitor(process, Pid),
    {noreply, State#state{subscribers = [Pid | Subs]}};
handle_cast({dispatch, Payload}, #state{subscribers = Subs} = State) ->
    [Pid ! {sse, Payload} || Pid <- Subs],
    {noreply, State};
handle_cast(_Other, State) ->
    {noreply, State}.

handle_info({'DOWN', _Ref, process, Pid, _Reason}, #state{subscribers = Subs} = State) ->
    {noreply, State#state{subscribers = lists:delete(Pid, Subs)}};
handle_info(_Other, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.
