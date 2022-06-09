import { AvisoGeneral } from "../interfaces/AvisoGeneral"
import axiosClient from "./axiosClient"

class AvisosGeneralesServices {
    getAvisosGenerales(): Promise<AvisoGeneral[]> {
        return axiosClient.get('/avisos_generales').then((value) => {
            const data: AvisoGeneral[] = value.data;
            return data
        }).catch((error) => {
            console.log(error)
            return []
        })
    }

    getAvisoById(id:number):Promise<AvisoGeneral>{
        return axiosClient.get(`/avisos_generales/${id}`).then((value)=>{
            const data:AvisoGeneral = value.data
            return data
        }).catch((error)=>{
            console.log(error)
            return null
        })
    }

    cleanData (data: Object){
        const arrayData = Object.keys(data).filter(value =>{
            return data[value] !== null && data[value] !== undefined && data[value] !== ''
        })
        let dataToReturn = {}
        arrayData.forEach(element => {
            dataToReturn = {...dataToReturn, [element]: data[element]}
        });
        return dataToReturn
    }
    storeAviso(data: AvisoGeneral):Promise<boolean>{
        return axiosClient.post('/avisos_generales',this.cleanData(data)).then((response)=>{
            console.log(response)
            return true
        }).catch(error=>{
            console.log(error.response)
            return false
        })
    }

    getAllTypes(){
        const data = [
            "Por departamento",
            "Por edad",
            "Por genero"
        ]
        return data
    }

    
}

const avisosGeneralesServices = new AvisosGeneralesServices()

export default avisosGeneralesServices