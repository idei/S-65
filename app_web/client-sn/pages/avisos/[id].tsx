import Head from "next/head"
import React from "react"
import FormularioAvisoGeneral from "../../components/NoticeComponents/FormularioAvisoGeneral/FormularioAvisoGeneral"
import Layout from "../../components/ui/Layout/Layout"
import Navbar from "../../components/ui/Navbar/Navbar"

const Aviso = () => {
    return (
        <>
            <Head>
                <title>Sistema de salud</title>
            </Head>
            <Layout>
                <Navbar />
                

            </Layout>
        </>
    )
}

export default Aviso