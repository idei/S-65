import { Request, Response } from "express";
import { validationResult } from "express-validator";
import Medico from "../models/Medico";

export const getById = async (req: Request, res: Response) => {

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const { user_id } = req.query

    try {
        const medico = await Medico.findOne({
            where: {
                rela_users: user_id
            }
        })

        if(medico){
            res.status(200).json(medico)
        }else{
            res.status(404).json({ message : 'Not found'})
        }
    }catch(err){
        console.log(err.message)
        res.status(500).json({ message : 'Error'})
    }
}