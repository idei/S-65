import { Router } from "express";
import * as RecordatorioMedicoController from '../controllers/RecordatorioMedicoController'
const router = Router()
router.get('/',RecordatorioMedicoController.index)
export default router