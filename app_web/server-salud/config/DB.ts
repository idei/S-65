import { Sequelize } from 'sequelize'

const db = new Sequelize('notificaciones', 'root', '', {
    host: 'localhost',
    dialect: 'mysql'
})

export default db