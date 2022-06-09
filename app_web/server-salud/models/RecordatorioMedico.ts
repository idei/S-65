import { DataTypes, Model } from "sequelize";
import db from '../config/DB'
import Paciente from "./Paciente";

class RecordatorioMedico extends Model { }

RecordatorioMedico.init({
    descripcion: DataTypes.STRING,
    fecha_creacion: DataTypes.DATE,
    fecha_limite: DataTypes.DATE,
    rela_paciente: DataTypes.INTEGER,
    rela_medico: DataTypes.INTEGER,
    rela_respuesta_screening: DataTypes.INTEGER,
    rela_estado_recordatorio: DataTypes.INTEGER,
    rela_screening: DataTypes.INTEGER,
}, { sequelize: db, modelName: 'recordatorios_medicos',createdAt: false, updatedAt: false})

RecordatorioMedico.belongsTo(Paciente, { foreignKey: 'rela_paciente' })
export default RecordatorioMedico