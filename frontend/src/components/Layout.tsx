import { Outlet, NavLink } from 'react-router-dom'
import { Receipt, UtensilsCrossed, Package, BarChart3 } from 'lucide-react'

const Layout = () => {
  const navItems = [
    { path: '/receipts', icon: Receipt, label: 'Receipts' },
    { path: '/meals', icon: UtensilsCrossed, label: 'Meals' },
    { path: '/pantry', icon: Package, label: 'Pantry' },
    { path: '/summary', icon: BarChart3, label: 'Summary' },
  ]

  return (
    <div className="flex flex-col h-screen bg-gray-50">
      {/* Main content area */}
      <main className="flex-1 overflow-y-auto pb-20">
        <Outlet />
      </main>

      {/* Bottom navigation - iOS style */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 safe-area-inset-bottom">
        <div className="flex justify-around items-center h-16 max-w-screen-xl mx-auto">
          {navItems.map(({ path, icon: Icon, label }) => (
            <NavLink
              key={path}
              to={path}
              className={({ isActive }) =>
                `flex flex-col items-center justify-center flex-1 h-full transition-colors ${
                  isActive
                    ? 'text-primary-600'
                    : 'text-gray-500 active:text-gray-700'
                }`
              }
            >
              <Icon className="w-6 h-6 mb-1" />
              <span className="text-xs font-medium">{label}</span>
            </NavLink>
          ))}
        </div>
      </nav>
    </div>
  )
}

export default Layout
