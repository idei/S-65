import { DataTypes, Model } from "sequelize";
import db from '../config/DB'

class Medico extends Model { }

Medico.init({
    matricula: DataTypes.STRING,
    dni: DataTypes.STRING,
    nombre: DataTypes.STRING,
    apellido: DataTypes.STRING,
    especialidad: DataTypes.STRING,
    telefono: DataTypes.STRING,
    domicilio: DataTypes.STRING,
}, { sequelize: db, modelName: 'medicos', createdAt: false, updatedAt: false })

export default Medico