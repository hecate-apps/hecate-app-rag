# hecate-app-rag

User-facing surface for the realm's RAG service. A thin Hecate
plugin that lives in `hecate-daemon` and forwards retrieval calls
to **[`hecate-services/hecate-rag`](https://codeberg.org/hecate-services/hecate-rag)** —
the realm-bound service daemon — over the Macula mesh.

This repo holds the surface, not the work. The umbrella, slices,
projections, and event store live in `hecate-services/hecate-rag`.

## Layout

```
hecate-app-rag/
├── hecate-app-ragd/     ← slim Erlang plugin (in_vm, hosts in hecate-daemon)
│   └── src/
│       ├── hecate_app_ragd.app.src + _app.erl
│       ├── app_rag.erl              hecate_plugin callback
│       ├── app_rag_sup.erl
│       ├── app_rag_api.erl          HTTP → macula:call forwarder
│       └── app_rag_web.erl          serves the built -ragw bundle
└── hecate-app-ragw/     ← SvelteKit 5 custom-element
    └── src/
        ├── routes/+page.svelte
        └── lib/components/
            ├── SearchBar.svelte
            ├── ResultCard.svelte
            └── SourcePreview.svelte
```

No `apps/`, no umbrella, no slices in `-ragd`. By design.

## Call flow

```
Browser
  │ POST /apps/hecate-app-rag/api/answer_query  {q: "..."}
  ▼
hecate-daemon
  └── hecate-app-ragd
        ├── app_rag_api decodes JSON
        ├── computes method = "hecate-rag.answer_query"
        └── macula:call(local-station, method, params, timeout)
              │
              ▼ (QUIC, routed by macula-station)
infrastructure node running hecate-rag
  └── hecate_rag_mesh_rpc → maybe_answer_query → result
              │
              ▼
hecate-app-ragd reply
              │
              ▼
Browser gets JSON
```

## Build + install

```bash
# Frontend (custom element bundle → ragd/priv/web/)
cd hecate-app-ragw
npm install
npm run build:lib

# Plugin
cd ../hecate-app-ragd
rebar3 compile
rebar3 as prod tar

# Install
hecate-cli plugins install ./_build/prod/rel/hecate_app_ragd/*.tar.gz
```

## Architecture position

```
Layer 4 — apps        ▶ hecate-app-rag (this repo) ◀
                      User-facing plugin, lives in hecate-daemon

Layer 3 — session     hecate-daemon
Layer 2 — services    hecate-services/hecate-rag (the heavy lifting)
Layer 1 — identity    hecate-realm
Layer 0 — kernel      macula-station
```

`hecate-app-rag` is the **Layer-4 app** half. `hecate-services/hecate-rag`
is the **Layer-2 service** half. Apps run per-user; services run on
realm infrastructure.

## History

- **v0.1 (2026-05-18, retired same day)**: scaffolded as a self-contained
  plugin with a 9-app umbrella, vertical slices, projections, the works
  — all inside hecate-daemon's BEAM.
- **v0.2 (2026-05-18)**: re-architected as a Layer-4 thin plugin once
  the four-tier model landed. The umbrella, slices, projections, and
  event store moved to `hecate-services/hecate-rag`. This repo kept
  only the user-facing surface.

See `CHANGELOG.md` for the detail.

## License

Apache-2.0. See [LICENSE](LICENSE).
