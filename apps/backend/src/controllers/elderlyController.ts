import { Response } from 'express'
import { z } from 'zod'
import prisma from '../lib/prisma'
import { AuthRequest } from '../middlewares/auth'

const emergencyContactSchema = z.object({
  name: z.string().min(1),
  phone: z.string().min(1),
  relationship: z.string().min(1),
})

const createElderlySchema = z.object({
  name: z.string().min(1),
  birthDate: z.string().datetime(),
  conditions: z.array(z.string()).min(1, 'Informe ao menos uma condição médica'),
  allergies: z.array(z.string()),
  emergencyContact: emergencyContactSchema,
})

async function assertFamilyMember(familyId: string, userId: string) {
  return prisma.familyMember.findFirst({ where: { familyId, userId } })
}

export async function createElderly(req: AuthRequest, res: Response) {
  const { familyId } = req.params
  const parsed = createElderlySchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  const member = await assertFamilyMember(familyId, req.userId!)
  if (!member) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const elderly = await prisma.elderly.create({
    data: {
      ...parsed.data,
      birthDate: new Date(parsed.data.birthDate),
      familyId,
    },
  })

  res.status(201).json(elderly)
}

export async function listElderly(req: AuthRequest, res: Response) {
  const { familyId } = req.params

  const member = await assertFamilyMember(familyId, req.userId!)
  if (!member) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const elderly = await prisma.elderly.findMany({ where: { familyId } })
  res.json(elderly)
}

export async function getElderly(req: AuthRequest, res: Response) {
  const elderly = await prisma.elderly.findUnique({
    where: { id: req.params.id },
    include: { family: { include: { members: true } } },
  })

  if (!elderly) {
    res.status(404).json({ error: 'Idoso não encontrado' })
    return
  }

  const isMember = elderly.family.members.some((m) => m.userId === req.userId)
  if (!isMember) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  res.json(elderly)
}

export async function updateElderly(req: AuthRequest, res: Response) {
  const elderly = await prisma.elderly.findUnique({
    where: { id: req.params.id },
    include: { family: { include: { members: true } } },
  })

  if (!elderly) {
    res.status(404).json({ error: 'Idoso não encontrado' })
    return
  }

  const isMember = elderly.family.members.some((m) => m.userId === req.userId)
  if (!isMember) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const updateSchema = createElderlySchema.partial()
  const parsed = updateSchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  const updated = await prisma.elderly.update({
    where: { id: req.params.id },
    data: {
      ...parsed.data,
      birthDate: parsed.data.birthDate ? new Date(parsed.data.birthDate) : undefined,
    },
  })

  res.json(updated)
}
