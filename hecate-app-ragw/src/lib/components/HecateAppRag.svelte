<svelte:options customElement="hecate-app-rag" />

<script lang="ts">
    import SearchBar from './SearchBar.svelte';
    import ResultCard from './ResultCard.svelte';
    import SourcePreview from './SourcePreview.svelte';
    import { lastResult, selectedHit } from '../stores/rag';
</script>

<div class="rag-root">
    <header class="rag-header">
        <h1>RAG</h1>
        <p class="rag-tagline">Local semantic search over the configured corpus</p>
    </header>

    <SearchBar />

    <main class="rag-main">
        <section class="rag-results">
            {#if $lastResult}
                {#each $lastResult.hits as hit (hit.chunk_id)}
                    <ResultCard {hit} on:select={() => selectedHit.set(hit)} />
                {/each}
                {#if $lastResult.hits.length === 0}
                    <p class="rag-empty">No results.</p>
                {/if}
            {:else}
                <p class="rag-empty">Search the corpus.</p>
            {/if}
        </section>

        <aside class="rag-preview">
            {#if $selectedHit}
                <SourcePreview hit={$selectedHit} />
            {/if}
        </aside>
    </main>
</div>

<style>
    .rag-root {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        padding: 1rem;
        font: 14px/1.5 system-ui, sans-serif;
    }
    .rag-header h1 { margin: 0; font-size: 1.4rem; }
    .rag-tagline   { margin: 0; color: #888; }
    .rag-main      { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
    .rag-results   { display: flex; flex-direction: column; gap: 0.5rem; }
    .rag-empty     { color: #aaa; font-style: italic; }
</style>
