#!/bin/bash

echo "🍽️  Meal Prep Cost Tracker - Local Setup"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

echo -e "${GREEN}✓${NC} Node.js $(node --version) found"
echo ""

# Setup Backend
echo -e "${BLUE}📦 Setting up Backend...${NC}"
cd backend

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing backend dependencies..."
    npm install
fi

# Generate Prisma client
echo "Generating Prisma client..."
npx prisma generate

# Run migrations to create database
echo "Creating database..."
npx prisma migrate dev --name init

echo -e "${GREEN}✓${NC} Backend setup complete!"
echo ""

# Go back to root
cd ..

# Setup Frontend
echo -e "${BLUE}🎨 Setting up Frontend...${NC}"
cd frontend

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing frontend dependencies..."
    npm install
fi

echo -e "${GREEN}✓${NC} Frontend setup complete!"
echo ""

# Go back to root
cd ..

echo "========================================"
echo -e "${GREEN}✨ Setup Complete!${NC}"
echo ""
echo "To start the app:"
echo -e "  ${YELLOW}1. Terminal 1:${NC} cd backend && npm run dev"
echo -e "  ${YELLOW}2. Terminal 2:${NC} cd frontend && npm run dev"
echo ""
echo "Then open: http://localhost:5173"
echo ""
echo "Or use these shortcuts:"
echo -e "  ${YELLOW}npm run start:backend${NC}  (from root)"
echo -e "  ${YELLOW}npm run start:frontend${NC} (from root)"
echo "========================================"
