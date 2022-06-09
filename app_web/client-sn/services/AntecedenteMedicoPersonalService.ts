import { AntecedenteMedicoPersonal } from "../interfaces/AntecedenteMedicoPersonal"
import { PaginateInterface } from "../interfaces/PaginateInterface"
import axiosClient from "./axiosClient"

class AntecedenteMedicoPersonalService{

    async getByPacienteId(id: number,page?: number, per_page?: number): Promise<PaginateInterface<AntecedenteMedicoPersonal>>{
        return axiosClient.get(`/antecedentes_medicos_personales?paciente_id=${id}&page=${page? page: 1}&per_page=${per_page ? per_page : 5}`).then(data => {
            const response: PaginateInterface<AntecedenteMedicoPersonal> = data.data
            return response
        }).catch(error => {
            console.log(error)
            return null
        })
    }
}

const antecedenteMedicoPersonalService: AntecedenteMedicoPersonalService = new AntecedenteMedicoPersonalService()
export default antecedenteMedicoPersonalService