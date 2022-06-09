import { Grid, MenuItem, TextField } from "@material-ui/core"
import React, { useEffect, useState } from "react"
import { RecordatorioMedico } from "../../../interfaces/RecordatorioMedico"
import { TipoScreening } from "../../../interfaces/TipoScreening"
import tipoScreeningService from "../../../services/TipoScreeningService"

type ScreeningFormProps = {
    data?: RecordatorioMedico,
    storeData?: React.Dispatch<React.SetStateAction<RecordatorioMedico>>
}

const ScreeningForm = ({ data, storeData }: ScreeningFormProps) => {
    const [tiposScreenings, storeTiposScreenings] = useState<TipoScreening[]>([])
    if(data === null || data === undefined){
        [data, storeData] = useState<RecordatorioMedico>({
            descripcion: '',
            fecha_creacion: '',
            paciente: null,
            rela_medico: 1,
            rela_estado_recordatorio: 0,
            fecha_limite: '',
            rela_paciente: 1,
            rela_screening: 0,
            rela_respuesta_screening: null
        })
    }
    const onChange = (e)=>{
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
    return (
        <Grid container>
            <Grid item xs={6}>
                <TextField
                    select
                    value={data.rela_screening}
                    defaultValue="0"
                    name="rela_screening"
                    onChange={onChange}
                    fullWidth
                    label="Seleccione el tipo">
                        <MenuItem value="0" disabled>Seleccione el tipo</MenuItem>
                        {
                            tiposScreenings.map((value,index)=>{
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
                    name="fecha_limite"
                    fullWidth
                    label="Fecha Limite"/>
            </Grid>
        </Grid>
    )
}

export default ScreeningForm