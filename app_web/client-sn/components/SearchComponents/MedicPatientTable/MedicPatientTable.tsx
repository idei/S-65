import { Button, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from "@material-ui/core";
import { useEffect, useState } from "react";
import { useAuth } from "../../../hooks/useAuth";
import { Paciente } from "../../../interfaces/Paciente";
import { PaginateInterface } from "../../../interfaces/PaginateInterface";
import medicoService from "../../../services/MedicoService";
import pacienteService from "../../../services/PacienteService";

const MedicPatientTable = () => {

    const { user_id } = useAuth()

    const [data, storeData] = useState<PaginateInterface<Paciente>>(null)


    useEffect(() => {
        let mount = true

        const fetchData = async () => {
            const response = await medicoService.getByUserId(Number(user_id))
            if (response) {
                const dataFromBack = await pacienteService.getPacienteByMedicId(response.id)
                if(dataFromBack && mount) {
                    storeData(dataFromBack)
                }
            }
        }

        fetchData()
        return () => { mount = false }
    }, [])


    if(data == null){
        return null
    }


    return (
        <TableContainer>
            <Table>
                <TableHead>
                    <TableRow>
                        <TableCell>
                            Dni
                        </TableCell>
                        <TableCell>
                            Nombre y apellido
                        </TableCell>
                        <TableCell>
                            Fecha de alta
                        </TableCell>
                        <TableCell>
                            Acciones
                        </TableCell>
                    </TableRow>
                </TableHead>
                <TableBody>
                    {
                        data.data?.map((value) => {
                            return (
                                <TableRow key={value.id + "datos"}>
                                    <TableCell>
                                        {value.dni}
                                    </TableCell>
                                    <TableCell>
                                        {value.nombre + " " + value.apellido}
                                    </TableCell>
                                    <TableCell>
                                        rwgw
                                    </TableCell>
                                    <TableCell>
                                        <Button variant="text" >Ver</Button>
                                    </TableCell>
                                </TableRow>
                            )
                        })
                    }
                </TableBody>
            </Table>
        </TableContainer>
    )
};

export default MedicPatientTable