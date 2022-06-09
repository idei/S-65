import { Router } from 'express'
import * as pacienteController from '../controllers/PacienteController'

const router = Router()
router.get('/', pacienteController.index)
router.get('/buscarPorDni',pacienteController.searchByDni)
router.get('/:id', pacienteController.show)
export default router