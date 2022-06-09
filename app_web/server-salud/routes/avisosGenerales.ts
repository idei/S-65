import { Router } from 'express'
import * as avisoGeneralController from '../controllers/AvisoGeneralController'

const router = Router()
router.get('/', avisoGeneralController.index)
router.post('/', avisoGeneralController.store)
router.get('/:id', avisoGeneralController.show)
export default router