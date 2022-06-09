import { Request, Response } from "express";
import DatoClinico from "../models/DatoClinico";
import Paciente from "../models/Paciente";
import User from "../models/User";

export const index = async (req: Request, res: Response) => {
    try {
        const datos_clinicos = await DatoClinico.findAll({
            include: Paciente
        })
        res.status(200).json(datos_clinicos)
    } catch (err) {
        console.error(err)
        res.status(500).json({ message: 'Error' })
    }
}