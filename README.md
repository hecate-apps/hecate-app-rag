# hecate-app-rag

Retrieval-augmented generation as a Hecate plugin. Lets the daemon and
its sibling plugins (Martha, Scribe, future apps) query a local
semantic index over the configured corpus — by default, the
[`hecate-agents`](https://codeberg.org/hecate-social/hecate-agents)
shaping material.

## Status

**Scaffold.** Plugin manifest, umbrella, vertical slices, frontend
shell. No business logic wired yet.

## Architecture

```
hecate-app-rag/
├── hecate-app-ragd/     ← Erlang/OTP backend (in_vm plugin)
│   └── apps/
│       ├── embed_corpus/        CMD — ingest, embed, prune
│       ├── refresh_corpus/      CMD — detect change, schedule re-embed
│       ├── serve_retrieval/     CMD — answer queries, rerank
│       ├── project_chunks/      PRJ — chunk read-model projections
│       ├── project_sources/     PRJ — source read-model projections
│       ├── query_chunks/        QRY — chunk lookups + semantic search
│       └── query_sources/       QRY — source metadata lookups
└── hecate-app-ragw/     ← SvelteKit custom-element (built into ragd/priv/)
    └── src/
        ├── routes/+page.svelte
        └── lib/components/
            ├── SearchBar.svelte
            ├── ResultCard.svelte
            └── SourcePreview.svelte
```

## Dependencies

- [`hecate-vector`](https://codeberg.org/hecate-social/hecate-vector) - in-BEAM ANN index
- [`hecate-embed`](https://codeberg.org/hecate-social/hecate-embed) - local multilingual embedder
- `hecate_sdk` - plugin contract
- `reckon_db` + `evoq` + `reckon_evoq` - event sourcing stack
- (phase 2) [`macula-rag`](https://codeberg.org/macula-io/macula-rag) - federated retrieval

## How it fits

```
Other plugin (e.g. Martha)
        │ hecate_sdk:rag_query/2
        ▼
hecate-app-rag (this plugin)
   ├── serve_retrieval → embed query, search hecate_vector
   ├── query_chunks    → return matching chunks
   └── (phase 2) macula-rag → fan query across stations
```

## Build

```bash
# Backend
cd hecate-app-ragd
rebar3 compile
rebar3 ct

# Frontend
cd hecate-app-ragw
npm install
npm run build      # produces dist/ → copied into ragd/priv/web/
```

## Install into a Hecate daemon

```bash
hecate-cli plugins install \
    https://codeberg.org/hecate-apps/hecate-app-rag/releases/download/v0.1.0/hecate-app-rag-0.1.0.tar.gz
```

## Deployment modes

`manifest.json` declares `release_profiles: ["in_vm", "standalone"]`.
Today only `in_vm` ships — the plugin is loaded into `hecate-daemon`'s
BEAM. The `standalone` profile is staked out under
`hecate-app-ragd/rel/standalone/` for the day we need to split out
`hecate-rag-daemon` as its own systemd unit.

### Triggers to flip to standalone

Split into `hecate-rag-daemon` when any of:

- Index resident size > ~200 MB (Martha's BEAM heap suffers)
- Re-embed runs disrupt Martha sessions (>30s pause)
- A second tenant on the same node wants to share the index
- External (non-Hecate) consumers need RAG

The Erlang umbrella does not change — same OTP apps, different
supervision root + release tarball. See
`hecate-app-ragd/rel/standalone/README.md` for the playbook.

## Architecture position

This plugin runs inside `hecate-daemon` (per-identity BEAM), **not**
inside `macula-station` (per-node networking kernel). All four of its
underlying libraries — `hecate-vector`, `hecate-embed`, `macula-rag`,
plus the daemon side of `hecate-app-rag` — live in `hecate-daemon`'s
BEAM. `macula-` prefix on `macula-rag` means "uses the Macula SDK",
not "runs inside macula-station".

## License

Apache-2.0. See [LICENSE](LICENSE).
