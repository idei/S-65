import { Router } from "express";
import * as AntecedenteMedicoFamiliarController from '../controllers/AntecedenteMedicoFamiliarController'
const router = Router()

router.get('/',AntecedenteMedicoFamiliarController.index)

export default router