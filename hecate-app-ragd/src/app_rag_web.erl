%%% @doc Serves the built -ragw custom-element bundle.
%%%
%%% The bundle is produced by `npm run build:lib` in `hecate-app-ragw`
%%% and lands under `priv/web/`. The Hecate desktop shell mounts
%%% `<hecate-app-rag>` from this URL.
-module(app_rag_web).

-export([routes/0]).

routes() ->
    PrivDir = case code:priv_dir(hecate_app_ragd) of
        {error, _} -> "priv";
        Dir        -> Dir
    end,
    WebDir = filename:join(PrivDir, "web"),
    [
        {"/apps/hecate-app-rag/web/[...]",
         cowboy_static, {dir, WebDir}}
    ].
