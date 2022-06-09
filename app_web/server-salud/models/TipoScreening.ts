import { Model, DataTypes } from 'sequelize'
import db from '../config/DB'

class TipoScreening extends Model { }

TipoScreening.init({
    nombre: DataTypes.STRING,
    codigo: DataTypes.STRING
}, { sequelize: db, modelName: 'tipo_screening',tableName: 'tipo_screening', createdAt: false, updatedAt: false })

export default TipoScreening