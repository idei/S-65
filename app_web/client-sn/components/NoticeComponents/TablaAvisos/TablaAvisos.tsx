import { useEffect, useState } from "react"
import { Button, Dialog, DialogContent, DialogTitle, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from "@material-ui/core"
import { AvisoGeneral } from "../../../interfaces/AvisoGeneral"
import avisosGeneralesServices from "../../../services/AvisosGeneralesServices";
import Link from "next/link";
import styles from "./TablaAvisos.module.scss";
const TablaAvisos = () => {
    const [avisos, storeAvisos] = useState<AvisoGeneral[]>([]);
    useEffect(() => {
        let mount = true
        const fetchData = async () => {
            const response = await avisosGeneralesServices.getAvisosGenerales()
            if (response.length !== 0 && mount) {
                storeAvisos(response)
            }
        }

        fetchData()
        return () => { mount = false }
    }, [])
    return (
        <TableContainer>
            <Table>
                <TableHead>
                    <TableRow>
                        <TableCell>
                            Id
                        </TableCell>
                        <TableCell>
                            Descripcion
                        </TableCell>
                        <TableCell>
                            Url
                        </TableCell>
                        <TableCell>
                            Fecha de creacion
                        </TableCell>
                        <TableCell>
                            Fecha de limite
                        </TableCell>
                        <TableCell>
                            Accion
                        </TableCell>
                    </TableRow>
                </TableHead>
                <TableBody>
                    {avisos.map((value, index) => {
                        return (
                            <TableRow key={index + 'tabla-avisos' + value.id}>
                                <TableCell>
                                    {value.id}
                                </TableCell>
                                <TableCell>
                                    {value.descripcion.length > 20 ? value.descripcion.slice(0, 20) + '...' : value.descripcion}
                                </TableCell>
                                <TableCell>
                                    {value.url_imagen ? value.url_imagen : <label className={`${styles.labelColor}`}>No tiene url</label>}
                                </TableCell>
                                <TableCell>
                                    {value.fecha_creacion}
                                </TableCell>
                                <TableCell>
                                    {value.fecha_limite}
                                </TableCell>
                                <TableCell>
                                    <Link href={`avisos/aviso_general/${value.id}`}>
                                        <Button variant="outlined" color="primary" href={`avisos/aviso_general/${value.id}`}>Ver mas</Button>
                                    </Link>
                                </TableCell>
                            </TableRow>
                        )
                    })}
                </TableBody>

            </Table>
        </TableContainer>
    )
}


export default TablaAvisos