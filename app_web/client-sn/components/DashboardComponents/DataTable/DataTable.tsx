import { Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Typography } from "@material-ui/core"
import React, { useEffect, useState } from "react"
import { Paciente } from "../../../interfaces/Paciente"
import dashboardService from "../../../services/DashboardService"
import { DataFilters } from "../../../types/DashboardPatientType"

type DataTableProps = {
    dataFilters: DataFilters
    storeDataFilters: React.Dispatch<React.SetStateAction<DataFilters>>
}

const DataTable = ({ dataFilters, storeDataFilters }: DataTableProps) => {
    const { departamento_id, genero_id, diagnostico_id } = dataFilters
    const [data, storeData] = useState<Paciente[]>([])

    useEffect(() => {
        let mount = true
        const fetchData = async () => {
            const response = await dashboardService.getPacientes({ departamento_id, genero_id, diagnostico_id }, dataFilters.page, 10)
            if (response && mount) {
                storeData(response.data)
                if (response.last_page !== dataFilters.total_pages) {
                    storeDataFilters({
                        ...dataFilters,
                        total_pages: response.last_page
                    })
                }
            }
        }

        fetchData()
    }, [dataFilters])

    return (
        <>
            <TableContainer>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>
                                Id
                            </TableCell>
                            <TableCell>
                                Genero
                            </TableCell>
                            <TableCell>
                                Departamento
                            </TableCell>
                            <TableCell>
                                Nivel instruccion
                            </TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {
                            data.map((value, index) => {
                                return <TableRow key={index + "table-data"}>
                                    <TableCell>
                                        {value.id}
                                    </TableCell>
                                    <TableCell>
                                        {value.genero?.nombre}
                                    </TableCell>
                                    <TableCell>
                                        {value.departamento?.nombre}
                                    </TableCell>
                                    <TableCell>
                                        {value.nivel_instruccion?.nombre_nivel}
                                    </TableCell>
                                </TableRow>
                            })
                        }
                    </TableBody>
                </Table>

            </TableContainer>
        </>
    )
}

export default DataTable