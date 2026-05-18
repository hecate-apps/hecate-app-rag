%%% @doc Plugin callback module — implements the hecate_plugin behaviour.
%%%
%%% `hecate-daemon` calls into this module to start, stop, route, and
%%% introspect the plugin. The actual supervision tree lives under
%%% `app_rag_sup`; this module is just the public contract.
-module(app_rag).

-export([
    info/0,
    routes/0,
    start/1,
    stop/1
]).

-spec info() -> map().
info() ->
    #{
        name        => <<"hecate-app-rag">>,
        version     => <<"0.1.0">>,
        description => <<"Local retrieval-augmented generation over the configured corpus">>,
        callback_module => ?MODULE
    }.

-spec routes() -> [tuple()].
routes() ->
    app_ragd_api_routes:discover_routes().

-spec start(map()) -> {ok, pid()} | {error, term()}.
start(_Args) ->
    app_rag_sup:start_link().

-spec stop(pid()) -> ok.
stop(_Pid) ->
    ok.
