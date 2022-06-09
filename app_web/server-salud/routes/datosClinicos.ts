import { Router } from "express";
import * as DatoClinicoController from "../controllers/DatoClinicoController"
const router = Router()
router.get('/',DatoClinicoController.index)
export default router