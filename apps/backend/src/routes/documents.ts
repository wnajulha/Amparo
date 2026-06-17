import { Router } from 'express'
import multer from 'multer'
import {
  listDocuments,
  uploadDocument,
  getDocument,
  deleteDocument,
} from '../controllers/documentController'
import { requireAuth } from '../middlewares/auth'

const upload = multer({ storage: multer.memoryStorage() })

export const documentRoutes = Router()

documentRoutes.use(requireAuth)

documentRoutes.get('/elderly/:elderlyId/documents', listDocuments)
documentRoutes.post('/elderly/:elderlyId/documents', upload.single('file'), uploadDocument)
documentRoutes.get('/elderly/:elderlyId/documents/:id', getDocument)
documentRoutes.delete('/elderly/:elderlyId/documents/:id', deleteDocument)
