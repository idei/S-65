import { Medico } from "../interfaces/Medico";
import axiosClient from "./axiosClient";

class MedicoService{

    getByUserId(user_id: number): Promise<Medico>{
        return axiosClient.get(`/medicos?user_id${user_id}`).then((value) => {
            const medico: Medico = value.data
            return medico
        }).catch(error => {
            console.log(error)
            return null
        })
    }
}

const medicoService = new MedicoService()

export default medicoService