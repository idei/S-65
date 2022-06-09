import { Request, Response } from "express";
import { Op } from "sequelize";
import Diagnostico from "../models/Diagnostico";
import Paginate from "../utils/PaginateInterface";

export const index = async (req: Request, res: Response) => {
    try {
        const page = req.query.page ? Number(req.query.page) : 1
        const per_page = req.query.per_page ? Number(req.query.per_page) : 10

        const data = await Diagnostico.findAll({
            offset: per_page * (page - 1),
            limit: per_page
        })

        const count = await Diagnostico.count()
        const paginate: Paginate<Diagnostico> = {
            data: data,
            page: page,
            per_page: per_page,
            total: count,
            totalPages: Math.round(count / per_page)
        }

        res.status(400).json(paginate)
    }
    catch (e) {
        console.log(e)
        res.status(500).json({ message: "Error" })
    }
}

export const show = async (req: Request, res: Response) => {
    const { id } = req.params
    try{
        const diagnostico = await Diagnostico.findByPk(id)
        res.status(200).json(diagnostico)
    }catch(e){
        console.log(e)
        res.status(500).json({message: "Error"})
    }
}

export const search = async (req: Request, res: Response) =>  {
    
    const { nombre } = req.query;

    try{
        const diagnosticos = await Diagnostico.findAll({
            where: {
                nombre:{
                    [Op.like]: `%${nombre}%`
                }
            },
            limit: 10
        })

        res.status(200).json(diagnosticos)

    }catch(e){
        console.log(e)
        res.status(500).json({message: "error"})
    }
}