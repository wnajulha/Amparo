import { Router } from 'express'
import { getElderly, updateElderly } from '../controllers/elderlyController'
import { requireAuth } from '../middlewares/auth'

export const elderlyRoutes = Router()

elderlyRoutes.use(requireAuth)

elderlyRoutes.get('/:id', getElderly)
elderlyRoutes.patch('/:id', updateElderly)
