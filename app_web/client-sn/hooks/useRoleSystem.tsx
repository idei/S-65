import { createContext, useContext, useState } from "react";
import { RoleSystemProps } from "../types/RoleSystemProps";

const Context = createContext<RoleSystemProps>({})

export const RoleSystemProvider = ({ children }) => {
    const initialRol:RoleSystemProps = {
        id: null,
        nombre: null,
        medicoData: null,
        setRol: null,
    }

    const [rol, setRol] = useState<RoleSystemProps>(initialRol)

    return (
        <Context.Provider value={{
            ...rol,
            setRol: setRol
        }}>
            {children}
        </Context.Provider>
    )
}

export function useRoleSystem(){
    return useContext(Context)
}