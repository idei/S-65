import { ResultadoScreening } from "../../../interfaces/ResultadoScreening"
import { Button, Dialog, DialogContent, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from "@material-ui/core"
import { Pagination } from "@material-ui/lab"
import React, { useEffect, useState } from "react"
import { Paciente } from "../../../interfaces/Paciente"
import { PaginateInterface } from "../../../interfaces/PaginateInterface"
import resultadosScreeningsService from "../../../services/ResultadosScreeningsService"
import ModalScreening from "../ModalScreening/ModalScreening"
type ResultadoScreeningProps = {
    paciente: Paciente,
    reload?: boolean
}

const ScreeningsTable = ({ paciente, reload }: ResultadoScreeningProps) => {
    const [pagination, storePagination] = useState<PaginateInterface<ResultadoScreening>>(null)
    const [showRespuestas,storeShowRespuestas] = useState<ResultadoScreening>(null)

    useEffect(() => {
        let mount = true
        const getData = async () => {
            const response = await resultadosScreeningsService.getResultadosByPacienteId(paciente.id, pagination?.current_page, 5)
            if (mount && response) {
                console.log('entra')
                storePagination(response)
            }
        }
        getData()
        return () => { mount = false }
    }, [paciente])

    const onChangePage = async (e, value: number) => {
        const response = await resultadosScreeningsService.getResultadosByPacienteId(paciente.id, value, 5)
        if (response) {
            console.log('entra dos')
            storePagination(response)
        }
    }

    const onClickShowRespuesta = (value: ResultadoScreening) => {
        storeShowRespuestas(value)
    }
    if (pagination === null) {
        return null
    }
    return (
        <>
            <ModalScreening storeResultadoScreening={storeShowRespuestas} resultadoScreening={showRespuestas} />
            <TableContainer>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>
                                Fecha
                            </TableCell>
                            <TableCell>
                                Tipo
                            </TableCell>
                            <TableCell>
                                Acciones
                            </TableCell>
                            <TableCell>
                                Resultado
                            </TableCell>
                        </TableRow>

                    </TableHead>
                    <TableBody>
                        {
                            pagination?.data.map((value, index) => {
                                return (
                                    <TableRow key={index + 'DataForScreenings'}>
                                        <TableCell>
                                            {value.fecha_alta}
                                        </TableCell>
                                        <TableCell>
                                            {value.tipo_screening?.nombre}
                                        </TableCell>
                                        <TableCell>
                                            <Button onClick={()=>onClickShowRespuesta(value)} disabled={value.respuestas.length === 0}>
                                                Ver mas
                                            </Button>
                                        </TableCell>
                                        <TableCell>
                                            {value.result_screening}
                                        </TableCell>
                                    </TableRow>
                                )
                            })
                        }
                    </TableBody>
                </Table>
            </TableContainer>
            <Pagination className="mt-2" page={pagination?.current_page ? pagination.current_page : 1} onChange={onChangePage} count={pagination.last_page ? pagination.last_page : 1} />
        </>
    )
}

export default ScreeningsTable