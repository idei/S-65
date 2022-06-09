import { Model, DataTypes } from 'sequelize'
import db from '../config/DB'
import Evento from './Evento'

class AntecedenteMedicoPersonal extends Model { }

AntecedenteMedicoPersonal.init({
    rela_tipo: DataTypes.INTEGER,
    rela_evento: DataTypes.INTEGER,
    rela_paciente: DataTypes.INTEGER,
}, { sequelize: db, modelName: 'antecedentes_medicos_personales', createdAt: false, updatedAt: false })
AntecedenteMedicoPersonal.belongsTo(Evento, { foreignKey: 'rela_evento' })
export default AntecedenteMedicoPersonal