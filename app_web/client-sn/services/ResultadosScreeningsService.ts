import { PaginateInterface } from "../interfaces/PaginateInterface";
import { ResultadoScreening } from "../interfaces/ResultadoScreening";
import axiosClient from "./axiosClient";

class ResultadosScreeningsService {

    getResultadosByPacienteId(id: number, page?: number, per_page?: number): Promise<PaginateInterface<ResultadoScreening>> {
        return axiosClient.get(`/resultados_screening?patient_id=${id}&page=${page ? page : 1}&per_page=${per_page ? per_page : 1}`).then((response) => {
            const resultados_screening: PaginateInterface<ResultadoScreening>[] = response.data
            return resultados_screening
        }).catch((error) => {
            console.log(error)
            return null
        })
    }

}

const resultadosScreeningsService = new ResultadosScreeningsService()
export default resultadosScreeningsService;