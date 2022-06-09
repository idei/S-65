import { Request, Response } from "express";
import Genero from "../models/Genero";

export const index = async (req: Request, res: Response) => {

    try {
        const generos = await Genero.findAll()
        res.status(200).json(generos)
    }
    catch (err) {
        console.error(err);
        res.status(500).send({ message: "Error" })
    }
}