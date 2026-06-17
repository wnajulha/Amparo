import express from 'express'
import { authRoutes } from './routes/auth'
import { familyRoutes } from './routes/families'
import { elderlyRoutes } from './routes/elderly'
import { taskTypeRoutes } from './routes/taskTypes'
import { taskRoutes } from './routes/tasks'
import { documentRoutes } from './routes/documents'
import { errorHandler } from './middlewares/errorHandler'

const app = express()
const PORT = process.env.PORT || 3000

app.use(express.json())

app.use('/api/auth', authRoutes)
app.use('/api/families', familyRoutes)
app.use('/api/elderly', elderlyRoutes)
app.use('/api/task-types', taskTypeRoutes)
app.use('/api', taskRoutes)
app.use('/api', documentRoutes)

app.use(errorHandler)

app.listen(PORT, () => {
  console.log(`Amparo API running on port ${PORT}`)
})

export default app
