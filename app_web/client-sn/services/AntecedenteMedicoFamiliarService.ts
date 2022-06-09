import { AntecedenteMedicoFamiliar } from "../interfaces/AntecedenteMedicoFamiliar"
import { PaginateInterface } from "../interfaces/PaginateInterface"
import axiosClient from "./axiosClient"

class AntecedenteMedicoFamiliarService{

    async getByPacienteId(id: number,page?: number, per_page?: number): Promise<PaginateInterface<AntecedenteMedicoFamiliar>>{
        return axiosClient.get(`/antecedentes_medicos_personales?paciente_id=${id}&page=${page? page: 1}&per_page=${per_page ? per_page : 5}`).then(data => {
            const response: PaginateInterface<AntecedenteMedicoFamiliar> = data.data
            return response
        }).catch(error => {
            console.log(error)
            return null
        })
    }
}

const antecedenteMedicoFamiliarService: AntecedenteMedicoFamiliarService = new AntecedenteMedicoFamiliarService()
export default antecedenteMedicoFamiliarService