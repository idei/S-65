import { NextFunction, Request, Response } from "express";
import Departamento from "../models/Departamento";

export const index = (req: Request, res: Response, next: NextFunction) => {
    Departamento.findAll().then((values) => {
        res.status(200).json(values)
    }).catch((value)=>{
        console.log(value)
    })
}