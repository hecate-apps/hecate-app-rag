<script lang="ts">
    import type { Hit } from '../api';
    import { createEventDispatcher } from 'svelte';

    let { hit }: { hit: Hit } = $props();
    const dispatch = createEventDispatcher();
</script>

<button class="result-card" onclick={() => dispatch('select')}>
    <header>
        <span class="path">{hit.source_path}</span>
        <span class="score">{hit.score.toFixed(3)}</span>
    </header>
    <p class="snippet">{hit.content.slice(0, 240)}…</p>
</button>

<style>
    .result-card {
        display: block;
        width: 100%;
        text-align: left;
        padding: 0.75rem;
        border: 1px solid #e0e0e0;
        border-radius: 6px;
        background: white;
        cursor: pointer;
    }
    .result-card:hover { background: #fafafa; }
    header     { display: flex; justify-content: space-between; font-size: 0.85rem; color: #666; }
    .path      { font-family: ui-monospace, monospace; }
    .score     { color: #2563eb; font-weight: 600; }
    .snippet   { margin: 0.5rem 0 0; font-size: 0.9rem; color: #333; }
</style>
