import { Router } from 'express'
import * as eventoController from '../controllers/EventoController'

const router = Router()

router.get('/',eventoController.index)

export default router