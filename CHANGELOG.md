# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [SemVer](https://semver.org/).

## [Unreleased]

## [0.2.0] - 2026-05-18

### Changed (breaking)
- **Re-architected as a Layer-4 thin plugin** under the new
  four-tier Hecate model. The heavy daemon work (umbrella, slices,
  projections, event store) moved to
  [`hecate-services/hecate-rag`](https://codeberg.org/hecate-services/hecate-rag).
- `hecate-app-ragd/` is now a single OTP application — no umbrella,
  no `apps/`. Implements the `hecate_plugin` behaviour, registers
  HTTP routes under `/apps/hecate-app-rag/api/<method>`, forwards
  each call to the realm service `hecate-rag` via
  `macula:call(local-station, "hecate-rag.<method>", Params, T)`.
- `app_rag_web.erl` serves the built `-ragw` custom-element bundle
  under `/apps/hecate-app-rag/web/`.
- Dropped: 9-app umbrella (`embed_corpus`, `refresh_corpus`,
  `serve_retrieval`, `project_chunks`, `project_sources`,
  `query_chunks`, `query_sources`, `rag`), SSE bridge,
  paths/web-events handlers, SQLite migrations, `release_profiles`
  manifest field.

### Removed
- `manifest.json: release_profiles` — the standalone-mode dance is
  obsolete; the service half is always standalone in
  `hecate-services/hecate-rag`, this side is always `in_vm`.

## [0.1.0] - 2026-05-18 (retired same day)

### Added
- Initial scaffold as a self-contained Hecate plugin: `-ragd`
  Erlang umbrella with 9 OTP apps (vertical slices for CMD / PRJ /
  QRY) + `-ragw` SvelteKit custom-element frontend.

### Retired
- Superseded by 0.2.0 once the four-tier model formalised the
  split between Layer-4 apps and Layer-2 services. The umbrella
  moved to `hecate-services/hecate-rag`; this repo kept only the
  user-facing surface.
