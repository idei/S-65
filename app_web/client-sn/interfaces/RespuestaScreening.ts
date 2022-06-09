import { Evento } from "./Evento";
import { TipoRespuesta } from "./TipoRespuesta";

export interface RespuestaScreening {
    id: number,
    rela_tipo: number,
    rela_evento: number,
    rela_tipo_screening: number,
    rela_recordatorio_medico: number,
    rela_paciente: number,
    estado: number,
    rela_resultado: number,
    fecha_alta: string,
    observacion: string,
    evento?: Evento,
    tipo_respuesta?: TipoRespuesta
}
