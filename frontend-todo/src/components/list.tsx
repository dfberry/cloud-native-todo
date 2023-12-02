// new react component to list todos

import React from 'react';
import { Todo } from '../models/todo';
import { Item } from './item';

interface Props {
  todos: Todo[];
  //toggleTodo: (id: string) => void;
  //deleteTodo: (id: string) => void;
}

export const List: React.FC<Props> = ({ todos/*, toggleTodo, deleteTodo*/ }) => {
  return (
    <div>
      {todos.map((todo) => (
        <Item
          key={todo.id}
          todo={todo}
        />
      ))}
    </div>
  );
};