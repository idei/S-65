import Head from "next/head"
import { Table, TableContainer, TableHead, TableRow, TableCell, TableBody } from "@material-ui/core"
import { useRouter } from "next/router"
import React, { useEffect, useState } from "react"
import Layout from "../../../components/ui/Layout/Layout"
import Navbar from "../../../components/ui/Navbar/Navbar"
import { AvisoGeneral } from "../../../interfaces/AvisoGeneral"
import avisosGeneralesServices from "../../../services/AvisosGeneralesServices"

const Aviso = () => {
    const router = useRouter()
    const { id } = router.query

    const [avisoGeneral, storeAvisoGeneral] = useState<AvisoGeneral>(null)

    useEffect(() => {
        let mount = true
        const fetchData = async () => {
            const response = await avisosGeneralesServices.getAvisoById(Number(id))
            if (response) {
                storeAvisoGeneral(response)
            }
        }

        if (id !== null && id !== undefined) {
            fetchData()
        }
        return () => { mount = false }
    }, [id])

    if (avisoGeneral === null) {
        return <></>
    }

    return (
        <>
            <Head>
                <title>Sistema de salud</title>
            </Head>
            <Layout>
                <Navbar />
                <div className="mt-2 pb-5 px-5">
                    <h2>Datos del aviso</h2>
                    <div className="d-flex flex-column">
                        <label><b>Descripcion completa:</b><br></br> {avisoGeneral.descripcion}</label>
                        <label><b>Url:</b> {avisoGeneral.url_imagen}</label>
                    </div>
                    <h3 className="mt-1">Pacientes avisados</h3>
                    <TableContainer>
                        <Table>
                            <TableHead>
                                <TableRow>
                                    <TableCell>
                                        Nombre del paciente
                                    </TableCell>
                                    <TableCell>
                                        Fecha de nacimiento
                                    </TableCell>
                                    <TableCell>
                                        Dni
                                    </TableCell>
                                    <TableCell>
                                        Departamento
                                    </TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {avisoGeneral.pacientes?.map((value, index) => {
                                    const birthDay = new Date(value.fecha_nacimiento)
                                    return (
                                        <TableRow key={index + 'rowData'}>
                                            <TableCell>
                                                {value.nombre + ' ' + value.apellido}
                                            </TableCell>
                                            <TableCell>
                                                {`${String(birthDay.getDate()).padStart(2,'0')}/${String(birthDay.getMonth()+1).padStart(2,'0')}/${birthDay.getFullYear()}`}
                                            </TableCell>
                                            <TableCell>
                                                {value.dni}
                                            </TableCell>
                                            <TableCell>
                                                {value.departamento.nombre}
                                            </TableCell>
                                        </TableRow>
                                    )
                                })}
                            </TableBody>
                        </Table>
                    </TableContainer>
                </div>

            </Layout>
        </>
    )
}

export default Aviso