import { TipoScreening } from "../interfaces/TipoScreening";
import axiosClient from "./axiosClient";

class TipoScreeningService{

    async getTipoScreening(): Promise<TipoScreening[]>{
        return axiosClient.get('/tipos_screening').then((value)=>{
            const tipos: TipoScreening[] = value.data
            return tipos
        }).catch((error)=>{
            console.log(error)
            return null
        })
    }
}

const tipoScreeningService =  new TipoScreeningService()

export default tipoScreeningService;