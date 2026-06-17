import { Response } from 'express'
import { z } from 'zod'
import prisma from '../lib/prisma'
import { AuthRequest } from '../middlewares/auth'

const createFamilySchema = z.object({
  name: z.string().min(1),
})

const addMemberSchema = z.object({
  userId: z.string(),
})

const updateRoleSchema = z.object({
  role: z.enum(['ADMIN', 'MEMBER']),
})

export async function listMyFamilies(req: AuthRequest, res: Response) {
  const memberships = await prisma.familyMember.findMany({
    where: { userId: req.userId },
    include: {
      family: {
        include: {
          members: { include: { user: true } },
          elderly: true,
        },
      },
    },
  })
  res.json(memberships.map((m) => m.family))
}

export async function createFamily(req: AuthRequest, res: Response) {
  const parsed = createFamilySchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  const family = await prisma.family.create({
    data: {
      name: parsed.data.name,
      members: {
        create: {
          userId: req.userId!,
          role: 'ADMIN',
        },
      },
    },
    include: { members: { include: { user: true } } },
  })

  res.status(201).json(family)
}

export async function getFamily(req: AuthRequest, res: Response) {
  const family = await prisma.family.findUnique({
    where: { id: req.params.id },
    include: {
      members: { include: { user: true } },
      elderly: true,
    },
  })

  if (!family) {
    res.status(404).json({ error: 'Família não encontrada' })
    return
  }

  const isMember = family.members.some((m) => m.userId === req.userId)
  if (!isMember) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  res.json(family)
}

export async function addMember(req: AuthRequest, res: Response) {
  const parsed = addMemberSchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  const requester = await prisma.familyMember.findFirst({
    where: { familyId: req.params.id, userId: req.userId },
  })
  if (!requester || requester.role !== 'ADMIN') {
    res.status(403).json({ error: 'Apenas administradores podem adicionar membros' })
    return
  }

  const member = await prisma.familyMember.create({
    data: {
      familyId: req.params.id,
      userId: parsed.data.userId,
    },
    include: { user: true },
  })

  res.status(201).json(member)
}

export async function updateMemberRole(req: AuthRequest, res: Response) {
  const parsed = updateRoleSchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  const requester = await prisma.familyMember.findFirst({
    where: { familyId: req.params.id, userId: req.userId },
  })
  if (!requester || requester.role !== 'ADMIN') {
    res.status(403).json({ error: 'Apenas administradores podem alterar papéis' })
    return
  }

  // Garante que sempre há ≥1 ADMIN (R03)
  if (parsed.data.role === 'MEMBER') {
    const adminCount = await prisma.familyMember.count({
      where: { familyId: req.params.id, role: 'ADMIN' },
    })
    const target = await prisma.familyMember.findUnique({ where: { id: req.params.memberId } })
    if (adminCount <= 1 && target?.role === 'ADMIN') {
      res.status(409).json({ error: 'A família precisa ter pelo menos um administrador' })
      return
    }
  }

  const member = await prisma.familyMember.update({
    where: { id: req.params.memberId },
    data: { role: parsed.data.role },
    include: { user: true },
  })

  res.json(member)
}

export async function removeMember(req: AuthRequest, res: Response) {
  const requester = await prisma.familyMember.findFirst({
    where: { familyId: req.params.id, userId: req.userId },
  })
  if (!requester || requester.role !== 'ADMIN') {
    res.status(403).json({ error: 'Apenas administradores podem remover membros' })
    return
  }

  const target = await prisma.familyMember.findUnique({ where: { id: req.params.memberId } })

  // Garante que sempre há ≥1 ADMIN (R03)
  if (target?.role === 'ADMIN') {
    const adminCount = await prisma.familyMember.count({
      where: { familyId: req.params.id, role: 'ADMIN' },
    })
    if (adminCount <= 1) {
      res.status(409).json({ error: 'A família precisa ter pelo menos um administrador' })
      return
    }
  }

  await prisma.familyMember.delete({ where: { id: req.params.memberId } })

  res.status(204).send()
}
