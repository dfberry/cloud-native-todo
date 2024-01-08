export { };

declare global {
    interface Window {
        ENV_CONFIG: {
            VITE_API_URL: string;
        }
    }
}

const WINDOW_ENV_URL = window.ENV_CONFIG?.VITE_API_URL;
const IMPORT_META_ENV_URL: string = import.meta.env.VITE_API_URL;
const FALLBACK_URL:string = 'http://localhost:5173';

console.log('SRC/config: WINDOW_ENV_URL is defined as', WINDOW_ENV_URL);
console.log('SRC/config: IMPORT_META_ENV_URL is defined as', IMPORT_META_ENV_URL);
console.log('SRC/config: FALLBACK_URL is defined as', FALLBACK_URL);

export const ENV_URL = WINDOW_ENV_URL || IMPORT_META_ENV_URL || FALLBACK_URL;
console.log('SRC/config: ENV_URL is defined as', ENV_URL);
