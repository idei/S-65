import { MenuItem, TextField } from "@material-ui/core"
import React, { useEffect, useState } from "react"
import { Departamento } from "../../../interfaces/Departamento"
import { Diagnostico } from "../../../interfaces/Diagnostico"
import { Genero } from "../../../interfaces/Genero"
import departamentosService from "../../../services/DepartamentosService"
import diagnosticoService from "../../../services/DiagnosticoService"
import generoService from "../../../services/GeneroService"
import ModalDiagnostics from "../ModalDiagnostics/ModalDiagnostics"

type SelectFormProps = {
    onChangeGenero: (id: number) => void,
    onChangeDepartamento: (id: number) => void,
    onChangeDiagnostico: (id: number) => void
}

const SelectForm = ({onChangeGenero, onChangeDepartamento, onChangeDiagnostico}: SelectFormProps) => {
    const [departamentos, storeDepartamentos] = useState<Departamento[]>([])
    const [generos, storeGeneros] = useState<Genero[]>([])
    const [valueSelect, storeValueSelect] = useState(0)
    const [valueSecondSelect, storeValueSecondSelect] = useState(0)
    const [openDialog, storeOpenDialog] = useState(false)
    const onChangeValueSelect = (e) => {
        storeValueSecondSelect(0)
        storeValueSelect(e.target.value)
        if(e.target.value == 3){
            storeOpenDialog(true)
        }
    }


    const onChangeValueSecondSelect = (e) => {
        storeValueSecondSelect(e.target.value)
        
        switch(Number(valueSelect)) {
            case 1:
                onChangeDepartamento(e.target.value)
                break;
            case 2:
                onChangeGenero(e.target.value)
                break
        }
    }

    useEffect(() => {
        let mount = true

        const fetchDepartamentos = async () => {
            const response = await departamentosService.getDepartamentos()
            if (response.length !== 0 && mount) {
                storeDepartamentos(response)
            }
        }

        const fetchGeneros = async () => {
            const response = await generoService.getGeneros()
            if (response.length !== 0 && mount) {
                storeGeneros(response)
            }
        }
        fetchDepartamentos()
        fetchGeneros()
    }, [])

    return (
        <>
            <ModalDiagnostics 
                open={openDialog}
                storeDiagnostic={onChangeDiagnostico}
                storeOpen={storeOpenDialog}
                storeValueSelect={storeValueSelect}
            />
            <TextField
                select
                fullWidth
                className="mb-2"
                onChange={onChangeValueSelect}
                value={valueSelect}
            >
                <MenuItem disabled value="0">Seleccione un tipo de consulta</MenuItem>
                <MenuItem value="1">Por departamento</MenuItem>
                <MenuItem value="2">Por genero</MenuItem>
                <MenuItem value="3">Por diagnostico</MenuItem>
            </TextField>
            {valueSelect == 0 ?
                <TextField
                    select
                    fullWidth
                    disabled
                    value="0"
                >
                    <MenuItem disabled value="0">Debe seleccionar un tipo de consulta</MenuItem>
                </TextField> : null
            }
            {valueSelect == 1 ?
                <TextField
                    select
                    fullWidth
                    value={valueSecondSelect}
                    onChange={onChangeValueSecondSelect}
                >
                    <MenuItem disabled value="0">Seleccione un departamento</MenuItem>
                    {
                        departamentos.map((value, index) =>(
                            <MenuItem value={value.id} key={value.id + "departamento-select"}>{value.nombre}</MenuItem>
                        ))
                    }
                </TextField> : null
            }
            {valueSelect == 2 ?
                <TextField
                    select
                    fullWidth
                    value={valueSecondSelect}
                    onChange={onChangeValueSecondSelect}
                >
                    <MenuItem disabled value="0">Seleccione un genero</MenuItem>
                    {
                        generos.map((value, index) =>(
                            <MenuItem value={value.id} key={value.id + "generp-select"}>{value.nombre}</MenuItem>
                        ))
                    }
                </TextField> : null
            }
            
        </>
    )
}

export default SelectForm