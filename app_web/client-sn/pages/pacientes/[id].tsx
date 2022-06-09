import Head from "next/head";
import { useRouter } from "next/router"
import { useEffect, useState } from "react";
import PacientData from "../../components/SearchComponents/PacientData/PacientData";
import Layout from "../../components/ui/Layout/Layout";
import Navbar from "../../components/ui/Navbar/Navbar";
import Toast from "../../components/ui/Toast/Toast";
import { Paciente } from "../../interfaces/Paciente";
import pacienteService from "../../services/PacienteService";
import ToastProps from "../../types/ToastProps";

const Index = () => {
    const router = useRouter()
    const { id } = router.query;

    const [paciente, storePaciente] = useState<Paciente>(null)
    const [errorPage, storeErrorPage] = useState(false)
    const [showToast, storeToast] = useState<ToastProps>(null)
    useEffect(() => {
        if (id) {
            const fetchData = async () => {
                const response = await pacienteService.getPacienteById(Number.parseInt(id.toString()))
                if (response) {
                    storePaciente(response)
                }
                else {
                    storeErrorPage(true)
                }
            }
            fetchData()
        }
    },[showToast,id])

    if (errorPage) {
        return (
            <h4>El paciente no fue encontrado</h4>
        )
    }

    console.log(paciente?.datos_clinicos)

    return (
        <>
            <Head>
                <title>Sistema de salud</title>
            </Head>
            <Layout>
                <Navbar />
                {showToast ? <Toast open={showToast.show} text={showToast.text} type={showToast.color} storeOpen={(value: boolean)=>{storeToast({...showToast, show: value})}} /> : null}
                <div className="px-5">
                    
                <PacientData paciente={paciente} storeToast={storeToast} />
                </div>
            </Layout>
        </>
    )
}

export default Index