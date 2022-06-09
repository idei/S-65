import { AntecedenteMedicoFamiliar } from "./AntecedenteMedicoFamiliar";
import { AntecedenteMedicoPersonal } from "./AntecedenteMedicoPersonal";
import { DatoClinico } from "./DatoClinico";
import { Departamento } from "./Departamento";
import { Genero } from "./Genero";
import { NivelInstruccion } from "./NivelInstruccion";
import { ResultadoScreening } from "./ResultadoScreening";

export interface Paciente{
    id?: number,
    dni: number,
    nombre: string,
    apellido: string,
    fecha_nacimiento: string,
    celular:string,
    contacto: string,
    departamento: Departamento,
    datos_clinicos?: DatoClinico[],
    antecedentes_medicos_familiares?: AntecedenteMedicoFamiliar[],
    antecedentes_medicos_personales?: AntecedenteMedicoPersonal[],
    resultados_screening?: ResultadoScreening[]
    genero?: Genero
    nivel_instruccion?: NivelInstruccion
}