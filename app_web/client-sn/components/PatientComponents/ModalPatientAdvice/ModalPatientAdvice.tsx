import React, { useState } from "react"
import { Button, Dialog, DialogActions, DialogContent, DialogTitle, Grid, MenuItem, TextField } from '@material-ui/core'
import { RecordatorioMedico } from "../../../interfaces/RecordatorioMedico"
import { Paciente } from "../../../interfaces/Paciente"
import ToastProps from "../../../types/ToastProps"
import recordatorioScreeningService from "../../../services/RecordatorioScreeningService"

type ModalPatienAdviceProps = {
    show: boolean,
    storeShow: React.Dispatch<React.SetStateAction<boolean>>,
    paciente: Paciente,
    storeToast: React.Dispatch<React.SetStateAction<ToastProps>>
}

type FormErrors = {
    fecha_limite: null | string,
    descripcion: null | string
}
const ModalPatientAdvice = ({ show, storeShow, paciente, storeToast }: ModalPatienAdviceProps) => {

    const initialData: RecordatorioMedico = {
        fecha_limite: '',
        descripcion: '',
        rela_paciente: paciente.id,
        rela_estado_recordatorio: 1,
        rela_medico: 1,
        rela_respuesta_screening: null,
        rela_screening: 0
    }
    const initialErrors: FormErrors = {
        descripcion: null,
        fecha_limite: null
    }
    const [data, storeData] = useState(initialData)
    const [errors, storeErrors] = useState(initialErrors)

    const handleClose = () => {
        storeShow(false)
    }

    const onChange = (e) => {
        storeData({
            ...data,
            [e.target.name]: e.target.value
        })
    }

    const onClickCancel = () => {
        storeData(initialData)
        storeShow(false)
    }

    const onClickAccept = async () => {
        if (data.descripcion === '' || data.fecha_limite === '') {
            storeErrors({
                descripcion: data.descripcion === '' ? 'Este dato es obligatorio' : null,
                fecha_limite: data.fecha_limite === '' ? 'Este dato es obligatorio' : null
            })
        }else{
            const response = await recordatorioScreeningService.storeRecordatorio(data)
            if(response){
                storeToast({
                    color: "success",
                    show: true,
                    text: 'El aviso se envio con exitó'
                })
                storeShow(false)
            }else{
                storeToast({
                    color: "error",
                    show: true,
                    text: 'El aviso no se puedo enviar'
                })
            }
        }
    }

    return (
        <Dialog
            open={show}
            onClose={handleClose}
            maxWidth="sm"
            fullWidth
        >
            <DialogTitle>Formulario de aviso</DialogTitle>
            <DialogContent>
                <Grid container>
                    <Grid item xs={6}>
                        <TextField
                            name="descripcion"
                            value={data.descripcion}
                            onChange={onChange}
                            placeholder="Escriba aqui su descripcion"
                            label="Descripcion"
                            fullWidth
                            error={Boolean(errors.descripcion && data.descripcion === '')}
                            helperText={errors.descripcion && data.descripcion === '' ? errors.descripcion : null}
                            multiline
                            InputLabelProps={{
                                shrink: true
                            }}
                        />
                        <TextField
                            type="date"
                            value={data.fecha_limite}
                            onChange={onChange}
                            error={Boolean(errors.fecha_limite && data.fecha_limite === '')}
                            helperText={errors.fecha_limite && data.fecha_limite === '' ? errors.fecha_limite : null}
                            name="fecha_limite"
                            label="Fecha limite"
                            fullWidth
                            InputLabelProps={{
                                shrink: true
                            }}
                        />
                    </Grid>
                </Grid>
            </DialogContent>
            <DialogActions>
                <Button variant="contained" onClick={onClickAccept} color="primary">Aceptar</Button>
                <Button variant="contained" onClick={onClickCancel} color="secondary">Cancelar</Button>
            </DialogActions>
        </Dialog>
    )
}

export default ModalPatientAdvice