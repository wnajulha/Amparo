import { PrismaClient, BaseTaskType } from '@prisma/client'

const prisma = new PrismaClient()

const defaultTaskTypes: { name: string; baseType: BaseTaskType }[] = [
  { name: 'Administração de Medicamentos', baseType: 'MEDICATION' },
  { name: 'Consultas Médicas', baseType: 'MEDICAL_APPT' },
  { name: 'Atividades Físicas', baseType: 'PHYSICAL' },
  { name: 'Rotinas Alimentares', baseType: 'NUTRITION' },
  { name: 'Exames Periódicos', baseType: 'EXAM' },
  { name: 'Compromissos Diversos', baseType: 'GENERAL' },
]

async function main() {
  for (const type of defaultTaskTypes) {
    await prisma.taskType.upsert({
      where: { id: type.baseType },
      update: {},
      create: {
        id: type.baseType,
        name: type.name,
        baseType: type.baseType,
        isDefault: true,
      },
    })
  }
  console.log('Seed concluído: tipos de tarefa base criados.')
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect())
