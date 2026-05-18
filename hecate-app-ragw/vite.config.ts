import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

export default defineConfig({
    plugins: [tailwindcss(), sveltekit()],
    server: {
        port: 5193,
        proxy: {
            '/apps/hecate-app-rag/api': 'http://localhost:8123'
        }
    }
});
