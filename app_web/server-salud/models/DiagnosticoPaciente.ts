import { DataTypes, Model } from "sequelize";
import db from "../config/DB";
import Diagnostico from "./Diagnostico";

class DiagnosticoPaciente extends Model { }

DiagnosticoPaciente.init({
    rela_diagnostico: DataTypes.INTEGER,
    rela_paciente: DataTypes.INTEGER,
    fecha_alta: DataTypes.DATE
}, { sequelize: db, tableName: 'diagnostico_paciente', createdAt: false, updatedAt: false })
DiagnosticoPaciente.belongsTo(Diagnostico, { foreignKey: 'rela_paciente' })
export default DiagnosticoPaciente
