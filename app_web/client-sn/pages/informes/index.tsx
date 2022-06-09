import { Typography, TextField, MenuItem, Grid, Button } from "@material-ui/core"
import { Pagination } from "@material-ui/lab"
import Head from "next/head"
import React, { createRef, useEffect, useState } from "react"
import DataTable from "../../components/DashboardComponents/DataTable/DataTable"
import SelectForm from "../../components/DashboardComponents/SelectForm/SelectForm"
import Layout from "../../components/ui/Layout/Layout"
import Navbar from "../../components/ui/Navbar/Navbar"
import { Departamento } from "../../interfaces/Departamento"
import dashboardService from "../../services/DashboardService"
import departamentosService from "../../services/DepartamentosService"
import { DataFilters } from "../../types/DashboardPatientType"

const Informes = () => {
    const [dataFilters, storeDataFilters] = useState<DataFilters>({
        page: 1,
        per_page: 10,
        total_pages: 1,
        departamento_id: null,
        genero_id: null,
        diagnostico_id: null
    })

    const { departamento_id, genero_id, diagnostico_id } = dataFilters
    const [url, storeUrl] = useState<string>('')
    const ref = createRef<HTMLAnchorElement>()

    const onChangeDepartamento = (id: number) => {
        storeDataFilters({
            ...dataFilters,
            departamento_id: id,
            genero_id: null,
            diagnostico_id: null
        })
    }

    const onChangeGenero = (id: number) => {
        storeDataFilters({
            ...dataFilters,
            genero_id: id,
            departamento_id: null,
            diagnostico_id: null
        })
    }

    const onChangeDiagnostico = (id: number) => {
        storeDataFilters({
            ...dataFilters,
            departamento_id: null,
            diagnostico_id: id,
            genero_id: null
        })
    }

    const onClickDownloadCsv = async () => {
        const response = await dashboardService.getCsvPaciente({ departamento_id, genero_id, diagnostico_id })
        if (response) {
            const blob = new Blob([response], { type: 'type/csv' })
            const uri = URL.createObjectURL(blob)
            storeUrl(uri)
            console.log(uri)
        }

    }

    useEffect(() => {
        if (url != '') {
            const node = ref.current
            node.click()
            storeUrl('')
        }

        // 
    }, [url])


    const onChangePage = (event, page: number) => {
        storeDataFilters({
            ...dataFilters,
            page: page
        })
    }
    return (
        <>
            <Head>
                <title>Sistema de salud</title>
            </Head>
            <Layout>
                <Navbar />
                <div className="container">
                    <Typography variant="h3">Datos de pacientes</Typography>
                    <Grid container>
                        <Grid item xs={3}>
                            <SelectForm 
                                onChangeDepartamento={onChangeDepartamento} 
                                onChangeGenero={onChangeGenero}
                                onChangeDiagnostico={onChangeDiagnostico} />
                        </Grid>
                        <Grid item xs={6}></Grid>
                        <Grid item xs={3}>
                            <div className="d-flex justify-content-center flex-column">
                                <Button variant="contained" onClick={onClickDownloadCsv} color="primary" fullWidth>Exportar como CSV</Button>
                            </div>
                        </Grid>
                    </Grid>

                    <DataTable
                        dataFilters={dataFilters}
                        storeDataFilters={storeDataFilters}
                    />
                    <div className="d-flex flex-justify-end w-100">
                        <Pagination page={dataFilters.page} count={dataFilters.total_pages} onChange={onChangePage} />
                    </div>
                </div>
                {/** hiden a */}
                <a ref={ref} href={url} download="Data.txt"></a>
            </Layout>
        </>
    )
}

export default Informes