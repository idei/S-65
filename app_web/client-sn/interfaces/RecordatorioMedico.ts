import { Paciente } from "./Paciente";

export interface RecordatorioMedico {
    id?: number;
    descripcion: string;
    fecha_creacion?: string|Date;
    fecha_limite: string|Date;
    rela_paciente: number;
    rela_medico: number;
    rela_respuesta_screening: number|null;
    rela_estado_recordatorio: number;
    rela_screening: number;
    paciente?: Paciente;
}
