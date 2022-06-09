import { Model, DataTypes } from "sequelize";
import db from '../config/DB'
import Paciente from './Paciente'
class AvisoGeneral extends Model{}

AvisoGeneral.init({
    descripcion: DataTypes.STRING,
    url_imagen: DataTypes.STRING,
    fecha_creacion: DataTypes.DATE,
    rela_estado: DataTypes.INTEGER,
    rela_creador: DataTypes.INTEGER,
    fecha_limite: DataTypes.DATE,
},{sequelize: db, modelName:'avisos_generales', createdAt: false, updatedAt: false})

export default AvisoGeneral