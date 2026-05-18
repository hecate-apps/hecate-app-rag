# hecate-app-ragd

Erlang/OTP backend of the `hecate-app-rag` Hecate plugin.

In-VM plugin: loaded by `hecate-daemon` into its own BEAM. Implements
the `hecate_plugin` behaviour. Stores domain events in its own
`rag_store` (ReckonDB), projects them into SQLite read models, exposes
a Cowboy HTTP API and an SSE event stream under
`/apps/hecate-app-rag/`.

## Umbrella layout

| App | Department | Purpose |
|-----|-----------|---------|
| `rag` | shared | root supervisor + notation shared by sibling apps |
| `embed_corpus` | CMD | ingest documents, chunk them, embed, prune |
| `refresh_corpus` | CMD | watch corpus dir, schedule re-embeds |
| `serve_retrieval` | CMD | answer queries, rerank, optionally federate |
| `project_chunks` | PRJ | event → chunks read model |
| `project_sources` | PRJ | event → sources read model |
| `query_chunks` | QRY | chunk lookup + semantic search |
| `query_sources` | QRY | source metadata lookups |

Each CMD app contains vertical-slice desks (e.g. `ingest_document/`,
`embed_document/`). Each desk co-locates its command, event, handler,
and API handler.

## Regenerate slice stubs

The scaffold uses a small Python generator. Re-running it overwrites
the slice files; non-generated entry points (app.src, _app.erl, _sup.erl)
are written once and left alone afterwards.

```bash
scripts/scaffold-slices.py
```

## Build

```bash
rebar3 compile
rebar3 ct
```

## Run

```bash
rebar3 shell
```

Then hit `http://localhost:8123/apps/hecate-app-rag/api/health`.
