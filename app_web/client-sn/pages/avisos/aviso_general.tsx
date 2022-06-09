import Head from "next/head"
import React from "react"
import FormularioAvisoGeneral from "../../components/NoticeComponents/FormularioAvisoGeneral/FormularioAvisoGeneral"


import Layout from "../../components/ui/Layout/Layout"
import Navbar from "../../components/ui/Navbar/Navbar"

const AvisoGeneral = () => {
    return (
        <>
            <Head>
                <title>Sistema de salud</title>
            </Head>
            <Layout>
                <Navbar />
                <div className="px-5">
                    <h1>Avisos generales</h1>
                    <FormularioAvisoGeneral />
                </div>

            </Layout>
        </>
    )
}

export default AvisoGeneral