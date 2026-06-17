import { Response } from 'express'
import { z } from 'zod'
import prisma from '../lib/prisma'
import { AuthRequest } from '../middlewares/auth'

const registerSchema = z.object({
  name: z.string().min(1),
})

export async function register(req: AuthRequest, res: Response) {
  const parsed = registerSchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  const existing = await prisma.user.findUnique({ where: { id: req.userId! } })
  if (existing) {
    res.status(409).json({ error: 'Usuário já cadastrado' })
    return
  }

  const user = await prisma.user.create({
    data: {
      id: req.userId!,
      email: req.supabaseUser!.email,
      name: parsed.data.name,
    },
  })

  res.status(201).json(user)
}

export async function me(req: AuthRequest, res: Response) {
  res.json(req.user)
}
