%%% @doc Top-level supervisor for the RAG plugin daemon.
%%%
%%% The umbrella apps (embed_corpus, refresh_corpus, ...) each bring
%%% their own supervisor. This one only owns plugin-wide infrastructure:
%%% API route registration, the SSE event bridge, and a singleton
%%% `app_ragd_event_bridge` that forwards every domain event to the
%%% SSE handler.
-module(app_rag_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy  => one_for_one,
        intensity => 10,
        period    => 10
    },
    Children = [
        #{
            id       => app_ragd_event_bridge,
            start    => {app_ragd_event_bridge, start_link, []},
            restart  => permanent,
            shutdown => 5000,
            type     => worker,
            modules  => [app_ragd_event_bridge]
        },
        #{
            id       => app_ragd_web_events,
            start    => {app_ragd_web_events, start_link, []},
            restart  => permanent,
            shutdown => 5000,
            type     => worker,
            modules  => [app_ragd_web_events]
        }
    ],
    {ok, {SupFlags, Children}}.
