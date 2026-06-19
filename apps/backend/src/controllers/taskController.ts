import { Response } from 'express'
import { z } from 'zod'
import prisma from '../lib/prisma'
import { AuthRequest } from '../middlewares/auth'
import { computeTaskStatus } from '../services/taskStatus'

const createTaskSchema = z.object({
  name: z.string().min(1),
  taskTypeId: z.string(),
  frequency: z.enum(['ONE_TIME', 'DAILY', 'WEEKLY', 'MONTHLY']),
  startDate: z.string().datetime(),
  endDate: z.string().datetime(),
  assigneeIds: z.array(z.string()).min(1, 'A tarefa precisa de pelo menos um responsável'),
  familyId: z.string(),
})

async function getFamilyMember(elderlyId: string, userId: string) {
  const elderly = await prisma.elderly.findUnique({
    where: { id: elderlyId },
    include: { family: { include: { members: true } } },
  })
  if (!elderly) return null
  const member = elderly.family.members.find((m) => m.userId === userId)
  return { elderly, member: member ?? null }
}

export async function createTask(req: AuthRequest, res: Response) {
  try {
    const { elderlyId } = req.params
    const parsed = createTaskSchema.safeParse(req.body)
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.flatten() })
      return
    }

    const ctx = await getFamilyMember(elderlyId, req.userId!)
    if (!ctx || !ctx.member) {
      res.status(403).json({ error: 'Acesso negado' })
      return
    }

    const task = await prisma.task.create({
      data: {
        name: parsed.data.name,
        taskTypeId: parsed.data.taskTypeId,
        frequency: parsed.data.frequency,
        startDate: new Date(parsed.data.startDate),
        endDate: new Date(parsed.data.endDate),
        elderlyId,
        creatorId: req.userId!,
        familyMemberCreatorId: ctx.member.id,
        assignments: {
          create: parsed.data.assigneeIds.map((memberId) => ({
            memberId,
            userId: req.userId!,
          })),
        },
      },
      include: { taskType: true, assignments: { include: { member: { include: { user: true } } } } },
    })

    res.status(201).json({ ...task, status: computeTaskStatus(task) })
  } catch (error) {
    console.error('createTask error:', error)
    res.status(500).json({ error: 'Erro interno ao criar tarefa' })
  }
}

export async function listTasks(req: AuthRequest, res: Response) {
  try {
    const { elderlyId } = req.params

    const ctx = await getFamilyMember(elderlyId, req.userId!)
    if (!ctx || !ctx.member) {
      res.status(403).json({ error: 'Acesso negado' })
      return
    }

    const tasks = await prisma.task.findMany({
      where: { elderlyId },
      include: { taskType: true, assignments: { include: { member: { include: { user: true } } } } },
      orderBy: { startDate: 'asc' },
    })

    res.json(tasks.map((t) => ({ ...t, status: computeTaskStatus(t) })))
  } catch (error) {
    console.error('listTasks error:', error)
    res.status(500).json({ error: 'Erro interno ao listar tarefas' })
  }
}

export async function getTask(req: AuthRequest, res: Response) {
  try {
    const { elderlyId, id } = req.params

    const ctx = await getFamilyMember(elderlyId, req.userId!)
    if (!ctx || !ctx.member) {
      res.status(403).json({ error: 'Acesso negado' })
      return
    }

    const task = await prisma.task.findFirst({
      where: { id, elderlyId },
      include: { taskType: true, assignments: { include: { member: { include: { user: true } } } } },
    })

    if (!task) {
      res.status(404).json({ error: 'Tarefa não encontrada' })
      return
    }

    res.json({ ...task, status: computeTaskStatus(task) })
  } catch (error) {
    console.error('getTask error:', error)
    res.status(500).json({ error: 'Erro interno ao buscar tarefa' })
  }
}

export async function updateTask(req: AuthRequest, res: Response) {
  try {
    const { elderlyId, id } = req.params

    const ctx = await getFamilyMember(elderlyId, req.userId!)
    if (!ctx || !ctx.member) {
      res.status(403).json({ error: 'Acesso negado' })
      return
    }

    const task = await prisma.task.findFirst({ where: { id, elderlyId } })
    if (!task) {
      res.status(404).json({ error: 'Tarefa não encontrada' })
      return
    }

    // R05: apenas criador ou ADMIN pode editar
    const isCreator = task.familyMemberCreatorId === ctx.member.id
    const isAdmin = ctx.member.role === 'ADMIN'
    if (!isCreator && !isAdmin) {
      res.status(403).json({ error: 'Apenas o criador ou um administrador pode editar esta tarefa' })
      return
    }

    const updateSchema = createTaskSchema.omit({ assigneeIds: true, familyId: true }).partial()
    const parsed = updateSchema.safeParse(req.body)
    if (!parsed.success) {
      res.status(400).json({ error: parsed.error.flatten() })
      return
    }

    const updated = await prisma.task.update({
      where: { id },
      data: {
        ...parsed.data,
        startDate: parsed.data.startDate ? new Date(parsed.data.startDate) : undefined,
        endDate: parsed.data.endDate ? new Date(parsed.data.endDate) : undefined,
      },
      include: { taskType: true, assignments: { include: { member: { include: { user: true } } } } },
    })

    res.json({ ...updated, status: computeTaskStatus(updated) })
  } catch (error) {
    console.error('updateTask error:', error)
    res.status(500).json({ error: 'Erro interno ao atualizar tarefa' })
  }
}

export async function deleteTask(req: AuthRequest, res: Response) {
  try {
    const { elderlyId, id } = req.params

    const ctx = await getFamilyMember(elderlyId, req.userId!)
    if (!ctx || !ctx.member) {
      res.status(403).json({ error: 'Acesso negado' })
      return
    }

    const task = await prisma.task.findFirst({ where: { id, elderlyId } })
    if (!task) {
      res.status(404).json({ error: 'Tarefa não encontrada' })
      return
    }

    // R05: apenas criador ou ADMIN pode excluir
    const isCreator = task.familyMemberCreatorId === ctx.member.id
    const isAdmin = ctx.member.role === 'ADMIN'
    if (!isCreator && !isAdmin) {
      res.status(403).json({ error: 'Apenas o criador ou um administrador pode excluir esta tarefa' })
      return
    }

    await prisma.taskAssignment.deleteMany({ where: { taskId: id } })
    await prisma.task.delete({ where: { id } })

    res.status(204).send()
  } catch (error) {
    console.error('deleteTask error:', error)
    res.status(500).json({ error: 'Erro interno ao excluir tarefa' })
  }
}

export async function completeTask(req: AuthRequest, res: Response) {
  try {
    const { elderlyId, id } = req.params

    const ctx = await getFamilyMember(elderlyId, req.userId!)
    if (!ctx || !ctx.member) {
      res.status(403).json({ error: 'Acesso negado' })
      return
    }

    const task = await prisma.task.findFirst({ where: { id, elderlyId } })
    if (!task) {
      res.status(404).json({ error: 'Tarefa não encontrada' })
      return
    }

    const updated = await prisma.task.update({
      where: { id },
      data: { completedAt: new Date() },
      include: { taskType: true, assignments: { include: { member: { include: { user: true } } } } },
    })

    res.json({ ...updated, status: computeTaskStatus(updated) })
  } catch (error) {
    console.error('completeTask error:', error)
    res.status(500).json({ error: 'Erro interno ao completar tarefa' })
  }
}
