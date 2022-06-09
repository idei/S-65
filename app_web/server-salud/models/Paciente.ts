import { DataTypes, Model } from "sequelize";
import db from "../config/DB";
import AntecedenteMedicoFamiliar from "./AntecedenteMedicoFamiliar";
import AntecedenteMedicoPersonal from "./AntecedenteMedicoPersonal";
import DatoClinico from "./DatoClinico";
import Departamento from "./Departamento";
import DiagnosticoPaciente from "./DiagnosticoPaciente";
import Genero from "./Genero";
import GrupoConviviente from "./GrupoConviviente";
import NivelInstruccion from "./NivelInstruccion";
import ResultadoScreening from "./ResultadoScreening";

class Paciente extends Model { }

Paciente.init({
    nombre: DataTypes.STRING,
    apellido: DataTypes.STRING,
    dni: DataTypes.NUMBER,
    fecha_nacimiento: DataTypes.STRING,
    celular: DataTypes.STRING,
    contacto: DataTypes.STRING,
    rela_departamento: DataTypes.INTEGER
}, { sequelize: db, modelName: 'paciente', createdAt: false, updatedAt: false })
Paciente.hasMany(ResultadoScreening, { foreignKey: 'rela_paciente' })
Paciente.belongsTo(Departamento, { foreignKey: 'rela_departamento' })
Paciente.belongsTo(NivelInstruccion, { foreignKey: 'rela_nivel_instruccion' })
Paciente.belongsTo(GrupoConviviente, { foreignKey: 'rela_grupo_conviviente' })
Paciente.hasMany(AntecedenteMedicoPersonal, { foreignKey: 'rela_paciente' })
Paciente.hasMany(AntecedenteMedicoFamiliar, { foreignKey: 'rela_paciente' })
Paciente.hasMany(DatoClinico, { foreignKey: 'rela_paciente' })
Paciente.belongsTo(Genero, { foreignKey: 'rela_genero' })
Paciente.hasMany(DiagnosticoPaciente, { foreignKey: 'rela_paciente' })
DatoClinico.belongsTo(Paciente, { foreignKey: 'rela_paciente' })
export default Paciente