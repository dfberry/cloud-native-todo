import './App.css'
import { useState, useEffect} from 'react';
import Todo from './todo'
import { isServerAvailable, API_BASE_URL } from './todo/service';
import { version } from '../package.json';
console.log('SRC/APP: API_BASE_URL', API_BASE_URL);
console.log('SRC/APP: version', version);


function App() {
  const [serverAvailable, setServerAvailable] = useState(false);

  useEffect(() => {
    isServerAvailable().then((available) => {
      setServerAvailable(available);
    });
  }, []);

  if (process.env.NODE_ENV!=='production' && !serverAvailable) {
    return <div>API Server { API_BASE_URL} is not available. Please try again later.</div>;
  }

  return <div>{serverAvailable && <Todo />}</div>;
}

export default App;
