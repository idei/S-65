import Paciente from "../models/Paciente";
import { Request, Response } from "express"
import ResultadoScreening from "../models/ResultadoScreening";
import Departamento from "../models/Departamento";
import GrupoConviviente from "../models/GrupoConviviente";
import NivelInstruccion from "../models/NivelInstruccion";
import TipoScreening from "../models/TipoScreening";
import AntecedenteMedicoFamiliar from "../models/AntecedenteMedicoPersonal";
import AntecedenteMedicoPersonal from "../models/AntecedenteMedicoPersonal";
import Evento from "../models/Evento";
import DatoClinico from "../models/DatoClinico";
import { DataTypes } from "sequelize/types";
import PaginateInterface from "../utils/PaginateInterface";
import MedicoPaciente from "../models/MedicoPaciente";

export const index = async (req: Request, res: Response) => {

    const page = req.query?.page ? Number(req.query.page) : 1
    const per_page = req.query?.per_page ? Number(req.query.per_page) : 10
    const medico_id = req.query?.medico_id ? Number(req.query.medico_id) : null
    try {

        
        let whereCondition = null
        if (medico_id) {
            const pacientes_id = await MedicoPaciente.findAll()
            whereCondition = {
                id: pacientes_id.map(value=>value.rela_paciente)
            }
            
        }
        const count = await Paciente.count({
            where: whereCondition
        })
        const pacientes = await Paciente.findAll(
            {
                offset: per_page * (page - 1),
                limit: per_page,
                where: whereCondition
            }
        )

        const data: PaginateInterface<Paciente> = {
            data: pacientes,
            page: page,
            per_page: per_page,
            total: count,
            totalPages: Math.round(count / per_page)
        }
        res.status(200).json(data)
    } catch (err) {
        console.log(err)
        res.status(500).json({ message: 'Error' })
    }
}

export const show = async (req: Request, res: Response) => {
    const { id } = req.params
    try {
        const paciente = await Paciente.findByPk(id, {
            include: [
                { model: ResultadoScreening, include: [TipoScreening] },
                Departamento,
                GrupoConviviente,
                NivelInstruccion,
                { model: AntecedenteMedicoFamiliar, include: [Evento] },
                { model: AntecedenteMedicoPersonal, include: [Evento] },
                DatoClinico
            ]
        })
        if (paciente) {
            res.status(200).json(paciente)
        } else {
            res.status(404).json({ message: 'Pacient not found' })
        }
    } catch (err) {
        console.log(err.message)
        res.status(500).json({ message: 'Error' })
    }
}

export const searchByDni = async (req: Request, res: Response) => {
    const { dni } = req.query
    try {
        const paciente = await Paciente.findOne({
            where: {
                dni: dni
            },
            include: [NivelInstruccion, Departamento, GrupoConviviente]
        })
        res.status(200).json(paciente)
    } catch (err) {
        console.log(err)
        res.status(500).json({ message: 'Error' })
    }
}