import { Router } from "express";
import * as AntecedenteMedicoPersonalController from '../controllers/AntecedenteMedicoPersonalController'
const router = Router()

router.get('/',AntecedenteMedicoPersonalController.index)

export default router