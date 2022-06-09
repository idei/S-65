import { DataTypes, Model } from "sequelize";
import db from '../config/DB'

class RespuestasScreenings extends Model { }

RespuestasScreenings.init({
    rela_tipo: DataTypes.INTEGER,
    rela_evento: DataTypes.INTEGER,
    rela_tipo_screening: DataTypes.INTEGER,
    rela_recordatorio_medico: DataTypes.INTEGER,
    rela_paciente: DataTypes.INTEGER,
    estado: DataTypes.INTEGER,
    rela_resultado: DataTypes.INTEGER,
    fecha_alta: DataTypes.DATE,
    observacion: DataTypes.STRING
}, { sequelize: db, modelName: 'respuesta_screening', createdAt: false, updatedAt: false })

export default RespuestasScreenings