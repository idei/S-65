import { createContext, useContext, useEffect, useState } from "react";
import { AuthUser } from "../interfaces/AuthUser";
import { AuthProps } from "../types/AuthProps";

const Context = createContext<AuthProps>({})

/**
 * En el caso de que sea medico el rol debe ser 1, si es investigador, el id 2 y para prestador 3
 */

export const AuthProvider = ({ children }) => {
    const initialUsers: AuthUser = {
        token: null,
        nombre: null,
        email: null,
        rol: null,
        user_id: null

    }

    const [authState, storeAuthState] = useState(initialUsers)

    const { token, nombre, email, rol, user_id, pacientes, informes, recordatorios } = authState

    const storeAuth = ({ email, token, rol }: AuthProps) => {
        storeAuthState({
            nombre: email,
            token: token,
            rol: rol,
            pacientes: rol === 1,
            informes: rol === 2 || rol === 3,
            recordatorios: rol === 1 || rol === 3
        })
        if (window != undefined && window != null) {
            window.localStorage.setItem("token", token)
            window.localStorage.setItem("rol", String(rol))
            window.localStorage.setItem("user_id", String(user_id))
        }
    }

    const deleteToken = () => {
        storeAuthState({ token: null })
        if (window != undefined && window != null) {
            window.localStorage.removeItem('token')
        }
    }

    useEffect(() => {
        if (window != undefined && window != null) {
            const token = window.localStorage.getItem("token") ? window.localStorage.getItem("token") : null
            const rol = window.localStorage.getItem("rol") ? window.localStorage.getItem("rol") : null
            const user_id = window.localStorage.getItem("user_id") ? window.localStorage.getItem("user_id") : null


            storeAuthState({
                token: token,
                rol: Number(rol),
                user_id: Number(user_id),
                pacientes: Number(rol) === 1,
                informes: Number(rol) === 2 || Number(rol) === 3,
                recordatorios: Number(rol) === 1 || Number(rol) === 3
            })
        }
    }, [])

    return (
        <Context.Provider 
            value={{ token, nombre, email, rol, user_id, pacientes, informes, recordatorios, storeAuthState, storeAuth, deleteToken }}>
            {children}
        </Context.Provider>
    )
}

export function useAuth() {
    return useContext(Context)
}

