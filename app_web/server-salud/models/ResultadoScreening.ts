import { Model, DataTypes } from "sequelize";
import db from '../config/DB'
import Paciente from "./Paciente";
import TipoScreening from "./TipoScreening";

class ResultadoScreening extends Model { }

ResultadoScreening.init({
    rela_screening: DataTypes.INTEGER,
    rela_paciente: DataTypes.INTEGER,
    rela_medico: DataTypes.INTEGER,
    result_screening: DataTypes.FLOAT,
    fecha_alta: DataTypes.DATE
}, { sequelize: db, modelName: 'resultados_screenings', createdAt: false, updatedAt: false })

ResultadoScreening.belongsTo(TipoScreening,{ foreignKey: 'rela_screening'})
// ResultadoScreening.belongsTo(Paciente, { foreignKey: 'rela_paciente' })
export default ResultadoScreening