import { Dispatch, SetStateAction } from "react";
import { AuthUser } from "../interfaces/AuthUser";

export type AuthProps = {
    token?: string,
    nombre?: string,
    email?: string,
    rol?: number,
    user_id?: number,
    pacientes?: boolean,
    informes?: boolean,
    recordatorios?: boolean,
    storeAuthState?: Dispatch<SetStateAction<AuthUser>>,
    storeAuth?: (AuthProps) => void,
    deleteToken?: () => void
}