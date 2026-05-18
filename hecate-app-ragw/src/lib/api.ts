// Thin HTTP client for hecate-app-ragd.
//
// All endpoints are mounted at /apps/hecate-app-rag/api/ by the
// Hecate daemon's plugin router.

const BASE = '/apps/hecate-app-rag/api';

export type Hit = {
    chunk_id: string;
    source_path: string;
    score: number;
    content: string;
    headings?: string[];
};

export type QueryResult = {
    query: string;
    hits: Hit[];
};

export async function search(query: string, topK = 5): Promise<QueryResult> {
    const r = await fetch(`${BASE}/queries/answer`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ query_id: crypto.randomUUID(), query_text: query, top_k: topK })
    });
    if (!r.ok) throw new Error(`search failed: ${r.status}`);
    return r.json();
}

export async function getChunk(chunkId: string): Promise<Hit> {
    const r = await fetch(`${BASE}/chunks/${encodeURIComponent(chunkId)}`);
    if (!r.ok) throw new Error(`getChunk failed: ${r.status}`);
    return r.json();
}

export function eventStream(): EventSource {
    return new EventSource(`${BASE}/events/stream`);
}
