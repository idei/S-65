import { DataTypes, Model } from "sequelize";
import db from "../config/DB";

class MedicoPaciente extends Model { 
    public rela_paciente:number
}

MedicoPaciente.init({
    rela_paciente: DataTypes.INTEGER,
    rela_medico: DataTypes.INTEGER,
    estado_habilitacion: DataTypes.INTEGER,
    fecha_alta: DataTypes.DATE
},{sequelize: db, tableName:'medicos_pacientes', createdAt: false, updatedAt: false})

export default MedicoPaciente
