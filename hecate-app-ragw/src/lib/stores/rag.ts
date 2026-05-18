import { writable } from 'svelte/store';
import type { QueryResult, Hit } from '../api';

export const lastQuery = writable<string>('');
export const lastResult = writable<QueryResult | null>(null);
export const selectedHit = writable<Hit | null>(null);
export const isSearching = writable<boolean>(false);
