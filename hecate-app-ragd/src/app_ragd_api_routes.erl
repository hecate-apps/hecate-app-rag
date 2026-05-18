%%% @doc API route dispatcher for the RAG plugin.
%%%
%%% Discovers Cowboy routes contributed by sibling umbrella apps.
%%% Each desk module exporting `routes/0` is picked up automatically.
-module(app_ragd_api_routes).

-export([init/2, discover_routes/0]).

-define(RAG_APPS, [
    hecate_app_ragd,
    rag,
    embed_corpus,
    refresh_corpus,
    serve_retrieval,
    query_chunks,
    query_sources
]).

init(Req0, _State) ->
    PathInfo = cowboy_req:path_info(Req0),
    Path = case PathInfo of
        undefined -> cowboy_req:path(Req0);
        Parts -> iolist_to_binary([<<"/">>, lists:join(<<"/">>, Parts)])
    end,
    case find_handler(Path, discover_routes()) of
        {ok, Handler, State} ->
            Handler:init(Req0, State);
        nomatch ->
            hecate_plugin_api:not_found(Req0)
    end.

-spec discover_routes() -> [tuple()].
discover_routes() ->
    hecate_plugin_routes:discover_routes(?RAG_APPS).

%%% Internals

find_handler(_Path, []) ->
    nomatch;
find_handler(Path, [{Pattern, Handler, State} | Rest]) ->
    case match_path(Path, Pattern) of
        true -> {ok, Handler, State};
        false -> find_handler(Path, Rest)
    end;
find_handler(Path, [_ | Rest]) ->
    find_handler(Path, Rest).

match_path(Path, Pattern) when is_binary(Pattern) -> Path =:= Pattern;
match_path(Path, Pattern) when is_list(Pattern)   -> Path =:= list_to_binary(Pattern);
match_path(_, _) -> false.
