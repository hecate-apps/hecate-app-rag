%%% @doc Cowboy handler for the plugin's SSE stream.
-module(app_ragd_sse_handler).

-export([init/2, info/3]).
-export([routes/0]).

routes() ->
    [{"/api/events/stream", ?MODULE, []}].

init(Req0, State) ->
    Headers = #{
        <<"content-type">>  => <<"text/event-stream">>,
        <<"cache-control">> => <<"no-cache">>,
        <<"connection">>    => <<"keep-alive">>
    },
    Req = cowboy_req:stream_reply(200, Headers, Req0),
    app_ragd_web_events:subscribe(self()),
    {cowboy_loop, Req, State}.

info({sse, Payload}, Req, State) ->
    cowboy_req:stream_body(["data: ", Payload, "\n\n"], nofin, Req),
    {ok, Req, State};
info(_Other, Req, State) ->
    {ok, Req, State}.
