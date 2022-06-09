declare namespace Express {
    export interface Request {
        user?: object
    }
    export interface Response {
        csv?: (data: any) => any
    }
}