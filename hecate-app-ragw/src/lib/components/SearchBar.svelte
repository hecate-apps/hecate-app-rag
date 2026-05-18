<script lang="ts">
    import { search } from '../api';
    import { lastQuery, lastResult, isSearching } from '../stores/rag';

    let value = $state('');

    async function onSubmit(e: SubmitEvent) {
        e.preventDefault();
        if (!value.trim()) return;
        lastQuery.set(value);
        isSearching.set(true);
        try {
            const result = await search(value, 10);
            lastResult.set(result);
        } finally {
            isSearching.set(false);
        }
    }
</script>

<form class="search-bar" onsubmit={onSubmit}>
    <input
        type="search"
        bind:value
        placeholder="Search the corpus…"
        aria-label="Query"
    />
    <button type="submit" disabled={$isSearching}>
        {$isSearching ? 'Searching…' : 'Search'}
    </button>
</form>

<style>
    .search-bar { display: flex; gap: 0.5rem; }
    input       { flex: 1; padding: 0.5rem 0.75rem; font-size: 1rem; }
    button      { padding: 0.5rem 1rem; font-size: 1rem; }
</style>
