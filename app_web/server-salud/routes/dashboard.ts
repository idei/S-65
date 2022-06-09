import { Router } from "express";
import * as DashboardController from "../controllers/DashboardController"
const router = Router()

router.get("/",DashboardController.index)
router.get("/csv",DashboardController.exportCsv)
export default router