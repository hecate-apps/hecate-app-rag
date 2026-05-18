%%% @doc OTP application entry for the root umbrella app.
%%%
%%% Delegates supervision to `app_rag_sup`, which then mounts the
%%% domain apps and the HTTP layer.
-module(hecate_app_ragd_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    app_rag_sup:start_link().

stop(_State) ->
    ok.
