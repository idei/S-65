import { Button, Dialog, DialogContent, DialogTitle, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from "@material-ui/core"
import React, { SetStateAction } from "react"
import { Close } from "@material-ui/icons";
import { DatoClinico } from "../../../interfaces/DatoClinico"
import styles from './ClinicDataModal.module.scss'
type ClinicDataModalProps = {
    open: boolean,
    storeOpen: React.Dispatch<SetStateAction<Boolean>>,
    datos_clinicos: DatoClinico[]
}

const ClinicDataModal = ({ open, storeOpen, datos_clinicos }: ClinicDataModalProps) => {
    const handleClose = () => {
        storeOpen(false)
    }
    return (
        <Dialog
            onClose={handleClose}
            open={open}
            fullWidth={true}
            maxWidth="lg"
        >
            <DialogTitle>
                <div className="d-flex justify-content-between align-items-center">
                    <h6>Datos Clinicos</h6>
                    <Button  onClick={handleClose}><Close htmlColor="grey"></Close></Button>
                </div>
            </DialogTitle>
            <DialogContent>
                <TableContainer className="mb-5" component={Paper}>
                    <Table >
                        <TableHead className={`${styles.thead}`}>
                            <TableRow>
                                <TableCell>Fecha</TableCell>
                                <TableCell>Presion alta</TableCell>
                                <TableCell>Presion baja</TableCell>
                                <TableCell>Pulso</TableCell>
                                <TableCell>Peso</TableCell>
                                <TableCell>Circunferencia cintura</TableCell>
                                <TableCell>Consume alcohol</TableCell>
                                <TableCell>Consume marihuana</TableCell>
                                <TableCell>Otras drogas</TableCell>
                                <TableCell>Fuma tabaco</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody className={`${styles.tbody}`}>
                            {datos_clinicos.map((value) => {
                                return (
                                    <TableRow key={value.id + "table-clinic"}>
                                        <TableCell>{value.fecha_alta}</TableCell>
                                        <TableCell>{value.presion_alta}</TableCell>
                                        <TableCell>{value.presion_baja}</TableCell>
                                        <TableCell>{value.pulso}</TableCell>
                                        <TableCell>{value.peso}</TableCell>
                                        <TableCell>{value.circunferencia_cintura}</TableCell>
                                        <TableCell>{value.consume_alcohol ? 'Si' : 'No'}</TableCell>
                                        <TableCell>{value.consume_marihuana ? 'Si' : 'No'}</TableCell>
                                        <TableCell>{value.otras_drogas ? 'Si' : 'No'}</TableCell>
                                        <TableCell>{value.fuma_tabaco ? 'Si' : 'No'}</TableCell>
                                    </TableRow>
                                )
                            })}
                        </TableBody>
                    </Table>
                </TableContainer>
            </DialogContent>
        </Dialog>
    )
}

export default ClinicDataModal