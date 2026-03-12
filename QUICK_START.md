# 🚀 Quick Start Guide - Local Testing

## Start the App in 3 Steps

### 1. Start the Backend API
```bash
cd backend
npm run dev
```
✅ Backend will run on: **http://localhost:3001**

### 2. Start the Frontend (in a new terminal)
```bash
cd frontend
npm run dev
```
✅ Frontend will run on: **http://localhost:5173**

### 3. Open in Browser
Open **http://localhost:5173** in your browser (works best on Chrome/Safari)

---

## Test on iPhone

### Option A: Using Local Network
1. Find your computer's IP address:
   - **Mac**: System Preferences → Network
   - **Windows**: Run `ipconfig` in Command Prompt
   - **Linux**: Run `ip addr show`

2. Start frontend with network access:
   ```bash
   cd frontend
   npm run dev -- --host
   ```

3. On your iPhone, open Safari and go to:
   ```
   http://YOUR_COMPUTER_IP:5173
   ```
   (Replace YOUR_COMPUTER_IP with your actual IP, e.g., `http://192.168.1.100:5173`)

### Option B: Install as PWA on iPhone
1. Open the app in Safari on iPhone
2. Tap the **Share** button (box with arrow)
3. Scroll down and tap **"Add to Home Screen"**
4. Tap **"Add"**
5. The app icon will appear on your home screen like a native app!

---

## What You'll See

### 📸 Receipts Tab
- Scan or upload grocery receipts
- (OCR feature coming soon)

### 🍱 Meals Tab
- Create and track your meal prep
- See cost per meal and per serving

### 🥫 Pantry Tab
- View leftover ingredients
- Track their remaining value

### 📊 Summary Tab
- See your total spending
- Average cost per meal
- Current pantry value

---

## Database

The app uses a local SQLite database at `backend/dev.db`. Your data is stored locally and never leaves your computer.

### View Database
```bash
cd backend
npm run db:studio
```
This opens Prisma Studio where you can view/edit your data.

---

## Troubleshooting

### Backend won't start
- Make sure you're in the `backend` directory
- Check if port 3001 is already in use
- Run `npm install` to ensure dependencies are installed

### Frontend shows errors
- Make sure the backend is running first
- Check if port 5173 is available
- Run `npm install` in the frontend directory

### Can't access from iPhone
- Make sure your iPhone is on the same WiFi network
- Check your computer's firewall settings
- Try disabling firewall temporarily to test

---

## Next Steps

1. ✅ Test the app locally
2. ✅ Try it on your iPhone
3. 📦 When ready, we can deploy it to your WordPress site!
