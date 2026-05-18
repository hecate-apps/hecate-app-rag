<script lang="ts">
    import type { Hit } from '../api';

    let { hit }: { hit: Hit } = $props();
</script>

<article class="preview">
    <header>
        <h2 class="path">{hit.source_path}</h2>
        {#if hit.headings && hit.headings.length}
            <p class="breadcrumbs">{hit.headings.join(' › ')}</p>
        {/if}
    </header>
    <pre class="content">{hit.content}</pre>
</article>

<style>
    .preview {
        border: 1px solid #e0e0e0;
        border-radius: 6px;
        padding: 1rem;
        background: white;
        max-height: 80vh;
        overflow: auto;
    }
    .path        { margin: 0; font-family: ui-monospace, monospace; font-size: 0.95rem; }
    .breadcrumbs { margin: 0.25rem 0 0; color: #888; font-size: 0.85rem; }
    .content     { margin: 1rem 0 0; font: 13px/1.6 ui-monospace, monospace; white-space: pre-wrap; }
</style>
