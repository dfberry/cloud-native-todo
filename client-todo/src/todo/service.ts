import { NewTodo } from './models';
import { ENV_URL } from '../config';



export const API_BASE_URL = ENV_URL;
export const API_URL = `${ENV_URL}/todo`;
console.log('SRC/todo/service: API_URL is defined as', API_URL);

export const listTodos = async (): Promise<Response> => {
  return await fetch(API_URL);
}
export const addTodo = async (newTodo: NewTodo): Promise<Response> => {
  return await fetch(API_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(newTodo),
  });
};
export const deleteTodo = async (id: number): Promise<Response> => {
  return await fetch(`${API_URL}/${id}`, {
    method: 'DELETE',
  });
};
export const isServerAvailable = async (): Promise<boolean> => {
  try {
    console.log('Checking server availability...' + ENV_URL)
    const response = await fetch(ENV_URL);
    console.log('Server response:', response);
    return response.ok; // Returns true if the status is 2xx, false otherwise.
  } catch (error) {
    console.error('Error checking server availability:', error);
    return false;
  }
};