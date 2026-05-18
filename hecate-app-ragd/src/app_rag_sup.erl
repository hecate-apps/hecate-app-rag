%%% @doc Plugin supervision tree. Empty for now — the plugin holds no
%%% long-running state. Kept so the plugin contract gets a `pid()`
%%% to track.
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
    {ok, {SupFlags, []}}.
