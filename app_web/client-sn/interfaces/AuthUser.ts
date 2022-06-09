export interface AuthUser{
    token?: string,
    nombre?: string,
    email?: string,
    rol?: number, 
    user_id?: number,
    pacientes?: boolean,
    informes?: boolean,
    recordatorios?: boolean
}