import { DataTypes, Model } from "sequelize";
import db from "../config/DB";

class Departamento extends Model{}

Departamento.init({
    nombre: DataTypes.STRING
},{sequelize: db, modelName: 'departamento', createdAt: false, updatedAt: false})

export default Departamento