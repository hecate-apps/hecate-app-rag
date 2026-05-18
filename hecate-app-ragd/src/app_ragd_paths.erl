%%% @doc Filesystem paths used by the RAG plugin.
-module(app_ragd_paths).

-export([
    data_dir/0,
    index_dir/0,
    index_file/1,
    sqlite_db/0
]).

-spec data_dir() -> string().
data_dir() ->
    application:get_env(hecate_app_ragd, data_dir, "priv/data").

-spec index_dir() -> string().
index_dir() ->
    application:get_env(hecate_app_ragd, index_dir, "priv/index").

-spec index_file(atom() | binary()) -> string().
index_file(Name) when is_atom(Name) ->
    index_file(atom_to_binary(Name, utf8));
index_file(Name) when is_binary(Name) ->
    filename:join(index_dir(), [Name, ".hvec"]).

-spec sqlite_db() -> string().
sqlite_db() ->
    filename:join(data_dir(), "rag.sqlite").
