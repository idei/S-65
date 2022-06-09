import { Pagination } from "@material-ui/lab"
import { useEffect, useState } from "react"
import { AntecedenteMedicoFamiliar } from "../../../interfaces/AntecedenteMedicoFamiliar"
import { AntecedenteMedicoPersonal } from "../../../interfaces/AntecedenteMedicoPersonal"
import { Paciente } from "../../../interfaces/Paciente"
import { PaginateInterface } from "../../../interfaces/PaginateInterface"
import antecedenteMedicoFamiliarService from "../../../services/AntecedenteMedicoFamiliarService"
import antecedenteMedicoPersonalService from "../../../services/AntecedenteMedicoPersonalService"

type MedicalAntecedentsProps = {
    id_paciente: number
}

const MedicalAntecedents = ({ id_paciente }: MedicalAntecedentsProps) => {

    const [paginationAntecedentePersonal, storePaginationAntecedentePersonal] = useState<PaginateInterface<AntecedenteMedicoPersonal>>(null)
    const [paginationAntecedenteFamiliar, storePaginationAntecedenteFamiliar] = useState<PaginateInterface<AntecedenteMedicoFamiliar>>(null)
    
    useEffect(() => {
        let mount = true
        const fetchData = async () => {
            const response = await antecedenteMedicoPersonalService.getByPacienteId(id_paciente, paginationAntecedentePersonal ? paginationAntecedentePersonal.current_page : 1, 5)
            if (mount && response) {
                console.log(response)
                storePaginationAntecedentePersonal(response)
            }
        }

        fetchData()

        return () => { mount = false }
    }, [])
    useEffect(() => {
        let mount = true
        const fetchDataFamiliar = async () => {
            const response = await antecedenteMedicoFamiliarService.getByPacienteId(id_paciente, paginationAntecedenteFamiliar ? paginationAntecedenteFamiliar.current_page : 1, 5)
            if (mount && response) {
                storePaginationAntecedenteFamiliar(response)
            }
        }
        fetchDataFamiliar()
        return () => { mount = false }
    }, [])

    const onChangePageFamiliar = async (value: number) => {
        if (value !== paginationAntecedenteFamiliar.current_page) {
            const response = await antecedenteMedicoFamiliarService.getByPacienteId(id_paciente, value, 5)
            if (response) {
                storePaginationAntecedenteFamiliar(response)
            }
        }
    }

    const onChangePagePersonal = async (value: number) => {
        if (value !== paginationAntecedentePersonal.current_page) {
            const response = await antecedenteMedicoPersonalService.getByPacienteId(id_paciente, value, 5)
            if (response) {
                storePaginationAntecedentePersonal(response)
            }
        }
    }
    return (
        <div className="container-fluid mb-3">
            <div className="row">
                {
                    paginationAntecedentePersonal == null || paginationAntecedentePersonal.total === 0 ? <h3 className="mt-2 col-6 ">El paciente no cuenta con antecedentes medicos</h3>
                        : (
                            <div className="col-6 d-flex flex-column justify-content-between">
                                <div>
                                    <h3>Antecedentes medicos personales</h3>
                                    <div>
                                        <ul>
                                            {paginationAntecedentePersonal.data.map((value, index) => {
                                                if (value.evento == null || value.evento == undefined) {
                                                    return null
                                                }
                                                return (
                                                    <li key={index + 'antecented-personales'}>{value.evento.nombre_evento}</li>
                                                )
                                            })}
                                        </ul>
                                    </div>
                                </div>
                                <Pagination className="mt-auto" page={paginationAntecedentePersonal.current_page} count={paginationAntecedentePersonal.last_page} onChange={(e, page) => { onChangePagePersonal(page) }} />
                            </div>

                        )
                }{
                    paginationAntecedenteFamiliar == null || paginationAntecedenteFamiliar.total === 0 ? <h3 className="mt-2 col-6">El paciente no cuenta con antecedentes medicos familiares</h3>
                        : (
                            <div className="col-6 d-flex flex-column justify-content-between">
                                <div>
                                    <h3>Antecedentes medicos familiares</h3>
                                    <div>
                                        <ul>
                                            {paginationAntecedenteFamiliar.data.map((value, index) => {
                                                if (value.evento == null || value.evento == undefined) {
                                                    return null
                                                }
                                                return (
                                                    <li key={index + 'antecented-famliares'}>{value.evento.nombre_evento}</li>
                                                )
                                            })}
                                        </ul>
                                    </div>

                                </div>
                                <Pagination className="mt-auto" page={paginationAntecedenteFamiliar.current_page} count={paginationAntecedenteFamiliar.last_page} onChange={(e, page) => { onChangePageFamiliar(page) }} />
                            </div>
                        )
                }
            </div>
        </div>
    )
}

export default MedicalAntecedents