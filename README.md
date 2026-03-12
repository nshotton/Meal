# 🍽️ Meal Prep Cost Tracker

A mobile-first web app for tracking meal prep costs by photographing grocery receipts, allocating ingredients to meals, and managing pantry leftovers.

## ✨ Features

- 📸 **Receipt Scanning** - Upload or capture grocery receipts
- 🍱 **Meal Tracking** - Track costs per meal and per serving
- 🥫 **Pantry Management** - Monitor leftover ingredients and their remaining value
- 📊 **Cost Analytics** - View spending summaries and trends
- 📱 **iPhone Optimized** - Mobile-first design with PWA support

## 🛠️ Tech Stack

### Frontend
- **React** with TypeScript
- **Vite** - Fast build tool
- **Tailwind CSS** - Mobile-first styling
- **React Router** - Navigation
- **Lucide React** - Icons
- **PWA** - Installable on iPhone

### Backend
- **Node.js** + **Express**
- **PostgreSQL** - Database
- **Prisma** - ORM
- **TypeScript**

## 📋 Prerequisites

- Node.js 18+ and npm
- PostgreSQL 14+
- (Optional) iPhone/mobile device for testing

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Meal
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env and add your PostgreSQL connection string

# Generate Prisma client
npm run prisma:generate

# Run database migrations
npm run prisma:migrate

# Start backend server
npm run dev
```

The API will be available at `http://localhost:3001`

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

The app will be available at `http://localhost:5173`

## 📱 Testing on iPhone

### Option 1: Local Network Access

1. Find your computer's local IP address:
   ```bash
   # On macOS/Linux
   ifconfig | grep "inet "
   # Look for something like 192.168.1.xxx
   ```

2. Update Vite config to expose the dev server:
   ```bash
   cd frontend
   npm run dev -- --host
   ```

3. On your iPhone, visit `http://YOUR_LOCAL_IP:5173`

### Option 2: Install as PWA

1. Open the app in Safari on iPhone
2. Tap the Share button
3. Tap "Add to Home Screen"
4. The app will now work like a native app!

## 🗄️ Database Schema

The app uses the following data models:

- **Receipt** - Scanned grocery receipts
- **LineItem** - Individual items from receipts
- **Meal** - Meal prep entries
- **MealAllocation** - Links ingredients to meals
- **PantryItem** - Leftover ingredients
- **PantryAllocation** - Pantry items used in meals

See `backend/prisma/schema.prisma` for the full schema.

## 📁 Project Structure

```
Meal/
├── frontend/              # React web app
│   ├── src/
│   │   ├── components/   # Reusable UI components
│   │   ├── pages/        # Page components
│   │   ├── App.tsx       # Main app component
│   │   └── main.tsx      # Entry point
│   ├── public/           # Static assets
│   └── package.json
│
├── backend/              # Express API
│   ├── src/
│   │   ├── routes/       # API routes
│   │   ├── controllers/  # Request handlers
│   │   └── index.ts      # Server entry point
│   ├── prisma/
│   │   └── schema.prisma # Database schema
│   └── package.json
│
└── README.md
```

## 🔧 Available Scripts

### Frontend

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build

### Backend

- `npm run dev` - Start development server with hot reload
- `npm run build` - Compile TypeScript
- `npm start` - Run production server
- `npm run prisma:generate` - Generate Prisma client
- `npm run prisma:migrate` - Run database migrations
- `npm run prisma:studio` - Open Prisma Studio (database GUI)

## 🎨 Mobile-First Design

The app is designed with iPhone users in mind:

- **Bottom Navigation** - iOS-style tab bar
- **Safe Area** - Respects iPhone notch and home indicator
- **Touch Optimized** - Large tap targets, smooth scrolling
- **Responsive** - Works on all screen sizes
- **PWA** - Can be installed on home screen

## 🔮 Future Enhancements

- [ ] Receipt OCR with Tesseract.js or Google Vision API
- [ ] Photo upload and storage
- [ ] Meal cost calculations
- [ ] Charts and analytics
- [ ] Export data (CSV, PDF)
- [ ] Multi-user support
- [ ] Dark mode

## 📝 License

ISC

## 🤝 Contributing

Contributions welcome! Please open an issue or submit a pull request.
