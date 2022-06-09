import { Router } from "express";
import * as DiagnosticoController from '../controllers/DiagnosticoController'
const router = Router()

router.get("/search",DiagnosticoController.search)

export default router
