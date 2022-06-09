import { DataTypes, Model } from "sequelize";
import db from "../config/DB"
import Rol from "./Rol";
class User extends Model{
    rela_rol: number
    id:number
}

User.init({
    email: DataTypes.STRING,
    password: DataTypes.STRING,
    rela_rol: DataTypes.INTEGER
},{sequelize: db, modelName: 'users', createdAt: false, updatedAt: false})
User.belongsTo(Rol, { foreignKey: 'rela_rol' })
export default User