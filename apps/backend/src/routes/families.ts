import { Router } from 'express'
import {
  listMyFamilies,
  createFamily,
  getFamily,
  addMember,
  updateMemberRole,
  removeMember,
} from '../controllers/familyController'
import { createElderly, listElderly } from '../controllers/elderlyController'
import { requireAuth } from '../middlewares/auth'

export const familyRoutes = Router()

familyRoutes.use(requireAuth)

familyRoutes.get('/mine', listMyFamilies)
familyRoutes.post('/', createFamily)
familyRoutes.get('/:id', getFamily)
familyRoutes.post('/:id/members', addMember)
familyRoutes.patch('/:id/members/:memberId', updateMemberRole)
familyRoutes.delete('/:id/members/:memberId', removeMember)

familyRoutes.post('/:familyId/elderly', createElderly)
familyRoutes.get('/:familyId/elderly', listElderly)
