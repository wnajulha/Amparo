import { Response } from 'express'
import { z } from 'zod'
import prisma from '../lib/prisma'
import { AuthRequest } from '../middlewares/auth'

const createTaskTypeSchema = z.object({
  name: z.string().min(1),
  familyId: z.string(),
})

export async function listTaskTypes(req: AuthRequest, res: Response) {
  const taskTypes = await prisma.taskType.findMany({
    orderBy: [{ isDefault: 'desc' }, { name: 'asc' }],
  })
  res.json(taskTypes)
}

export async function createTaskType(req: AuthRequest, res: Response) {
  const parsed = createTaskTypeSchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  // Apenas ADMINs podem criar novos tipos (R06)
  const member = await prisma.familyMember.findFirst({
    where: { familyId: parsed.data.familyId, userId: req.userId },
  })
  if (!member || member.role !== 'ADMIN') {
    res.status(403).json({ error: 'Apenas administradores podem criar tipos de tarefa' })
    return
  }

  const taskType = await prisma.taskType.create({
    data: { name: parsed.data.name, isDefault: false },
  })

  res.status(201).json(taskType)
}
