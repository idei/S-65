import { Router } from "express"
import * as TipoScreeningController from "../controllers/TipoScreeningController"
const router = Router()
router.get('/',TipoScreeningController.index)
export default router