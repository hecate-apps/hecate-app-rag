%%% @doc OTP application entry for the slim hecate-app-rag plugin.
-module(hecate_app_ragd_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    app_rag_sup:start_link().

stop(_State) ->
    ok.
