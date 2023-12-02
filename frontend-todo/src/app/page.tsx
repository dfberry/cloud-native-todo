"use client"
import React, { useEffect, useState } from 'react';
import { List } from '../components/list';
import useSWR, { mutate }  from 'swr'

export default function Home() {
  const [newTodo, setNewTodo] = useState('');
  const fetcher = (...args: [input: RequestInfo, init?: RequestInit]) => fetch(...args).then(res => res.json())
  const { data, error, isLoading } = useSWR(`${process.env.API_URL}/todo`, fetcher)

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    const newTodoItem = { name: newTodo };

    // Optimistically update the UI
    mutate(`${process.env.API_URL}/todo`, [...data, newTodoItem], false);

    // Send the new todo to the backend
    await fetch(`${process.env.API_URL}/todo`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(newTodoItem),
    });

    // Revalidate the data
    mutate(`${process.env.API_URL}/todo`);
  }

  if (error) return <div>failed to load</div>
  if (isLoading) return <div>loading...</div>

  return (
    <div>
      <h1>todos</h1>
      <form onSubmit={handleSubmit}>
        <label htmlFor="todoTitle">Title</label>
        <input
          id="todoTitle"
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="New todo"
        />
        <button type="submit">Add Todo</button>
      </form>
      <List todos={data} />
    </div>)
}
