import { NextFunction, Request, Response } from 'express'
import { values } from 'sequelize/types/lib/operators'
import AvisoGeneral from "../models/AvisoGeneral"




export const index = (req: Request, res: Response) => {
    AvisoGeneral.findAll().then((values) => {
        res.status(200).json(values)
    }).catch((value) => {
        console.log(value)
    })
}

export const store = async (req: Request, res: Response) => {
    const { descripcion, url_imagen, fecha_limite, departamento_id, minEdad, maxEdad } = req.body
    const fecha_creacion = new Date()
    try {
        const avisoGeneral = await AvisoGeneral.create({ ...req.body, fecha_creacion })
        res.status(200).json(avisoGeneral)
    } catch (err) {
        console.log(err)
        res.status(500).json({ message: 'Error al guardar' })
    }

}

export const show = async (req: Request, res: Response) => {
    const { id } = req.params
    try {
        const avisoGeneral = await AvisoGeneral.findByPk(id)
        if (avisoGeneral) {
            res.status(200).json(avisoGeneral)
        } else {
            res.status(404).json({ message: 'Data not found' })
        }

    } catch (err) {
        console.log(err)
        res.status(500).json({ message: 'Error' })
    }
}