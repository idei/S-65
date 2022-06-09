import { Router } from "express";
import * as departamentoController from '../controllers/DepartamentoController'
const router = Router()

router.get('/',departamentoController.index)

export default router