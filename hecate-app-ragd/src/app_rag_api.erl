%%% @doc Cowboy handler that forwards HTTP calls to hecate-rag over
%%% the mesh.
%%%
%%% Route convention: every `/apps/hecate-app-rag/api/<method>`
%%% maps to the mesh RPC `hecate-rag.<method>` with the JSON body
%%% as parameters.
-module(app_rag_api).

-export([init/2, routes/0]).

-define(METHOD_BINDING, method).
-define(SERVICE_KEY,    service_name).
-define(TIMEOUT_KEY,    rpc_timeout_ms).

routes() ->
    [{"/apps/hecate-app-rag/api/[:method]", ?MODULE, []}].

init(Req0, State) ->
    Method = cowboy_req:binding(?METHOD_BINDING, Req0),
    case Method of
        undefined ->
            reply(404, #{error => <<"missing_method">>}, Req0, State);
        _ ->
            dispatch(Method, Req0, State)
    end.

%%% Internals

dispatch(Method, Req0, State) ->
    case cowboy_req:method(Req0) of
        <<"POST">> -> forward(Method, Req0, State);
        <<"GET">>  -> forward(Method, Req0, State);
        _          -> reply(405, #{error => <<"method_not_allowed">>}, Req0, State)
    end.

forward(Method, Req0, State) ->
    case body_or_query(Req0) of
        {ok, Params, Req1} ->
            FullMethod = full_method(Method),
            case call_service(FullMethod, Params) of
                {ok, Result} ->
                    reply(200, Result, Req1, State);
                {error, Reason} ->
                    reply(502, #{error => to_binary(Reason)}, Req1, State)
            end;
        {error, invalid_json, Req1} ->
            reply(400, #{error => <<"invalid_json">>}, Req1, State)
    end.

body_or_query(Req) ->
    case cowboy_req:method(Req) of
        <<"GET">> ->
            Qs = maps:from_list(cowboy_req:parse_qs(Req)),
            {ok, Qs, Req};
        _ ->
            case cowboy_req:read_body(Req) of
                {ok, <<>>, Req1} ->
                    {ok, #{}, Req1};
                {ok, Body, Req1} ->
                    try {ok, jsx:decode(Body, [return_maps]), Req1}
                    catch _:_ -> {error, invalid_json, Req1}
                    end
            end
    end.

full_method(Method) ->
    Service = application:get_env(hecate_app_ragd, ?SERVICE_KEY, <<"hecate-rag">>),
    <<Service/binary, ".", Method/binary>>.

call_service(_FullMethod, _Params) ->
    %% TODO: macula:call(LocalStation, FullMethod, Params, Timeout).
    %% Until the daemon's macula client handle is exposed via
    %% hecate_sdk, return a placeholder so the route is reachable
    %% and the error path is testable.
    {error, not_wired}.

reply(Code, Body, Req, State) ->
    Req1 = cowboy_req:reply(Code,
                            #{<<"content-type">> => <<"application/json">>},
                            jsx:encode(Body),
                            Req),
    {ok, Req1, State}.

to_binary(B) when is_binary(B) -> B;
to_binary(A) when is_atom(A)   -> atom_to_binary(A, utf8);
to_binary(O)                    -> iolist_to_binary(io_lib:format("~p", [O])).
