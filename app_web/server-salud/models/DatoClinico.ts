import { Model, DataTypes } from "sequelize";
import db from "../config/DB";
import Paciente from "./Paciente";

class DatoClinico extends Model { }

DatoClinico.init({
    rela_paciente: DataTypes.INTEGER,
    presion_alta: DataTypes.FLOAT,
    presion_baja: DataTypes.FLOAT,
    pulso: DataTypes.FLOAT,
    peso: DataTypes.FLOAT,
    circunferencia_cintura: DataTypes.STRING,
    talla: DataTypes.FLOAT,
    consume_alcohol: DataTypes.INTEGER,
    consume_marihuana: DataTypes.INTEGER,
    otras_drogas: DataTypes.INTEGER,
    fuma_tabaco: DataTypes.INTEGER,
    estado_clinico: DataTypes.INTEGER,
    fecha_alta: DataTypes.DATE
}, { sequelize: db, modelName: 'datos_clinicos', createdAt: false, updatedAt: false })


export default DatoClinico
