import { Router } from "express";
import { body,query } from 'express-validator'
import * as MedicoController from "../controllers/MedicoController"
const router = Router()

router.get('/',
query('user_id').notEmpty()
, MedicoController.getById)


export default router