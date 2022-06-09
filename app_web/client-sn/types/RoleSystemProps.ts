import React from "react";
import { Medico } from "../interfaces/Medico";

export type RoleSystemProps = {
    id?:number,
    nombre?: string,
    medicoData?: Medico,
    setRol?: React.Dispatch<React.SetStateAction<RoleSystemProps>>
}