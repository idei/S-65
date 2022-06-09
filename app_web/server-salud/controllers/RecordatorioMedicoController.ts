import { Request, Response } from "express"
import RecordatorioMedico from "../models/RecordatorioMedico"
import Paginate from "../utils/PaginateInterface"
type WhereProps = {
    rela_paciente?: any,
    rela_screening?: any
}

export const index = async (req: Request, res: Response) => {
    const per_page = req.query?.per_page ? Number(req.query.per_page) : 10
    const page = req.query?.page ? Number(req.query.page) : 1
    const { medico_id, has_screening } = req.query

    const whereData: WhereProps = {}
    if (medico_id) {
        whereData.rela_paciente = medico_id
    }
    if (has_screening) {
        whereData.rela_screening = 0
    }
    try {
        const countData = await RecordatorioMedico.count({
            where: whereData
        })
        const recordatorios_medicos = await RecordatorioMedico.findAll({
            where: whereData,
            limit: per_page,
            offset: per_page * (page - 1)
        })
        const data: Paginate<RecordatorioMedico> = {
            data: recordatorios_medicos,
            page: page,
            per_page: per_page,
            total: countData,
            totalPages: Number(countData/page)
        }
        res.status(200).json(data)
    } catch (err) {
        console.error(err)
        res.status(500).json({ message: 'Error' })
    }
}