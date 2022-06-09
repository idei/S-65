import { DataTypes, Model } from "sequelize";
import db from '../config/DB'

class Evento extends Model { }

Evento.init({
    nombre_evento: DataTypes.STRING,
    codigo_evento: DataTypes.STRING,
    descripcion: DataTypes.STRING
}, { sequelize: db, modelName: 'eventos' , createdAt: false, updatedAt: false})

export default Evento