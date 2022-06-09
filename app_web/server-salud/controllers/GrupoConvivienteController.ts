import { Request, Response } from "express";
import GrupoConviviente from "../models/GrupoConviviente";

export const index = async (req: Request, res: Response) => {
    try {
        const grupos_convivientes = await GrupoConviviente.findAll()
        res.status(200).json(grupos_convivientes)
    } catch (err) {
        console.error(err)
        res.status(500).json({ message: 'Error' })
    }
}

