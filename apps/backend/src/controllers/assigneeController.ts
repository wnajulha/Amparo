import { Response } from 'express'
import { z } from 'zod'
import prisma from '../lib/prisma'
import { AuthRequest } from '../middlewares/auth'

const addAssigneeSchema = z.object({
  memberId: z.string(),
})

export async function addAssignee(req: AuthRequest, res: Response) {
  const { taskId } = req.params
  const parsed = addAssigneeSchema.safeParse(req.body)
  if (!parsed.success) {
    res.status(400).json({ error: parsed.error.flatten() })
    return
  }

  const task = await prisma.task.findUnique({
    where: { id: taskId },
    include: { elderly: { include: { family: { include: { members: true } } } } },
  })
  if (!task) {
    res.status(404).json({ error: 'Tarefa não encontrada' })
    return
  }

  const requester = task.elderly.family.members.find((m) => m.userId === req.userId)
  if (!requester) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const assignment = await prisma.taskAssignment.create({
    data: {
      taskId,
      memberId: parsed.data.memberId,
      userId: req.userId!,
    },
    include: { member: { include: { user: true } } },
  })

  res.status(201).json(assignment)
}

export async function removeAssignee(req: AuthRequest, res: Response) {
  const { taskId, memberId } = req.params

  const task = await prisma.task.findUnique({
    where: { id: taskId },
    include: { elderly: { include: { family: { include: { members: true } } } } },
  })
  if (!task) {
    res.status(404).json({ error: 'Tarefa não encontrada' })
    return
  }

  const requester = task.elderly.family.members.find((m) => m.userId === req.userId)
  if (!requester) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const targetMember = task.elderly.family.members.find((m) => m.id === memberId)

  // R09: só pode remover a si mesmo ou ADMIN pode remover qualquer um
  const isSelf = targetMember?.userId === req.userId
  const isAdmin = requester.role === 'ADMIN'
  if (!isSelf && !isAdmin) {
    res.status(403).json({ error: 'Apenas o próprio responsável ou um administrador pode remover o vínculo' })
    return
  }

  // Garante ≥1 responsável (R09)
  const assignmentCount = await prisma.taskAssignment.count({ where: { taskId } })
  if (assignmentCount <= 1) {
    res.status(409).json({ error: 'A tarefa precisa ter pelo menos um responsável' })
    return
  }

  await prisma.taskAssignment.deleteMany({ where: { taskId, memberId } })

  res.status(204).send()
}
