import express, { Express, Router } from 'express'
import db from '../config/DB';
import DepartamentoRouter from '../routes/departamentos'
import AvisosGeneralesRouter from '../routes/avisosGenerales'
import EventoRouter from '../routes/eventos'
import AuthRouter from '../routes/auth'
import DashboardRouter from '../routes/dashboard'
import PacienteRouter from '../routes/pacientes'
import DatoClinicoRouter from '../routes/datosClinicos'
import RecordatorioMedicoRouter from '../routes/recordatoriosMedicos'
import TipoScreeningRouter from '../routes/tipoScreening'
import AntecedenteMedicoFamiliarRouter from '../routes/antecedentesMedicosFamiliares'
import AntecedenteMedicoPersonalRouter from '../routes/antecedentesMedicosPersonales'
import DiagnosticoRouter from '../routes/diagnosticos'
import GeneroRouter from '../routes/generos'
import MedicoRouter from '../routes/medicos'
import dotenv from 'dotenv'
import cors from 'cors'

class Server {
    port: number;
    app: Express;
    constructor() {
        dotenv.config()
        this.app = express()
        const csv = require('csv-express')
        this.port = 8000
        this.app.use(express.json())
        this.app.use(cors())
        this.checkDatabase()
        this.addRoutes()
    }

    async checkDatabase() {
        await db.authenticate()
    }

    listen() {
        this.app.listen(this.port, () => {
            console.log(`⚡️[server]: Server is running at https://localhost:${this.port}`);
        });
    }

    addRoutes() {
        this.app.use('/api/departamentos', DepartamentoRouter)
        this.app.use('/api/avisos_generales', AvisosGeneralesRouter)
        this.app.use('/api/avisos_generales', AvisosGeneralesRouter)
        this.app.use('/api/eventos', EventoRouter)
        this.app.use('/api/pacientes', PacienteRouter)
        this.app.use('/api/datos_clinicos', DatoClinicoRouter)
        this.app.use('/api/recordatorios_medicos', RecordatorioMedicoRouter)
        this.app.use('/api/tipos_screening', TipoScreeningRouter)
        this.app.use('/api/antecedentes_medicos_familiares', AntecedenteMedicoFamiliarRouter)
        this.app.use('/api/antecedentes_medicos_familiares', AntecedenteMedicoFamiliarRouter)
        this.app.use('/api/dashboard', DashboardRouter)
        this.app.use('/api/medicos',MedicoRouter)
        this.app.use('/api/generos',GeneroRouter)
        this.app.use('/api/diagnosticos',DiagnosticoRouter)
        this.app.use('/api/', AuthRouter)


    }
}

export default Server