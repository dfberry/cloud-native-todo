// component for todo item

import React from 'react';

import { Todo } from '../models/todo';

interface Props {
    todo: Todo;
  }

export const Item: React.FC<Props> = ({todo}) => {
  return (
    <div>
        <span>{todo.id}</span>
        <span>{todo.title}</span>
        <span>{todo.description}</span>
        <span>{todo.done}</span>
    </div>
  );
};