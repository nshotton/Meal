import { DollarSign, TrendingUp, Package } from 'lucide-react'

const SummaryPage = () => {
  return (
    <div className="p-4">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">Summary</h1>
        <p className="text-gray-600 text-sm">
          Your spending overview
        </p>
      </div>

      {/* Stats cards */}
      <div className="grid grid-cols-1 gap-4 mb-6">
        <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600 mb-1">Total Spent</p>
              <p className="text-3xl font-bold text-gray-900">$0.00</p>
            </div>
            <div className="flex items-center justify-center w-12 h-12 bg-primary-100 rounded-full">
              <DollarSign className="w-6 h-6 text-primary-600" />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600 mb-1">Avg Cost per Meal</p>
              <p className="text-3xl font-bold text-gray-900">$0.00</p>
            </div>
            <div className="flex items-center justify-center w-12 h-12 bg-blue-100 rounded-full">
              <TrendingUp className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-200">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600 mb-1">Pantry Value</p>
              <p className="text-3xl font-bold text-gray-900">$0.00</p>
            </div>
            <div className="flex items-center justify-center w-12 h-12 bg-orange-100 rounded-full">
              <Package className="w-6 h-6 text-orange-600" />
            </div>
          </div>
        </div>
      </div>

      {/* Empty state */}
      <div className="mt-8 text-center p-8 bg-gray-50 rounded-xl">
        <p className="text-gray-500 text-sm">
          Start scanning receipts to see your spending analytics
        </p>
      </div>
    </div>
  )
}

export default SummaryPage
