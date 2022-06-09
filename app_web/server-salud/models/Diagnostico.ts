import { DataTypes, Model } from "sequelize";
import db from "../config/DB";

class Diagnostico extends Model{}

Diagnostico.init({
    nombre: DataTypes.STRING
},{sequelize: db, tableName: "diagnosticos", createdAt: false, updatedAt: false})

export default Diagnostico