import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Layout from './components/Layout'
import ReceiptsPage from './pages/ReceiptsPage'
import MealsPage from './pages/MealsPage'
import PantryPage from './pages/PantryPage'
import SummaryPage from './pages/SummaryPage'

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Navigate to="/receipts" replace />} />
          <Route path="receipts" element={<ReceiptsPage />} />
          <Route path="meals" element={<MealsPage />} />
          <Route path="pantry" element={<PantryPage />} />
          <Route path="summary" element={<SummaryPage />} />
        </Route>
      </Routes>
    </Router>
  )
}

export default App
