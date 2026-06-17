import { Response } from 'express'
import { Request } from 'express'
import prisma from '../lib/prisma'
import { supabase } from '../lib/supabase'
import { AuthRequest } from '../middlewares/auth'

async function assertElderlyAccess(elderlyId: string, userId: string) {
  const elderly = await prisma.elderly.findUnique({
    where: { id: elderlyId },
    include: { family: { include: { members: true } } },
  })
  if (!elderly) return null
  const isMember = elderly.family.members.some((m) => m.userId === userId)
  return isMember ? elderly : null
}

export async function listDocuments(req: AuthRequest, res: Response) {
  const { elderlyId } = req.params

  const elderly = await assertElderlyAccess(elderlyId, req.userId!)
  if (!elderly) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const documents = await prisma.document.findMany({
    where: { elderlyId },
    orderBy: { uploadedAt: 'desc' },
  })

  res.json(documents)
}

export async function uploadDocument(req: AuthRequest & Request, res: Response) {
  const { elderlyId } = req.params

  const elderly = await assertElderlyAccess(elderlyId, req.userId!)
  if (!elderly) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  if (!req.file) {
    res.status(400).json({ error: 'Arquivo não enviado' })
    return
  }

  const fileName = `${elderlyId}/${Date.now()}-${req.file.originalname}`

  const { error: uploadError } = await supabase.storage
    .from('documents')
    .upload(fileName, req.file.buffer, { contentType: req.file.mimetype })

  if (uploadError) {
    res.status(500).json({ error: 'Falha ao fazer upload do arquivo' })
    return
  }

  const { data: urlData } = supabase.storage.from('documents').getPublicUrl(fileName)

  const document = await prisma.document.create({
    data: {
      name: req.file.originalname,
      fileUrl: urlData.publicUrl,
      mimeType: req.file.mimetype,
      sizeBytes: req.file.size,
      elderlyId,
    },
  })

  res.status(201).json(document)
}

export async function getDocument(req: AuthRequest, res: Response) {
  const { elderlyId, id } = req.params

  const elderly = await assertElderlyAccess(elderlyId, req.userId!)
  if (!elderly) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const document = await prisma.document.findFirst({ where: { id, elderlyId } })
  if (!document) {
    res.status(404).json({ error: 'Documento não encontrado' })
    return
  }

  res.json(document)
}

export async function deleteDocument(req: AuthRequest, res: Response) {
  const { elderlyId, id } = req.params

  const elderly = await assertElderlyAccess(elderlyId, req.userId!)
  if (!elderly) {
    res.status(403).json({ error: 'Acesso negado' })
    return
  }

  const document = await prisma.document.findFirst({ where: { id, elderlyId } })
  if (!document) {
    res.status(404).json({ error: 'Documento não encontrado' })
    return
  }

  // Extrai o path relativo da URL para deletar do Supabase Storage
  const urlPath = new URL(document.fileUrl).pathname
  const storagePath = urlPath.split('/documents/')[1]

  await supabase.storage.from('documents').remove([storagePath])
  await prisma.document.delete({ where: { id } })

  res.status(204).send()
}
