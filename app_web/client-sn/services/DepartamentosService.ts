import { Departamento } from "../interfaces/Departamento"
import axiosClient from "./axiosClient"

class DepartamentosService{
    async getDepartamentos():Promise<Departamento[]>{
        return axiosClient.get('/departamentos').then((value)=>{
            const data: Departamento[] = value.data
            return data
        }).catch(e=>{
            console.log(e)
            return []
        })
    }
}

const departamentosService = new DepartamentosService()

export default departamentosService