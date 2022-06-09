import { Diagnostico } from "../interfaces/Diagnostico"
import axiosClient from "./axiosClient"

class DiagnosticoService{

    async search(diagnostico: string): Promise<Diagnostico[]>{
        return axiosClient.get(`/diagnosticos/search?nombre=${diagnostico}`)
            .then((value)=>{
                const data : Diagnostico[] = value.data
                return data
            }).catch(error => {
                console.log(error)
                return []
            })
    }
}

const diagnosticoService = new DiagnosticoService()

export default diagnosticoService