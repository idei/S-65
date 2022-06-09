import { RecordatorioMedico } from "../interfaces/RecordatorioMedico"
import axiosClient from "./axiosClient"

class RecordatorioScreeningService{
    async storeRecordatorio(data: RecordatorioMedico): Promise<boolean>{
        delete data.rela_respuesta_screening
        delete data.paciente
        console.log(data)
        return axiosClient.post('/recordatorios_medicos',data).then((value)=>{
            return true
        }).catch((e)=>{
            console.log(e)
            return false
        })
    }
}

const recordatorioScreeningService = new RecordatorioScreeningService()

export default recordatorioScreeningService