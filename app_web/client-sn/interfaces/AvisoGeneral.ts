import { Paciente } from "./Paciente";

export interface AvisoGeneral {
    descripcion: string,
    url_imagen: string,
    departamento_id?: number,
    minEdad?: number,
    maxEdad?: number,
    genero_id?: number,
    fecha_creacion: Date | string,
    fecha_limite: Date | string,
    rela_estado: number,
    rela_creado: number,
    id?: number,
    pacientes?: Paciente[]
}