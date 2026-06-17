import { Request, Response, NextFunction } from 'express'
import { supabase } from '../lib/supabase'
import prisma from '../lib/prisma'

export interface AuthRequest extends Request {
  userId?: string
  user?: { id: string; email: string; name: string }
  supabaseUser?: { id: string; email: string }
}

// Valida o JWT Supabase sem exigir que o usuário exista no Prisma.
// Usado na rota de register, onde o usuário ainda não existe no banco local.
export async function requireSupabaseAuth(req: AuthRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization

  if (!authHeader?.startsWith('Bearer ')) {
    res.status(401).json({ error: 'Token de autenticação ausente' })
    return
  }

  const token = authHeader.replace('Bearer ', '')
  const { data, error } = await supabase.auth.getUser(token)

  if (error || !data.user) {
    res.status(401).json({ error: 'Token inválido ou expirado' })
    return
  }

  req.userId = data.user.id
  req.supabaseUser = { id: data.user.id, email: data.user.email ?? '' }
  next()
}

// Valida o JWT Supabase E exige que o usuário exista no Prisma.
export async function requireAuth(req: AuthRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization

  if (!authHeader?.startsWith('Bearer ')) {
    res.status(401).json({ error: 'Token de autenticação ausente' })
    return
  }

  const token = authHeader.replace('Bearer ', '')

  const { data, error } = await supabase.auth.getUser(token)

  if (error || !data.user) {
    res.status(401).json({ error: 'Token inválido ou expirado' })
    return
  }

  const user = await prisma.user.findUnique({ where: { id: data.user.id } })

  if (!user) {
    res.status(401).json({ error: 'Usuário não cadastrado no sistema' })
    return
  }

  req.userId = user.id
  req.user = user
  next()
}
