import { DataTypes, Model } from "sequelize";
import db from '../config/DB'

class GrupoConviviente extends Model{}

GrupoConviviente.init({
    nombre: DataTypes.STRING
},{sequelize: db, modelName:'grupos_convivientes', createdAt: false, updatedAt: false})

export default GrupoConviviente