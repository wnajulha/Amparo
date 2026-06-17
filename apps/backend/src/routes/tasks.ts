import { Router } from 'express'
import {
  createTask,
  listTasks,
  getTask,
  updateTask,
  deleteTask,
  completeTask,
} from '../controllers/taskController'
import { addAssignee, removeAssignee } from '../controllers/assigneeController'
import { requireAuth } from '../middlewares/auth'

export const taskRoutes = Router()

taskRoutes.use(requireAuth)

taskRoutes.post('/elderly/:elderlyId/tasks', createTask)
taskRoutes.get('/elderly/:elderlyId/tasks', listTasks)
taskRoutes.get('/elderly/:elderlyId/tasks/:id', getTask)
taskRoutes.patch('/elderly/:elderlyId/tasks/:id', updateTask)
taskRoutes.delete('/elderly/:elderlyId/tasks/:id', deleteTask)
taskRoutes.patch('/elderly/:elderlyId/tasks/:id/complete', completeTask)

taskRoutes.post('/tasks/:taskId/assignees', addAssignee)
taskRoutes.delete('/tasks/:taskId/assignees/:memberId', removeAssignee)
