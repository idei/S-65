import { Button } from '@material-ui/core'
import React, { useState } from 'react'
import { Paciente } from '../../../interfaces/Paciente'
import ToastProps from '../../../types/ToastProps'
import MedicalAntecedents from '../../PatientComponents/MedicalAntecedents/MedicalAntecedents'
import ModalPatientAdvice from '../../PatientComponents/ModalPatientAdvice/ModalPatientAdvice'
import ModalScreeningForm from '../../PatientComponents/ModalScreeningForm/ModalScreeningForm'
import ScreeningsTable from '../../PatientComponents/ScreeningsTable/ScreeningsTable'
import ClinicData from '../ClinicData/ClinicData'
import ClinicDataModal from '../ClinicDataModal/ClinicDataModal'
import styles from './PacientData.module.scss'

type PacientDataProps = {
    paciente: Paciente,
    storeToast: React.Dispatch<React.SetStateAction<ToastProps>>
}


const PacientData = ({ paciente, storeToast }: PacientDataProps) => {
    const [openClinicModal, storeOpenClinicModal] = useState(false)
    const [showScreeningForm, storeShowScreeningForm] = useState(false)
    const [showPatientAdviceForm, storeShowPatientAdviceForm] = useState(false)
    const onClickShow = () => {
        storeOpenClinicModal(!openClinicModal)
    }

    const onClickShowScreeningForm = () => {
        storeShowScreeningForm(true)
    }

    const onClickShowAdviceForm = () => {
        storeShowPatientAdviceForm(true)
    }

    if (paciente == null) {
        return null
    }
    return (
        <>
            <ClinicDataModal open={openClinicModal} storeOpen={storeOpenClinicModal} datos_clinicos={paciente.datos_clinicos} />
            <ModalScreeningForm pacienteId={paciente.id} storeToast={storeToast} show={showScreeningForm} storeShow={storeShowScreeningForm} />
            <ModalPatientAdvice paciente={paciente} show={showPatientAdviceForm} storeToast={storeToast} storeShow={storeShowPatientAdviceForm} />
            <div className="mt-2 pb-5">
                <h2>Datos de paciente</h2>
                <div className="d-flex flex-column">
                    <label><b>Nombre y apellido:</b> {paciente.nombre} {paciente.apellido}</label>
                    <label><b>Dni:</b> {paciente.dni}</label>
                    <label><b>Contacto:</b> {paciente.contacto}</label>
                    <label><b>Departamento:</b> {paciente.departamento?.nombre}</label>
                </div>
                {
                    paciente.datos_clinicos?.length > 0 ?
                        (
                            <>
                                <h3>Datos clinicos</h3>
                                <ClinicData dato_clinico={paciente.datos_clinicos[0]} />
                                {paciente.datos_clinicos.length > 1 ? <Button variant="outlined" color="primary" onClick={onClickShow}>Ver mas...</Button> : null}

                            </>
                        ) : <h3>El paciente no cuenta con datos clinicos</h3>
                }
                <MedicalAntecedents id_paciente={paciente.id} />
                {
                    paciente.resultados_screening?.length > 0 ?
                        (
                            <>
                                <div className="d-flex justify-content-between">
                                    <h3>Chequeos</h3>
                                    <div className="d-flex flex-column">
                                        <Button color="primary" className="mb-1" variant="contained" onClick={onClickShowAdviceForm}>
                                            Enviar un aviso personal
                                        </Button>
                                        <Button color="primary" variant="contained" onClick={onClickShowScreeningForm}>
                                            Solicitar un chequeo
                                        </Button>
                                    </div>
                                </div>
                                <ScreeningsTable paciente={paciente} />
                            </>
                        ) : (
                            <div className="d-flex justify-content-between">
                                <h3>El paciente no tiene chequeos realizados</h3>
                                <Button color="primary" variant="contained" onClick={onClickShowAdviceForm}>
                                    Enviar un aviso personal
                                </Button>
                                <Button color="primary" variant="contained" onClick={onClickShowScreeningForm}>
                                    Enviar un chequeo
                                </Button>
                            </div>)
                }

            </div>
        </>

    )
}

export default PacientData