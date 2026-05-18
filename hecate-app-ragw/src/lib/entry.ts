// Custom-element entry. Imported by vite.config.lib.ts to build the
// embeddable bundle that the Hecate shell mounts into the daemon UI.

import HecateAppRag from './components/HecateAppRag.svelte';

export { HecateAppRag };

// The svelte compiler emits <hecate-app-rag> for any component whose
// <svelte:options customElement="..."> tag declares the tag name.
// HecateAppRag.svelte does this; the import side-effect registers it.
