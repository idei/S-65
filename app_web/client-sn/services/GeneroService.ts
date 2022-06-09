import { Genero } from "../interfaces/Genero"
import axiosClient from "./axiosClient"


class GeneroService {
    getGeneros(): Promise<Genero[]> {
        return axiosClient.get('/generos').then((response) => {
            const data: Genero[] = response.data
            return data
        }).catch((error) => {
            console.log(error)
            return []
        })
    }
}

const generoService = new GeneroService()
export default generoService