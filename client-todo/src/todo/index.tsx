import { useState } from 'react';
import useSWR, { mutate } from 'swr';
import TodoForm from './components/form';
import List from './components/list';
import { NewTodo, Todo } from './models';
import { API_URL, addTodo, deleteTodo } from './service';
import { fetcher } from './api';

console.log('SRC/TODO: API_URL', API_URL);

export default function Todo() {
    const [requestError, setRequestError] = useState('');
    const { data, error, isLoading } = useSWR(API_URL, fetcher)

    async function handleSubmit(newTodoItem: NewTodo) {
        setRequestError('');

        try {
            const result = await addTodo(newTodoItem);

            if (!result.ok) throw new Error(`result: ${result.status} ${result.statusText}`);
            const savedTodo = await result.json();
            mutate(API_URL, [...data, savedTodo], false);

        } catch (error: unknown) {
            setRequestError(String(error));
        }
    }

    async function handleDelete(id: number) {
        setRequestError('');
        try {
            const result = await deleteTodo(id);
            if (!result.ok) throw new Error(`result: ${result.status} ${result.statusText}`);
            mutate(API_URL, data.filter((todo: Todo) => todo.id !== id), false);
        } catch (error: unknown) {
            setRequestError(String(error));
        }
    }

    if (error || requestError) return <div >failed to load {error ? JSON.stringify(error) : requestError}</div>
    if (!error && isLoading) return <div >loading...{JSON.stringify(isLoading)}</div>

    return (
        <div >
            <TodoForm onSubmit={handleSubmit} requestError={requestError} />
            <div >
                { data!==undefined 
                    && data.length>0 
                    && <List todos={data} onDelete={handleDelete} />
                }
            </div>
        </div>
    )
}
