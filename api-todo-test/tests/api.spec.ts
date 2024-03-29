import { test, expect } from '@playwright/test';
import 'dotenv/config'

const baseURL = process.env.API_TODO_ENDPOINT || 'http://localhost:3000';
console.log('baseURL', baseURL);

test.use({
    baseURL: baseURL
});

test(`should get all todos from ${baseURL}/todos`, async ({ request }) => {
    const response = await request.get('/todos');
    expect(response.status()).toBe(200);

    const {data, error } = await response.json();

    expect(data.length).toBe(0);
    expect(error).toBeNull();
});