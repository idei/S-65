import { Button, TextField } from "@material-ui/core"
import ModalFounded from "../../SearchComponents/ModalFounded/ModalFounded"
import ModalNotFounded from "../../SearchComponents/ModalNotFounded/ModalNotFounded"
import Link from "next/link"
import React, { useState } from "react"
import { Paciente } from "../../../interfaces/Paciente"
import pacienteService from "../../../services/PacienteService"
import styles from "./AvisosCabecera.module.scss"
const AvisosCabecera = () => {
    const [dni, guardarDni] = useState<number>(null)
    const [paciente, storePaciente] = useState<Paciente>(null)
    const [mostrarModal, guardarMostrarModal] = useState(false)
    const onClickFind = async () => {
        const response = await pacienteService.getPaciente(dni)
        if(response){
            storePaciente(response)
            guardarMostrarModal(true)
        }else{
            storePaciente(null)
            guardarMostrarModal(true)
        }
    }

    const changeDni = (e) => {
        guardarDni(e.target.value)
    }
    return (
        <>
        {
          paciente ?
            <ModalFounded show={mostrarModal} paciente={paciente} storeShow={guardarMostrarModal} onClickAccept={onClickFind} /> :
            <ModalNotFounded show={mostrarModal} storeShow={guardarMostrarModal} />
        }
            <div className="row">
                {/* <div className="col-6">
                    <div className="d-flex flex-column w-50">
                        <h6>Avisos personales</h6>
                        <TextField type="number" name="dni" className="mb-2" placeholder="DNI del paciente" value={dni || ''} onChange={changeDni} />
                        <Button color="primary" variant="contained" onClick={onClickFind} >Buscar paciente</Button>
                    </div>
                </div> */}
                <div className="col-12">
                    <div className="d-flex justify-content-between ">
                        <h6 className="invisible">Avisos grupales</h6>
                        {/* <TextField type="number" className="mb-2 invisible" placeholder="DNI del paciente" /> */}
                        <Link href="/avisos/aviso_general">
                            <Button color="primary" className={`${styles.colorText}`} href="/avisos/aviso_general" variant="contained" >Crear nuevo aviso grupal</Button>
                        </Link>
                    </div>
                </div>
            </div>
        </>
    )
}
export default AvisosCabecera