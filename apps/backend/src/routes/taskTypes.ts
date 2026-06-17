import { Router } from 'express'
import { listTaskTypes, createTaskType } from '../controllers/taskTypeController'
import { requireAuth } from '../middlewares/auth'

export const taskTypeRoutes = Router()

taskTypeRoutes.use(requireAuth)

taskTypeRoutes.get('/', listTaskTypes)
taskTypeRoutes.post('/', createTaskType)
