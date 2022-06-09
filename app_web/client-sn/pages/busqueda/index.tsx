import { Box, Button, Container, ServerStyleSheets, TextField, Typography } from '@material-ui/core'
import Head from 'next/head'
import { useRouter } from 'next/router';
import React, { useState } from 'react'
import DatosUsuarios from '../../components/Principal/DatosUsuarios';
import MedicPatientTable from '../../components/SearchComponents/MedicPatientTable/MedicPatientTable';
import ModalFounded from '../../components/SearchComponents/ModalFounded/ModalFounded';
import ModalNotFounded from '../../components/SearchComponents/ModalNotFounded/ModalNotFounded';
import PacientData from '../../components/SearchComponents/PacientData/PacientData';
import Layout from '../../components/ui/Layout/Layout';
import Navbar from '../../components/ui/Navbar/Navbar';
import Sidebar from '../../components/ui/Sidebar/Sidebar';
import { useAuth } from '../../hooks/useAuth';
import { Paciente } from '../../interfaces/Paciente';
import pacienteService from '../../services/PacienteService';




export default function Home() {
  const router = useRouter()

  const [documento, guardarDocumento] = useState('')
  const [paciente, guardarPaciente] = useState<Paciente>(null)
  const [mostrarModal, guardarMostrarModal] = useState(false)
  const [mostrarDatos, guardarMostrarDatos] = useState(false)



  const onChangeDocumento = (e: React.ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => {
    e.preventDefault()
    guardarDocumento(e.target.value)
  }

  const onClickBuscar = async (e) => {
    if (e.preventDefault) {
      e.preventDefault()
    }
    const dni = Number(documento)
    const paciente = await pacienteService.getPaciente(dni)
    guardarPaciente(paciente)
    guardarMostrarModal(true)
  }

  const onClickAccept = () => {
    // guardarMostrarDatos(true)
    router.push(`../pacientes/${paciente.id}`)
  }

  return (
    <>
      <Head>
        <title>Sistema de salud</title>
      </Head>
      <Layout>
        <Navbar />
        {
          paciente ?
            <ModalFounded show={mostrarModal} paciente={paciente} storeShow={guardarMostrarModal} onClickAccept={onClickAccept} /> :
            <ModalNotFounded show={mostrarModal} storeShow={guardarMostrarModal} />
        }
        <div className="container">
          <Typography variant="h4">
            Ver datos de paciente
          </Typography>
          <div className="d-flex w-100 flex-column">
            <form className="w-50" onSubmit={onClickBuscar} noValidate>
              <Box display="flex" flexDirection="column" className="">
                <TextField label="Escribir DNI de paciente" variant="standard" type="number" className="mb-3" onChange={onChangeDocumento} value={documento} />
                <Button variant="contained" type="submit" color="primary" onClick={onClickBuscar}>Buscar</Button>
              </Box>
            </form>
          </div>
          <div className="mt-2">
            {/* <h3>Mis pacientes</h3> */}
            {/* <MedicPatientTable /> */}
          </div>
        </div>
      </Layout>
    </>
  )
}
