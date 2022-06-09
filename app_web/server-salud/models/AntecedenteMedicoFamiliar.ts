import { Model, DataTypes } from 'sequelize'
import db from '../config/DB'
import Evento from './Evento'

class AntecedenteMedicoFamiliar extends Model{}

AntecedenteMedicoFamiliar.init({
    rela_tipo: DataTypes.INTEGER,
    rela_evento: DataTypes.INTEGER,
    rela_paciente: DataTypes.INTEGER,
},{sequelize: db, modelName: 'antecedentes_medicos_familiares', createdAt: false, updatedAt: false})

AntecedenteMedicoFamiliar.belongsTo(Evento,{ foreignKey:'rela_evento'})
export default AntecedenteMedicoFamiliar