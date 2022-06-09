import { DataTypes, Model } from "sequelize";
import db from '../config/DB'
import Paciente from "./Paciente";

class NivelInstruccion extends Model { }

NivelInstruccion.init({
    nombre_nivel: DataTypes.STRING
}, { sequelize: db, modelName: 'nivel_instruccion', tableName: 'nivel_instruccion', createdAt: false, updatedAt: false })


export default NivelInstruccion