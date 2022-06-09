import { Button, Dialog, DialogActions, DialogContent, DialogTitle, Grid, MenuItem, TextField } from "@material-ui/core"
import React, { useEffect, useState } from "react"
import { RecordatorioMedico } from "../../../interfaces/RecordatorioMedico"
import { TipoScreening } from "../../../interfaces/TipoScreening"
import recordatorioScreeningService from "../../../services/RecordatorioScreeningService"
import tipoScreeningService from "../../../services/TipoScreeningService"
import ToastProps from "../../../types/ToastProps"
import ScreeningForm from "../../ScreeningsComponents/ScreeningForm/ScreeningForm"

type ModalScreeningFormProps = {
    show: boolean,
    storeShow: React.Dispatch<React.SetStateAction<boolean>>,
    pacienteId: number,
    storeToast: React.Dispatch<React.SetStateAction<ToastProps>>
}

type ErrorsModalScreeningForm = {
    rela_screening: string | null,
    fecha_limite: string | null
}

const ModalScreeningForm = ({ show, storeShow, pacienteId, storeToast }: ModalScreeningFormProps) => {
    const initialData: RecordatorioMedico = {
        descripcion: 'El medico x le envio un chequeo',
        paciente: null,
        rela_medico: 1,
        rela_estado_recordatorio: 2,
        fecha_limite: '',
        rela_paciente: pacienteId,
        rela_screening: 0,
        rela_respuesta_screening: null
    }
    const initialErrors: ErrorsModalScreeningForm = {
        rela_screening: null,
        fecha_limite: null
    }
    const [tiposScreenings, storeTiposScreenings] = useState<TipoScreening[]>([])
    const [data, storeData] = useState<RecordatorioMedico>(initialData)
    const [errors, storeErrors] = useState<ErrorsModalScreeningForm>(initialErrors)
    

    const onChange = (e) => {
        storeData({
            ...data,
            [e.target.name]: e.target.value
        })
    }
    useEffect(() => {
        let mount = true

        const fetchData = async () => {
            const response = await tipoScreeningService.getTipoScreening()
            if (mount && response) {
                console.log(response)
                storeTiposScreenings(response)
            }
        }

        fetchData()
        return () => { mount = false }
    }, [])
    const handleClose = () => {
        storeShow(false)
    }
    const onClickCancel = () => {
        storeData(initialData)
        storeShow(false)
        storeErrors(initialErrors)
    }

    const onClickAccept = async () => {
        //Verificacion
        if (data.rela_screening === 0 || data.fecha_limite === '') {
            storeErrors({
                rela_screening: data.rela_screening === 0 ? 'Este campo es obligatorio' : null,
                fecha_limite: data.fecha_limite === '' ? 'Este campo es obligatorio' : null
            })
            storeToast({
                color: "error",
                show: true,
                text: "Debe completar todos los campos"
            })
        }
        else{
            const response = await recordatorioScreeningService.storeRecordatorio(data)
            if(response){
                storeShow(false)
                storeToast({
                    color: "success",
                    show: true,
                    text: "Los datos se cargaron correctamente",
                })
            }else{
                storeToast({
                    color: "error",
                    show: true,
                    text: "Hubo un error en la carga",
                })
            }
        }
        //Envio
    }

    const Now = new Date()
    return (
        <Dialog
            open={show}
            onClose={handleClose}
            maxWidth="sm"
            fullWidth
        >
            <DialogTitle>Formulario de chequeo</DialogTitle>
            <DialogContent>
                <Grid container>
                    <Grid item xs={6}>
                        <TextField
                            select
                            value={data.rela_screening}
                            defaultValue="0"
                            error={Boolean(errors.rela_screening && data.rela_screening === 0)}
                            helperText={errors.rela_screening && data.rela_screening === 0 ? errors.rela_screening : null}
                            name="rela_screening"
                            onChange={onChange}
                            fullWidth
                            label="Seleccione el tipo">
                            <MenuItem value="0" disabled>Seleccione el tipo</MenuItem>
                            {
                                tiposScreenings.map((value, index) => {
                                    return (
                                        <MenuItem key={index + 'option-tipo'} value={value.id}>{value.nombre}</MenuItem>
                                    )
                                })
                            }
                        </TextField>
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
                            InputProps={{ inputProps: { min: Now } }}
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

export default ModalScreeningForm