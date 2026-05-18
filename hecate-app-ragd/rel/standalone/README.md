# Standalone release profile

This directory holds the future **specialised-daemon** release of
hecate-app-rag — same OTP apps as the `in_vm` plugin, but booted as
its own BEAM under systemd.

## Status

**Not built yet.** The `in_vm` plugin is the only shipping form
today. This profile is staked out so the split is mechanical when
one of the triggers below fires.

## When to enable

Build this profile (and ship `hecate-rag-daemon` as a separate
systemd unit) as soon as **any** of the following becomes true:

| Trigger | Why it matters |
|---------|----------------|
| Index resident size > ~200 MB | Pollutes Martha's BEAM heap |
| Re-embed runs disrupt Martha sessions (>30s pause) | Need independent lifecycle |
| Corpus topic load means re-embed > 1×/hour | RAG should hot-load, not bounce the daemon |
| Second tenant (household / shared dev box) wants the index | One rag-daemon serves N hecate-daemons on the same node |
| External (non-Hecate) consumers need RAG | Standalone is easier to package without the plugin contract |

## How the split works (when we do it)

1. Build a release: `rebar3 as standalone tar` (profile to be added
   to `hecate-app-ragd/rebar.config` alongside `prod`).
2. Drop the tarball into `~/.hecate/standalone/hecate-rag-daemon/`.
3. Symlink `systemd/hecate-rag-daemon.service` into
   `~/.config/systemd/user/` (the Hecate gitops reconciler will do
   this automatically once the daemon manifest names it).
4. `systemctl --user start hecate-rag-daemon`.
5. The daemon boots its own BEAM, attaches to the local
   `macula-station` as an outbound-only QUIC client, advertises a
   `macula_rag` summary, registers `macula_rag.query` as an RPC
   responder.
6. `hecate-daemon` (which previously called into the plugin
   in-process) instead calls via the macula SDK — `macula:call/4` on
   the local station, same identity, loopback hop.

## Identity / cert sharing

Both daemons load `~/.hecate/secrets/realm-cert.pem`. The rag-daemon
gets the **same** realm membership as hecate-daemon. macula-station
sees two clients under one identity. Realm-side authorisation is
unchanged.

If we ever want per-daemon UCAN delegation (rag-daemon has narrower
permissions than hecate-daemon), that's a follow-up — needs
hecate-realm to issue scoped UCANs.

## Files that will land here

```
rel/standalone/
├── README.md                                 (this file)
├── config/
│   └── sys.config                            (standalone runtime config)
├── systemd/
│   └── hecate-rag-daemon.service             (Quadlet or plain unit)
└── start.sh                                  (entry script for the release)
```

## Code re-use

The Erlang umbrella does **not** change. Every app under `apps/`
(embed_corpus, refresh_corpus, serve_retrieval, project_chunks,
project_sources, query_chunks, query_sources, rag) boots identically
in both profiles. Only the supervision **root** differs:

- `in_vm`: hecate-daemon's plugin loader calls `app_rag:start/1`,
  routes are exposed under `/apps/hecate-app-rag/`.
- `standalone`: `hecate_app_ragd_app:start/2` is the OTP application
  entry; supervisor starts everything; macula SDK is started in
  client mode and registers the RPC responder.

See `manifest.json` at the repo root for the declared `release_profiles`.
