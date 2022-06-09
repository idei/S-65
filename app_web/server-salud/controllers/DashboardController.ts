import console from "console";
import { Request, Response } from "express";
import { Op } from "sequelize";
import Departamento from "../models/Departamento";
import DiagnosticoPaciente from "../models/DiagnosticoPaciente";
import Genero from "../models/Genero";
import NivelInstruccion from "../models/NivelInstruccion";
import Paciente from "../models/Paciente";
import PaginateInterface from "../utils/PaginateInterface";

export const index = async (req: Request, res) => {

    try {

        const { departamento_id, genero_id, diagnostico_id } = req.query
        const per_page = req.query?.per_page ? Number(req.query.per_page) : 10
        const page = req.query?.page ? Number(req.query.page) : 1
        let where = null
        if (departamento_id || genero_id || diagnostico_id) {
            if (departamento_id) {
                where = { rela_departamento: departamento_id }
            }
            if (genero_id) {
                where = { rela_genero: genero_id }
            }
            if(diagnostico_id){
                const diagnosticos = await DiagnosticoPaciente.findAll({
                    where:{
                        rela_diagnostico: diagnostico_id
                    }
                })

                const paciente_array_id = diagnosticos.map((value: any) => {
                    return value.rela_paciente
                })

                where = {
                    id: {
                        [Op.in] : paciente_array_id
                    }
                }
            }
        }

        const count = await Paciente.count({
            include: [Departamento, NivelInstruccion, Genero],
            where: where
        })

        const pacientes = await Paciente.findAll({
            include: [Departamento, NivelInstruccion, Genero],
            where: where,
            offset: per_page * (page - 1),
            limit: per_page
        })

        const data: PaginateInterface<Paciente> = {
            data: pacientes,
            page: page,
            per_page: per_page,
            total: count,
            totalPages: Math.round(count / per_page),
            last_page: Math.round(count / per_page) === 0 ? 1 : Math.round(count / per_page)
        }
        res.status(200).json(data)


    } catch (err) {
        console.log(err)
        res.status(500).send({ message: "Error" });
    }
}




export const exportCsv = async (req: Request, res) => {

    try {
        const { departamento_id, genero_id, diagnostico_id } = req.query
        let where = null
        if (departamento_id || genero_id) {
            if (departamento_id) {
                where = { rela_departamento: departamento_id }
            }
            if (genero_id) {
                where = { rela_genero: genero_id }
            }
        }

        if(diagnostico_id){
            const pacientes_id = await DiagnosticoPaciente.findAll({
                where:{
                    rela_diagnostico: diagnostico_id
                }
            })
            const array = []

            pacientes_id.map((value: any)=>array.push(value.rela_paciente))

            const pacientes = await Paciente.findAll({
                include: [Departamento, NivelInstruccion, Genero],
                where:{
                    id: {
                        [Op.in]: array
                    }
                }    
            })

            res.csv(pacientes.map((paciente: any) => {
                return {
                    id: paciente.id,
                    genero: paciente.genero?.nombre,
                    nivel_instruccion: paciente.nivel_instruccion?.nombre_nivel,
                    departamento: paciente.departamento?.nombre
                }
            }), true, { 'Content-disposition': 'attachment; filename=Data.csv' })
            
        }

        const pacientes = await Paciente.findAll({
            include: [Departamento, NivelInstruccion, Genero],
            where: where
        })

        // res.status(200).json(pacientes)
        res.csv(pacientes.map((paciente: any) => {
            return {
                id: paciente.id,
                genero: paciente.genero?.nombre,
                nivel_instruccion: paciente.nivel_instruccion?.nombre_nivel,
                departamento: paciente.departamento?.nombre
            }
        }), true, { 'Content-disposition': 'attachment; filename=Data.csv' })

    } catch (err) {
        console.log(err)
        res.status(500).send({ message: "Error" });
    }
}
