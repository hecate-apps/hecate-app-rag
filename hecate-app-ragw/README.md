# hecate-app-ragw

SvelteKit frontend for the `hecate-app-rag` Hecate plugin.

Built two ways:

1. **Dev / standalone** (`npm run dev`) — local SvelteKit server with
   proxy to a running `hecate-app-ragd` instance.
2. **Embedded** (`npm run build:lib`) — produces a single custom-element
   bundle in `../hecate-app-ragd/priv/web/`, which the Hecate shell
   mounts inside the daemon's UI.

## Build

```bash
npm install
npm run dev        # standalone, http://localhost:5193
npm run build:lib  # → ../hecate-app-ragd/priv/web/
```

## Layout

```
src/
├── app.html
├── routes/
│   └── +page.svelte        ← standalone page, dev only
└── lib/
    ├── entry.ts             ← custom-element registration
    ├── api.ts               ← thin client for /apps/hecate-app-rag/api/*
    ├── components/
    │   ├── SearchBar.svelte
    │   ├── ResultCard.svelte
    │   └── SourcePreview.svelte
    └── stores/
        └── rag.ts
```
