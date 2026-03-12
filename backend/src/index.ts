import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import { PrismaClient } from '@prisma/client'

dotenv.config()

const app = express()
const prisma = new PrismaClient()
const PORT = process.env.PORT || 3001

// Middleware
app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Meal Prep Tracker API is running' })
})

// Routes
app.get('/api/receipts', async (req, res) => {
  try {
    const receipts = await prisma.receipt.findMany({
      include: {
        lineItems: true,
      },
      orderBy: {
        date: 'desc',
      },
    })
    res.json(receipts)
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch receipts' })
  }
})

app.get('/api/meals', async (req, res) => {
  try {
    const meals = await prisma.meal.findMany({
      include: {
        mealAllocations: {
          include: {
            lineItem: true,
          },
        },
        pantryAllocations: {
          include: {
            pantryItem: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    })
    res.json(meals)
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch meals' })
  }
})

app.get('/api/pantry', async (req, res) => {
  try {
    const pantryItems = await prisma.pantryItem.findMany({
      where: {
        remainingQuantity: {
          gt: 0,
        },
      },
      orderBy: {
        purchaseDate: 'desc',
      },
    })
    res.json(pantryItems)
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch pantry items' })
  }
})

app.get('/api/summary', async (req, res) => {
  try {
    const totalSpent = await prisma.receipt.aggregate({
      _sum: {
        totalAmount: true,
      },
    })

    const pantryValue = await prisma.pantryItem.aggregate({
      _sum: {
        remainingCost: true,
      },
    })

    const mealsCount = await prisma.meal.count()

    res.json({
      totalSpent: totalSpent._sum.totalAmount || 0,
      pantryValue: pantryValue._sum.remainingCost || 0,
      mealsCount,
      avgCostPerMeal:
        mealsCount > 0 ? (totalSpent._sum.totalAmount || 0) / mealsCount : 0,
    })
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch summary' })
  }
})

// Error handling
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack)
  res.status(500).json({ error: 'Something went wrong!' })
})

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`)
  console.log(`📊 API available at http://localhost:${PORT}/api`)
})

// Graceful shutdown
process.on('SIGINT', async () => {
  await prisma.$disconnect()
  process.exit(0)
})
