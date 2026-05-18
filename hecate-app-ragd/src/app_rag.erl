%%% @doc hecate_plugin callback module.
%%%
%%% The daemon calls this to start/stop the plugin and discover its
%%% HTTP routes. Real RAG work happens in `hecate-services/hecate-rag`
%%% on a realm infrastructure node; this module forwards there.
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
        version     => <<"0.2.0">>,
        description => <<"User-facing surface for the realm's RAG service">>,
        callback_module => ?MODULE,
        backing_service => <<"hecate-rag">>
    }.

-spec routes() -> [tuple()].
routes() ->
    app_rag_api:routes() ++ app_rag_web:routes().

-spec start(map()) -> {ok, pid()} | {error, term()}.
start(_Args) ->
    app_rag_sup:start_link().

-spec stop(pid()) -> ok.
stop(_Pid) ->
    ok.
