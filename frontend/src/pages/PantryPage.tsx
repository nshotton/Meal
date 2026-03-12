import { Package, Plus } from 'lucide-react'

const PantryPage = () => {
  return (
    <div className="p-4">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Pantry</h1>
          <p className="text-gray-600 text-sm">
            Track leftover ingredients and their costs
          </p>
        </div>
        <button className="flex items-center justify-center w-12 h-12 bg-primary-600 text-white rounded-full shadow-lg active:bg-primary-700 transition-colors">
          <Plus className="w-6 h-6" />
        </button>
      </div>

      {/* Empty state */}
      <div className="mt-12 text-center">
        <div className="inline-flex items-center justify-center w-16 h-16 bg-gray-100 rounded-full mb-4">
          <Package className="w-8 h-8 text-gray-400" />
        </div>
        <h3 className="text-lg font-semibold text-gray-900 mb-2">
          Pantry is empty
        </h3>
        <p className="text-gray-500 text-sm max-w-xs mx-auto">
          Leftover ingredients from receipts will appear here
        </p>
      </div>
    </div>
  )
}

export default PantryPage
