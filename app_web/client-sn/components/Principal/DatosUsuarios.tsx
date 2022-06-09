import React from 'react'
import { Paciente } from '../../interfaces/Paciente'
import styles from './DatosUsuarios.module.scss'

type PacienteProp = {
    paciente: Paciente
}


const DatosUsuarios = ({paciente}: PacienteProp) => {
    return (
        <div className={`py-2 px-2 w-100 mt-3 ${styles.contenedor}`}>
            <h4>Nombre: {paciente.nombre}</h4>
            <h4>Apellido: {paciente.apellido}</h4>
        </div>
    )
}

export default DatosUsuarios