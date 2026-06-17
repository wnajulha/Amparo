type TaskForStatus = {
  startDate: Date
  endDate: Date
  completedAt: Date | null
}

export function computeTaskStatus(task: TaskForStatus): 'PENDING' | 'IN_PROGRESS' | 'OVERDUE' | 'COMPLETED' {
  if (task.completedAt) return 'COMPLETED'

  const now = new Date()

  if (now < task.startDate) return 'PENDING'
  if (now > task.endDate) return 'OVERDUE'
  return 'IN_PROGRESS'
}
