import { Request, Response } from "express"
import TipoScreening from "../models/TipoScreening"


export const index = async (req: Request, res: Response) => {
    try{ 
        const tipos = await TipoScreening.findAll()
        res.status(200).json(tipos)
    }catch (err) {
        console.error(err)
        res.status(500).json({message: 'Error'})
    }
}