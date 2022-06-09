import { AuthUser } from "../interfaces/AuthUser"
import axiosClient from "./axiosClient"

class AuthService {

    async login(email: string, password: string): Promise<AuthUser> {
        const data = {
            email,
            password
        }
        return axiosClient.post('/login', data).then((response)=>{
            const user = response.data
            return user
        }).catch((error)=>{
            console.log(error)
            return null
        })
    }
}

const authService = new AuthService()

export default authService