import { ResultadoScreening } from "../../../interfaces/ResultadoScreening"
import { Button, Dialog, DialogContent, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from '@material-ui/core'
import React, { SetStateAction } from "react"
import styles from './ModalScreening.module.scss'

type ModalScreeningProps = {
    resultadoScreening?: ResultadoScreening,
    storeResultadoScreening: React.Dispatch<SetStateAction<ResultadoScreening>>
}

const ModalScreening = ({ resultadoScreening, storeResultadoScreening }: ModalScreeningProps) => {

    const handleClose = () => {
        storeResultadoScreening(null)
    }
    return (
        <Dialog
            onClose={handleClose}
            open={Boolean(resultadoScreening)}
            maxWidth="md"

            fullWidth
        >
            <DialogContent>
                <TableContainer>
                    <Table>
                        <TableHead className={`${styles.thead}`}>
                            <TableRow>
                                <TableCell>
                                    Pregunta
                                </TableCell>
                                <TableCell>
                                    Respuesta
                                </TableCell>
                            </TableRow>

                        </TableHead>
                        <TableBody className={`${styles.tbody}`}>
                            {
                                resultadoScreening?.respuestas.map((value, index) => {
                                    return (
                                        <TableRow key={index + 'DataForResponse'}>
                                            <TableCell>
                                                {value.evento?.nombre_evento}
                                            </TableCell>
                                            <TableCell>
                                                {value.tipo_respuesta?.respuesta}
                                            </TableCell>
                                        </TableRow>
                                    )
                                })
                            }
                        </TableBody>
                    </Table>
                </TableContainer>
            </DialogContent>
        </Dialog>
    )
}

export default ModalScreening