import { Paciente } from "../interfaces/Paciente";
import { PaginateInterface } from "../interfaces/PaginateInterface";
import axiosClient from "./axiosClient";


class PacienteService {

    getPaciente(dni: number): Promise<Paciente> {
        const requestPromise = axiosClient.get(`/pacientes/buscarPorDni?dni=${dni}`).then((response) => {
            console.log(response.data)
            const paciente: Paciente = response.data
            return paciente
        }).catch((error) => {
            console.log(error)
            return null
        })

        return requestPromise
    }

    getPacienteById(id: number): Promise<Paciente> {
        return axiosClient.get(`/pacientes/${id}`).then((response)=>{
            const paciente: Paciente = response.data
            return paciente
        }).catch((error)=>{
            console.log(error)
            return null
        })
    }

    getPacienteByMedicId(id: number): Promise<PaginateInterface<Paciente>>{
        return axiosClient.get(`/pacientes?medico_id=${id}`).then((response) => {
            const data : PaginateInterface<Paciente> = response.data
            return data
        }).catch((error)=>{
            console.log(error)
            return null
        })
    }
}

const pacienteService = new PacienteService()

export default pacienteService