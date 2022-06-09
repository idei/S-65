import { Request, Response } from "express";
import AntecedenteMedicoFamiliar from "../models/AntecedenteMedicoFamiliar";
import Evento from "../models/Evento";
import PaginateInterface from "../utils/PaginateInterface";


export const index = async (req: Request, res: Response) => {

    const { paciente_id } = req.query
    const per_page = req.query?.per_page ? Number(req.query.per_page) : 10
    const page = req.query?.page ? Number(req.query.page) : 1
    try {

        const whereCondition = paciente_id ? { rela_paciente: paciente_id } : null

        const count = await AntecedenteMedicoFamiliar.count({
            where: whereCondition
        })

        const antecedentes_medicos_familiares = await AntecedenteMedicoFamiliar.findAll({
            where: whereCondition,
            include: Evento,
            limit: per_page,
            offset: per_page * (page - 1)
        })

        const data : PaginateInterface<AntecedenteMedicoFamiliar> = {
            total: count,
            per_page: per_page,
            page: page,
            totalPages: Math.floor(count/per_page),
            data: antecedentes_medicos_familiares
        }

        res.status(200).json(data)

    } catch (err) {
        console.error(err)
        res.status(500).json({ message: 'Error' })
    }

}

