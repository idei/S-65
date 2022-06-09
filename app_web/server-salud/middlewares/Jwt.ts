import jwt from "jsonwebtoken"
import { Request, Response, NextFunction } from "express";
import auth from "../routes/auth";

function authenticateToken(req: Request, res: Response, next: NextFunction) {
    const authHeader = req.headers["Authorization"]
    if(authHeader == null){
        return res.status(401).json({ message: "Token not found"})
    }
    if (authHeader) {
        const token: string = authHeader instanceof Array ? authHeader[0].split(' ')[1] : authHeader.split(' ')[1]
        jwt.verify(token,process.env.TOKEN, (err,user) => {
            console.log(err)
            if (err) {
                return res.status(401).json({ message: "Token invalid"})
            }
            req.user = user
            next()            
        })
    }
}