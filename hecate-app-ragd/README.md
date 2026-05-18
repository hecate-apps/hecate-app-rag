# hecate-app-ragd

Thin Erlang plugin half of `hecate-app-rag`. Lives in `hecate-daemon`
as an in-VM plugin. Two jobs:

1. Serve the Svelte custom-element bundle built by `-ragw`.
2. Forward `/apps/hecate-app-rag/api/*` HTTP calls to `hecate-rag`
   (the realm service) via the Macula mesh.

Holds no domain state, runs no projections, owns no event store.
**All real work lives in [`hecate-services/hecate-rag`](https://codeberg.org/hecate-services/hecate-rag).**

## Why a plugin at all

`hecate-rag` is a realm-bound service running on infrastructure
nodes. Users on laptops can't reach it directly — they go through
their local `hecate-daemon`. This plugin is the bridge:

```
Browser
  │ HTTP
  ▼
hecate-daemon
  └── hecate-app-ragd (this plugin)
        │ macula:call(local-station, "hecate-rag.<method>", Params)
        ▼
macula-station
        │ QUIC routed
        ▼
infrastructure node running hecate-rag
```

## Layout

```
src/
├── hecate_app_ragd.app.src
├── hecate_app_ragd_app.erl
├── app_rag.erl              (hecate_plugin callback module)
├── app_rag_sup.erl
├── app_rag_api.erl          (Cowboy → macula:call forwarder)
└── app_rag_web.erl          (static handler for the -ragw bundle)
```

That's it. No umbrella, no apps/, no slices. The slices live where
the work happens — in `hecate-services/hecate-rag`.

## Build

```bash
rebar3 compile
```

For a full plugin tarball, build `-ragw` first then bundle:

```bash
cd ../hecate-app-ragw
npm run build:lib                    # → ../hecate-app-ragd/priv/web/

cd ../hecate-app-ragd
rebar3 as prod tar
```

## License

Apache-2.0.
