import { Model, DataTypes } from "sequelize";
import db from '../config/DB'

class Rol extends Model { }
Rol.init({
    nombre_rol: DataTypes.STRING
}, { sequelize: db, modelName: 'roles', createdAt: false, updatedAt: false })

export default Rol