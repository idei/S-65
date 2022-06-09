import { Router } from "express";
import * as GeneroController from "../controllers/GeneroController"
const router = Router()
router.get("/", GeneroController.index)

export default router