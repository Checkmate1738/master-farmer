import { useState } from 'react'


function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <p onClick={() => setCount(count += 1)}>{count}</p>
    </>
  )
}

export default App
