import Head from "next/head"
import React from "react"
import AvisosCabecera from "../../components/NoticeComponents/AvisosCabecera/AvisosCabecera"
import TablaAvisos from "../../components/NoticeComponents/TablaAvisos/TablaAvisos"

import Layout from "../../components/ui/Layout/Layout"
import Navbar from "../../components/ui/Navbar/Navbar"

const Index = () => {
    return (
        <>
            <Head>
                <title>Sistema de salud</title>
            </Head>
            <Layout>
                <Navbar />
                <div className="px-5">
                    <h1>Avisos</h1>
                    <AvisosCabecera />
                    <h3>Tabla de avisos generales</h3>
                    <TablaAvisos />
                </div>
 
            </Layout>
        </>
    )
}

export default Index