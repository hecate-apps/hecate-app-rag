// Build hecate-app-ragw as a custom-element library, dropped into
// the daemon's priv/web/ directory and embedded by the Hecate shell.

import { svelte } from '@sveltejs/vite-plugin-svelte';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
    plugins: [
        tailwindcss(),
        svelte({
            compilerOptions: { customElement: true }
        })
    ],
    build: {
        outDir: '../hecate-app-ragd/priv/web',
        emptyOutDir: true,
        lib: {
            entry: resolve(__dirname, 'src/lib/entry.ts'),
            name: 'HecateAppRag',
            fileName: () => 'hecate-app-rag.js',
            formats: ['es']
        }
    }
});
