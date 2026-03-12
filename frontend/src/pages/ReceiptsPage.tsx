import { Camera, Upload } from 'lucide-react'

const ReceiptsPage = () => {
  return (
    <div className="p-4">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">Receipts</h1>
        <p className="text-gray-600 text-sm">
          Scan or upload grocery receipts to track costs
        </p>
      </div>

      {/* Action buttons */}
      <div className="grid grid-cols-2 gap-3 mb-6">
        <button className="flex flex-col items-center justify-center p-6 bg-primary-600 text-white rounded-xl shadow-sm active:bg-primary-700 transition-colors">
          <Camera className="w-8 h-8 mb-2" />
          <span className="font-medium">Scan Receipt</span>
        </button>
        <button className="flex flex-col items-center justify-center p-6 bg-white border-2 border-gray-300 text-gray-700 rounded-xl shadow-sm active:bg-gray-50 transition-colors">
          <Upload className="w-8 h-8 mb-2" />
          <span className="font-medium">Upload Photo</span>
        </button>
      </div>

      {/* Empty state */}
      <div className="mt-12 text-center">
        <div className="inline-flex items-center justify-center w-16 h-16 bg-gray-100 rounded-full mb-4">
          <Receipt className="w-8 h-8 text-gray-400" />
        </div>
        <h3 className="text-lg font-semibold text-gray-900 mb-2">
          No receipts yet
        </h3>
        <p className="text-gray-500 text-sm max-w-xs mx-auto">
          Start by scanning or uploading your first grocery receipt
        </p>
      </div>
    </div>
  )
}

export default ReceiptsPage
