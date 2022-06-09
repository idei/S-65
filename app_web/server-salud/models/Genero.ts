import { DataTypes, Model } from "sequelize";
import db from "../config/DB";

class Genero extends Model { }

Genero.init({
    nombre: DataTypes.STRING
}, { sequelize: db, modelName: 'genero', tableName: 'generos', createdAt: false, updatedAt: false})

export default Genero