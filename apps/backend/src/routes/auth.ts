import { Router } from 'express'
import { register, me, login } from '../controllers/authController'
import { requireAuth, requireSupabaseAuth } from '../middlewares/auth'

export const authRoutes = Router()

authRoutes.post('/login', login)
authRoutes.post('/register', requireSupabaseAuth, register)
authRoutes.get('/me', requireAuth, me)
