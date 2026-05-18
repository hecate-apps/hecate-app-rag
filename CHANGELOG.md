# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial scaffold of the Martha-shaped Hecate plugin: `-ragd` Erlang
  umbrella (CMD, QRY, PRJ vertical slices) + `-ragw` SvelteKit
  custom-element frontend.
- CMD apps: `embed_corpus`, `refresh_corpus`, `serve_retrieval`
- QRY apps: `query_chunks`, `query_sources`
- PRJ apps: `project_chunks`, `project_sources`
- Vertical-slice stubs for every desk; commands + events + handlers +
  API handlers shaped, business logic empty.
- `manifest.json` registering the plugin as `in_vm`, group `KNOW`.

### Planned
- Wire `hecate_vector` + `hecate_embed` deps once both publish to hex
- Implement `serve_retrieval` end-to-end against the local index
- Federation desk (`federate_retrieval`) once `macula-rag` ships
- SvelteKit search UI talking to the SSE bridge

## [0.1.0] - YYYY-MM-DD

_Not yet released._
