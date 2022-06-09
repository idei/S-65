import { Paciente } from "../interfaces/Paciente";
import { PaginateInterface } from "../interfaces/PaginateInterface";
import axiosClient from "./axiosClient";

class DashboardService {
    async getPacientes(filters, page: number, per_page: number): Promise<PaginateInterface<Paciente>> {
        let filterString = ''
        if (filters.departamento_id != null) {
            filterString = 'departamento_id=' + filters.departamento_id
        }
        if (filters.genero_id) {
            filterString = 'genero_id=' + filters.genero_id
        }
        if(filters.diagnostico_id != null){
            filterString = 'diagnostico_id=' + filters.diagnostico_id
        }
        return axiosClient.get(`/dashboard?page=${page}&per_page=${per_page}&${filterString}`).then((response) => {
            const data: PaginateInterface<Paciente> = response.data
            return data
        }).catch(error => {
            console.error(error)
            return null
        })
    }

    async getCsvPaciente(filters): Promise<string> {
        let filterString = ''
        if (filters.departamento_id != null) {
            filterString = 'departamento_id=' + filters.departamento_id
        }
        if (filters.genero_id) {
            filterString = 'genero_id=' + filters.genero_id
        }
        if(filters.diagnostico_id != null){
            filterString = 'diagnostico_id=' + filters.diagnostico_id
        }
        return axiosClient.get(`/dashboard/csv?${filterString != '' ? filterString : ''}`).then((response) => {
            return response.data
        }).catch(error => {
            console.log(error)
            return null
        })
    }
}

const dashboardService = new DashboardService
export default dashboardService