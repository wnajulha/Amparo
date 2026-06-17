import swaggerUi from 'swagger-ui-express'
import { Express } from 'express'

const swaggerSpec = {
  openapi: '3.0.3',
  info: {
    title: 'Amparo API',
    description:
      'API REST do app Amparo — gestão de cuidados para idosos. Todas as rotas (exceto `/auth/register`) requerem autenticação via Bearer token JWT do Supabase.',
    version: '1.0.0',
  },
  servers: [
    {
      url: 'http://localhost:3000/api',
      description: 'Servidor local',
    },
  ],
  tags: [
    { name: 'Auth', description: 'Autenticação e registro de usuários' },
    { name: 'Families', description: 'Gerenciamento de famílias e membros' },
    { name: 'Elderly', description: 'Cadastro e gerenciamento de idosos' },
    { name: 'Tasks', description: 'Atividades/tarefas dos idosos' },
    { name: 'Task Types', description: 'Tipos de atividades' },
    { name: 'Assignees', description: 'Responsáveis por tarefas' },
    { name: 'Documents', description: 'Documentos dos idosos' },
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        description: 'Token JWT do Supabase. Obtenha via sign-in no Supabase.',
      },
    },
    schemas: {
      User: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'uuid-supabase' },
          email: { type: 'string', format: 'email', example: 'maria@email.com' },
          name: { type: 'string', example: 'Maria Silva' },
          createdAt: { type: 'string', format: 'date-time' },
        },
      },
      Family: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'cuid123' },
          name: { type: 'string', example: 'Família Silva' },
          createdAt: { type: 'string', format: 'date-time' },
          members: {
            type: 'array',
            items: { $ref: '#/components/schemas/FamilyMember' },
          },
          elderly: {
            type: 'array',
            items: { $ref: '#/components/schemas/Elderly' },
          },
        },
      },
      FamilyMember: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'cuid456' },
          role: { type: 'string', enum: ['ADMIN', 'MEMBER'], example: 'ADMIN' },
          joinedAt: { type: 'string', format: 'date-time' },
          userId: { type: 'string' },
          familyId: { type: 'string' },
          user: { $ref: '#/components/schemas/User' },
        },
      },
      EmergencyContact: {
        type: 'object',
        required: ['name', 'phone', 'relationship'],
        properties: {
          name: { type: 'string', example: 'João Silva' },
          phone: { type: 'string', example: '(11) 99999-9999' },
          relationship: { type: 'string', example: 'Filho' },
        },
      },
      Elderly: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'cuid789' },
          name: { type: 'string', example: 'Maria Aparecida Oliveira' },
          birthDate: { type: 'string', format: 'date-time', example: '1945-03-15T00:00:00.000Z' },
          conditions: {
            type: 'array',
            items: { type: 'string' },
            example: ['Hipertensão', 'Diabetes tipo 2'],
          },
          allergies: {
            type: 'array',
            items: { type: 'string' },
            example: ['Penicilina'],
          },
          emergencyContact: { $ref: '#/components/schemas/EmergencyContact' },
          createdAt: { type: 'string', format: 'date-time' },
          familyId: { type: 'string' },
        },
      },
      TaskType: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'cuidabc' },
          name: { type: 'string', example: 'Medicação' },
          baseType: {
            type: 'string',
            nullable: true,
            enum: ['MEDICATION', 'MEDICAL_APPT', 'PHYSICAL', 'NUTRITION', 'EXAM', 'GENERAL', null],
            example: 'MEDICATION',
          },
          isDefault: { type: 'boolean', example: true },
        },
      },
      Task: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'cuidtask1' },
          name: { type: 'string', example: 'Tomar Losartana 50mg' },
          frequency: {
            type: 'string',
            enum: ['ONE_TIME', 'DAILY', 'WEEKLY', 'MONTHLY'],
            example: 'DAILY',
          },
          startDate: { type: 'string', format: 'date-time' },
          endDate: { type: 'string', format: 'date-time' },
          completedAt: { type: 'string', format: 'date-time', nullable: true },
          status: {
            type: 'string',
            enum: ['PENDING', 'IN_PROGRESS', 'OVERDUE', 'COMPLETED'],
            example: 'IN_PROGRESS',
          },
          createdAt: { type: 'string', format: 'date-time' },
          elderlyId: { type: 'string' },
          taskTypeId: { type: 'string' },
          taskType: { $ref: '#/components/schemas/TaskType' },
          assignments: {
            type: 'array',
            items: { $ref: '#/components/schemas/TaskAssignment' },
          },
        },
      },
      TaskAssignment: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          assignedAt: { type: 'string', format: 'date-time' },
          taskId: { type: 'string' },
          memberId: { type: 'string' },
          userId: { type: 'string' },
          member: { $ref: '#/components/schemas/FamilyMember' },
          user: { $ref: '#/components/schemas/User' },
        },
      },
      Document: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'cuiddoc1' },
          name: { type: 'string', example: 'Exame de sangue.pdf' },
          fileUrl: { type: 'string', format: 'uri', example: 'https://supabase.co/storage/v1/...' },
          mimeType: { type: 'string', example: 'application/pdf' },
          sizeBytes: { type: 'integer', example: 204800 },
          uploadedAt: { type: 'string', format: 'date-time' },
          elderlyId: { type: 'string' },
        },
      },
      Error: {
        type: 'object',
        properties: {
          error: { type: 'string', example: 'Mensagem de erro' },
        },
      },
    },
  },
  security: [{ bearerAuth: [] }],
  paths: {
    // ── AUTH ──────────────────────────────────────────────────────────────────
    '/auth/register': {
      post: {
        tags: ['Auth'],
        summary: 'Registrar usuário',
        description:
          'Cria o usuário no banco de dados local após autenticação no Supabase. Deve ser chamado logo após o primeiro sign-in. Requer apenas o JWT do Supabase (não precisa existir no banco ainda).',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['name'],
                properties: {
                  name: { type: 'string', minLength: 1, example: 'Maria Silva' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Usuário criado com sucesso',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/User' } },
            },
          },
          '400': {
            description: 'Dados inválidos',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '401': {
            description: 'Token ausente ou inválido',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '409': {
            description: 'Usuário já registrado',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/auth/me': {
      get: {
        tags: ['Auth'],
        summary: 'Perfil do usuário autenticado',
        description: 'Retorna os dados do usuário logado.',
        responses: {
          '200': {
            description: 'Usuário atual',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/User' } },
            },
          },
          '401': {
            description: 'Não autenticado',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    // ── FAMILIES ─────────────────────────────────────────────────────────────
    '/families/mine': {
      get: {
        tags: ['Families'],
        summary: 'Listar minhas famílias',
        description: 'Retorna todas as famílias nas quais o usuário autenticado é membro.',
        responses: {
          '200': {
            description: 'Lista de famílias',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Family' } },
              },
            },
          },
        },
      },
    },
    '/families': {
      post: {
        tags: ['Families'],
        summary: 'Criar família',
        description: 'Cria uma nova família. O criador é automaticamente adicionado como ADMIN.',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['name'],
                properties: {
                  name: { type: 'string', minLength: 1, example: 'Família Oliveira' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Família criada',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Family' } },
            },
          },
          '400': {
            description: 'Dados inválidos',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/families/{id}': {
      get: {
        tags: ['Families'],
        summary: 'Buscar família por ID',
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string' }, description: 'ID da família' },
        ],
        responses: {
          '200': {
            description: 'Dados da família com membros e idosos',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Family' } },
            },
          },
          '403': {
            description: 'Usuário não é membro desta família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Família não encontrada',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/families/{id}/members': {
      post: {
        tags: ['Families'],
        summary: 'Adicionar membro à família',
        description: 'Somente ADMINs podem adicionar membros.',
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string' }, description: 'ID da família' },
        ],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['userId'],
                properties: {
                  userId: { type: 'string', example: 'uuid-supabase-do-usuario' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Membro adicionado',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/FamilyMember' } },
            },
          },
          '403': {
            description: 'Apenas ADMIN pode adicionar membros',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/families/{id}/members/{memberId}': {
      patch: {
        tags: ['Families'],
        summary: 'Atualizar papel do membro',
        description: 'Somente ADMINs podem alterar papéis. A família deve manter ao menos 1 ADMIN.',
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'memberId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['role'],
                properties: {
                  role: { type: 'string', enum: ['ADMIN', 'MEMBER'] },
                },
              },
            },
          },
        },
        responses: {
          '200': {
            description: 'Papel atualizado',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/FamilyMember' } },
            },
          },
          '403': {
            description: 'Apenas ADMIN pode alterar papéis',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '409': {
            description: 'Não é possível rebaixar o último ADMIN',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
      delete: {
        tags: ['Families'],
        summary: 'Remover membro da família',
        description: 'Somente ADMINs podem remover membros. O último ADMIN não pode ser removido.',
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'memberId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '204': { description: 'Membro removido' },
          '403': {
            description: 'Apenas ADMIN pode remover membros',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '409': {
            description: 'Não é possível remover o último ADMIN',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    // ── ELDERLY (via families) ────────────────────────────────────────────────
    '/families/{familyId}/elderly': {
      post: {
        tags: ['Elderly'],
        summary: 'Cadastrar idoso',
        description: 'Cria um novo idoso vinculado à família.',
        parameters: [
          { name: 'familyId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['name', 'birthDate', 'conditions', 'allergies', 'emergencyContact'],
                properties: {
                  name: { type: 'string', minLength: 1, example: 'Maria Aparecida Oliveira' },
                  birthDate: {
                    type: 'string',
                    format: 'date-time',
                    example: '1945-03-15T00:00:00.000Z',
                  },
                  conditions: {
                    type: 'array',
                    items: { type: 'string', minLength: 1 },
                    example: ['Hipertensão'],
                  },
                  allergies: {
                    type: 'array',
                    items: { type: 'string' },
                    example: ['Penicilina'],
                  },
                  emergencyContact: { $ref: '#/components/schemas/EmergencyContact' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Idoso criado',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Elderly' } },
            },
          },
          '400': {
            description: 'Dados inválidos',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '403': {
            description: 'Usuário não é membro desta família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
      get: {
        tags: ['Elderly'],
        summary: 'Listar idosos da família',
        parameters: [
          { name: 'familyId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'Lista de idosos',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Elderly' } },
              },
            },
          },
        },
      },
    },

    // ── ELDERLY (standalone) ─────────────────────────────────────────────────
    '/elderly/{id}': {
      get: {
        tags: ['Elderly'],
        summary: 'Buscar idoso por ID',
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'Dados do idoso',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Elderly' } },
            },
          },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Idoso não encontrado',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
      patch: {
        tags: ['Elderly'],
        summary: 'Atualizar dados do idoso',
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  name: { type: 'string', example: 'Maria Aparecida Oliveira' },
                  birthDate: { type: 'string', format: 'date-time' },
                  conditions: { type: 'array', items: { type: 'string' } },
                  allergies: { type: 'array', items: { type: 'string' } },
                  emergencyContact: { $ref: '#/components/schemas/EmergencyContact' },
                },
              },
            },
          },
        },
        responses: {
          '200': {
            description: 'Idoso atualizado',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Elderly' } },
            },
          },
          '400': {
            description: 'Dados inválidos',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Idoso não encontrado',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    // ── TASK TYPES ────────────────────────────────────────────────────────────
    '/task-types': {
      get: {
        tags: ['Task Types'],
        summary: 'Listar tipos de atividades',
        description: 'Retorna todos os tipos de atividades ordenados por padrão (defaults primeiro).',
        responses: {
          '200': {
            description: 'Lista de tipos de atividades',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/TaskType' } },
              },
            },
          },
        },
      },
      post: {
        tags: ['Task Types'],
        summary: 'Criar tipo de atividade',
        description: 'Somente membros ADMIN da família podem criar tipos personalizados.',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['name', 'familyId'],
                properties: {
                  name: { type: 'string', minLength: 1, example: 'Fisioterapia' },
                  familyId: { type: 'string', example: 'cuid123' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Tipo criado',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/TaskType' } },
            },
          },
          '403': {
            description: 'Apenas ADMIN pode criar tipos',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    // ── TASKS ─────────────────────────────────────────────────────────────────
    '/elderly/{elderlyId}/tasks': {
      post: {
        tags: ['Tasks'],
        summary: 'Criar atividade',
        description: 'Cria uma nova atividade para o idoso especificado.',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['name', 'taskTypeId', 'frequency', 'startDate', 'endDate', 'assigneeIds', 'familyId'],
                properties: {
                  name: { type: 'string', minLength: 1, example: 'Tomar Losartana 50mg' },
                  taskTypeId: { type: 'string', example: 'cuidabc' },
                  frequency: {
                    type: 'string',
                    enum: ['ONE_TIME', 'DAILY', 'WEEKLY', 'MONTHLY'],
                    example: 'DAILY',
                  },
                  startDate: { type: 'string', format: 'date-time', example: '2024-01-01T08:00:00.000Z' },
                  endDate: { type: 'string', format: 'date-time', example: '2024-12-31T08:00:00.000Z' },
                  assigneeIds: {
                    type: 'array',
                    items: { type: 'string' },
                    minItems: 1,
                    example: ['member-cuid-1'],
                    description: 'IDs dos FamilyMembers responsáveis (ao menos 1)',
                  },
                  familyId: { type: 'string', example: 'cuid123' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Atividade criada',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Task' } },
            },
          },
          '400': {
            description: 'Dados inválidos',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
      get: {
        tags: ['Tasks'],
        summary: 'Listar atividades do idoso',
        description: 'Retorna todas as atividades ordenadas por data de início (ASC). Cada tarefa inclui o status calculado.',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'Lista de atividades',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Task' } },
              },
            },
          },
        },
      },
    },
    '/elderly/{elderlyId}/tasks/{id}': {
      get: {
        tags: ['Tasks'],
        summary: 'Buscar atividade',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'Dados da atividade',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Task' } },
            },
          },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Atividade não encontrada',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
      patch: {
        tags: ['Tasks'],
        summary: 'Atualizar atividade',
        description: 'Somente o criador ou um ADMIN pode editar. Use `/complete` para marcar como concluída.',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  name: { type: 'string' },
                  taskTypeId: { type: 'string' },
                  frequency: { type: 'string', enum: ['ONE_TIME', 'DAILY', 'WEEKLY', 'MONTHLY'] },
                  startDate: { type: 'string', format: 'date-time' },
                  endDate: { type: 'string', format: 'date-time' },
                },
              },
            },
          },
        },
        responses: {
          '200': {
            description: 'Atividade atualizada',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Task' } },
            },
          },
          '403': {
            description: 'Usuário não tem permissão',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Atividade não encontrada',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
      delete: {
        tags: ['Tasks'],
        summary: 'Deletar atividade',
        description: 'Somente o criador ou um ADMIN pode deletar.',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '204': { description: 'Atividade deletada' },
          '403': {
            description: 'Usuário não tem permissão',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Atividade não encontrada',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/elderly/{elderlyId}/tasks/{id}/complete': {
      patch: {
        tags: ['Tasks'],
        summary: 'Marcar atividade como concluída',
        description: 'Define `completedAt` como a data/hora atual. O status passa a ser COMPLETED.',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'Atividade concluída',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Task' } },
            },
          },
          '404': {
            description: 'Atividade não encontrada',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    // ── ASSIGNEES ─────────────────────────────────────────────────────────────
    '/tasks/{taskId}/assignees': {
      post: {
        tags: ['Assignees'],
        summary: 'Adicionar responsável à atividade',
        parameters: [
          { name: 'taskId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['memberId'],
                properties: {
                  memberId: { type: 'string', example: 'cuid-member' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Responsável adicionado',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/TaskAssignment' } },
            },
          },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Tarefa não encontrada',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/tasks/{taskId}/assignees/{memberId}': {
      delete: {
        tags: ['Assignees'],
        summary: 'Remover responsável da atividade',
        description:
          'Um usuário pode remover apenas a si mesmo. ADMINs podem remover qualquer um. A tarefa deve ter ao menos 1 responsável.',
        parameters: [
          { name: 'taskId', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'memberId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '204': { description: 'Responsável removido' },
          '403': {
            description: 'Usuário não tem permissão para remover',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Tarefa não encontrada',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '409': {
            description: 'Não é possível remover o último responsável',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },

    // ── DOCUMENTS ─────────────────────────────────────────────────────────────
    '/elderly/{elderlyId}/documents': {
      get: {
        tags: ['Documents'],
        summary: 'Listar documentos do idoso',
        description: 'Retorna os documentos ordenados por data de upload (mais recente primeiro).',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'Lista de documentos',
            content: {
              'application/json': {
                schema: { type: 'array', items: { $ref: '#/components/schemas/Document' } },
              },
            },
          },
        },
      },
      post: {
        tags: ['Documents'],
        summary: 'Fazer upload de documento',
        description: 'Envia um arquivo para o Supabase Storage. Use `multipart/form-data` com o campo `file`.',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
        ],
        requestBody: {
          required: true,
          content: {
            'multipart/form-data': {
              schema: {
                type: 'object',
                required: ['file'],
                properties: {
                  file: {
                    type: 'string',
                    format: 'binary',
                    description: 'Arquivo a ser enviado (PDF, imagem, etc.)',
                  },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Documento enviado',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Document' } },
            },
          },
          '400': {
            description: 'Nenhum arquivo fornecido',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '500': {
            description: 'Falha no upload para o Supabase Storage',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/elderly/{elderlyId}/documents/{id}': {
      get: {
        tags: ['Documents'],
        summary: 'Buscar documento',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'Dados do documento',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Document' } },
            },
          },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Documento não encontrado',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
      delete: {
        tags: ['Documents'],
        summary: 'Deletar documento',
        description: 'Remove o documento do banco de dados e do Supabase Storage.',
        parameters: [
          { name: 'elderlyId', in: 'path', required: true, schema: { type: 'string' } },
          { name: 'id', in: 'path', required: true, schema: { type: 'string' } },
        ],
        responses: {
          '204': { description: 'Documento deletado' },
          '403': {
            description: 'Usuário não é membro da família',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '404': {
            description: 'Documento não encontrado',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
  },
}

export function setupSwagger(app: Express) {
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
    customSiteTitle: 'Amparo API Docs',
    swaggerOptions: {
      persistAuthorization: true,
    },
  }))

  app.get('/api-docs.json', (_req, res) => {
    res.setHeader('Content-Type', 'application/json')
    res.send(swaggerSpec)
  })
}
