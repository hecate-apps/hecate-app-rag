%%% @doc Smoke tests for the slim plugin.
-module(app_rag_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([plugin_info/1, routes_discovered/1]).

all() ->
    [plugin_info, routes_discovered].

init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(hecate_app_ragd),
    Config.

end_per_suite(_Config) ->
    application:stop(hecate_app_ragd),
    ok.

plugin_info(_Config) ->
    Info = app_rag:info(),
    ?assertEqual(<<"hecate-app-rag">>, maps:get(name, Info)),
    ?assertEqual(<<"hecate-rag">>,     maps:get(backing_service, Info)).

routes_discovered(_Config) ->
    Routes = app_rag:routes(),
    ?assert(is_list(Routes)),
    ?assert(length(Routes) >= 2).
