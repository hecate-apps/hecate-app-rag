%%% @doc Top-level smoke tests for the RAG plugin daemon.
-module(hecate_app_ragd_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([plugin_info/1, route_discovery/1]).

all() ->
    [plugin_info, route_discovery].

init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(hecate_app_ragd),
    Config.

end_per_suite(_Config) ->
    application:stop(hecate_app_ragd),
    ok.

plugin_info(_Config) ->
    Info = app_rag:info(),
    ?assertEqual(<<"hecate-app-rag">>, maps:get(name, Info)),
    ?assert(is_binary(maps:get(version, Info))).

route_discovery(_Config) ->
    Routes = app_ragd_api_routes:discover_routes(),
    ?assert(is_list(Routes)).
