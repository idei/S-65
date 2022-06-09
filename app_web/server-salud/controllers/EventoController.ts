import { Request, Response } from "express";
import { values } from "sequelize/types/lib/operators";
import Evento from "../models/Evento";

export const index = (req: Request, res: Response) => {
    Evento.findAll().then((values) => {
        res.status(200).json(values)
    }).catch((err) => { res.status(500).json({ message: "Error" }) })
}