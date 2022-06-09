import { Request, Response } from "express";
import jwt from 'jsonwebtoken'
import User from "../models/User";
import { Op } from 'sequelize'
import Rol from "../models/Rol";
function generateAccessToken(username: string) {
    const expiresIn: object = new Date((new Date).getTime() + 30 * 1000)
    return jwt.sign({username: username}, process.env.TOKEN, { algorithm: "HS256", expiresIn: '2 days' })
}

export const login = async (req: Request, res: Response) => {
    const { email, password } = req.body
    try {
        const user = await User.findOne({
            where: {
                email: {
                    [Op.like]: `%${email}%`
                }
            }
        })
        if (!user) {
            return res.status(401).json({ message: 'User not found' })
        }
        if (user.get('password') === password) {
            const token = generateAccessToken(email)
            res.status(200).json({
                email: email,
                token: token,
                rol: user.rela_rol,
                user_id: user.id                
            })

        } else {
            res.status(401).json({ message: 'Password Incorrect' })
        }
    } catch (err) {
        console.log(err.message)
        res.status(500).json({ message: 'Error' })
    }
}