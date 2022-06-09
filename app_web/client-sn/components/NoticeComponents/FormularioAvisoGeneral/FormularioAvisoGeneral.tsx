import { Button, MenuItem, TextareaAutosize, TextField, TypographyVariant } from "@material-ui/core"
import React, { useEffect, useState } from "react"
import { AvisoGeneral } from "../../../interfaces/AvisoGeneral"
import { Departamento } from "../../../interfaces/Departamento"
import avisosGeneralesServices from "../../../services/AvisosGeneralesServices"
import departamentosService from "../../../services/DepartamentosService"
import generoService from "../../../services/GeneroService"
import FormularioEdad from "../FormularioEdad/FormularioEdad"
import styles from './FormularioAvisoGeneral.module.scss'
type FormularioAvisoGeneralErrors = {
    descripcion: string,
    url_imagen?: string,
    fecha_limite: string,
    valueSelect: string,
    departament: string,
    minAge: string,
    maxAge: string,
    genero: string
}

const FormularioAvisoGeneral = () => {
    const initialErrors: FormularioAvisoGeneralErrors = {
        descripcion: null,
        url_imagen: null,
        fecha_limite: null,
        valueSelect: null,
        departament: null,
        minAge: null,
        maxAge: null,
        genero: null
    }
    const [avisoGeneral, storeAvisoGeneral] = useState<AvisoGeneral>({
        descripcion: '',
        fecha_creacion: null,
        fecha_limite: null,
        rela_creado: null,
        url_imagen: '',
        rela_estado: null
    })
    const [errors, storeErrors] = useState<FormularioAvisoGeneralErrors>(initialErrors)
    const [valueSelect, storeValueSelect] = useState(0)
    const [departmentList, storeDepartmentList] = useState<Departamento[]>([])
    const [valueDepartment, storeDepartment] = useState(0)
    const [generoList, storeGeneroList] = useState([])
    const [valueGenero, storeValueGenero] = useState(0)
    const [ages, storeAges] = useState({
        min: 0,
        max: 100
    })
    const types = avisosGeneralesServices.getAllTypes()
    useEffect(() => {
        let mount = true
        const getDepartamentos = async () => {
            const response = await departamentosService.getDepartamentos()
            if (response.length !== 0 && mount) {
                storeDepartmentList(response)
            }
        }
        const getGeneros = async () => {
            const response = await generoService.getGeneros()
            if (response.length !== 0 && mount) {
                storeGeneroList(response)
            }
        }
        getDepartamentos()
        getGeneros()
        return () => { mount = false }
    }, [])

    const onChange = (e) => {
        storeAvisoGeneral({
            ...avisoGeneral,
            [e.target.name]: e.target.value
        })
    }

    const onSubmit = async (e) => {
        if (e.preventDefault) {
            e.preventDefault()
        }
        //Validaciones 
        if (avisoGeneral.descripcion === ''
            || avisoGeneral.fecha_limite === ''
            || valueSelect === 0
            || avisoGeneral.url_imagen === ''
            || (valueSelect === 1 && valueDepartment === 0)
            || (valueSelect === 3 && valueGenero === 0)) {
            storeErrors({
                ...errors,
                url_imagen: 'Este campo es obligatorio',
                descripcion: 'Este campo es obligatorio',
                fecha_limite: 'Este campo es obligatorio',
                valueSelect: 'Debe seleccionar un tipo',
                departament: 'Debe seleccionar un departamento',
                genero: 'Debe seleccionar un genero'
            })
        } else {
            let response: boolean
            switch (valueSelect) {
                case 1: response = await avisosGeneralesServices.storeAviso({ ...avisoGeneral, departamento_id: valueDepartment })
                    break;
                case 2: response = await avisosGeneralesServices.storeAviso({ ...avisoGeneral, minEdad: ages.min, maxEdad: ages.max })
                    break;
                case 3: response = await avisosGeneralesServices.storeAviso({ ...avisoGeneral, genero_id: valueGenero })
                    break;
                default:
                    response = null
                    break;
            }
            if (response) {
                console.log("Funciono")
            } else {
                console.log("Ocurrio un error")
            }
        }
    }
    const onChangeValueSelect = (e) => {
        storeValueSelect(e.target.value)
    }
    const onChangeValueDepartment = (e) => {
        storeDepartment(e.target.value)
    }
    const onChangeValueGenero = (e) => {
        storeValueGenero(e.target.value)
    }
    const onChangeAges = (e) => {
        storeAges({
            ...ages,
            [e.target.name]: e.target.value
        })
    }

    const validateMinAge = (): Boolean => {
        if (ages.min) {
            return ages.min >= 0 && ages.min <= 100
        } else {
            return Boolean(ages.max)
        }
    }

    const validateMaxAge = (): Boolean => {
        if (ages.max) {
            return ages.max >= 0 && ages.max <= 100 && ages.min <= ages.max
        } else {
            return Boolean(ages.max)
        }
    }


    return (
        <form className="d-flex" onSubmit={onSubmit}>
            <div className={`d-flex flex-column w-75 ${styles.paddingRight}`}>
                <div className="d-flex mb-2 flex-column">
                    <label className="mb-1">Descripcion</label>
                    <TextField
                        multiline
                        placeholder="Escriba aqui una descripción"
                        variant="outlined"
                        fullWidth
                        error={Boolean(errors.descripcion && avisoGeneral.descripcion === '')}
                        helperText={errors.descripcion && avisoGeneral.descripcion === '' ? errors.descripcion : null}
                        name="descripcion"
                        onChange={onChange} />
                </div>
                <div className="d-flex mb-2 flex-column">
                    <label>Seleccionar tipo</label>
                    <TextField
                        select
                        value={valueSelect}
                        error={Boolean(errors.valueSelect && valueSelect === 0)}
                        helperText={errors.valueSelect && valueSelect === 0 ? errors.valueSelect : null}
                        onChange={onChangeValueSelect}
                    >
                        <MenuItem disabled value="0">Seleccione el tipo</MenuItem>
                        {
                            types.map((value, index) => (
                                <MenuItem key={index + value} value={index + 1}>{value}</MenuItem>
                            ))
                        }
                    </TextField>
                </div>
                {valueSelect === 1 && <div className="d-flex mb-2 flex-column">
                    <label>Selecciona el departamento</label>
                    <TextField
                        select
                        value={valueDepartment}
                        onChange={onChangeValueDepartment}
                        error={Boolean(valueSelect === 1 && valueDepartment === 0 && errors.departament)}
                        helperText={valueSelect === 1 && valueDepartment === 0 && errors.departament ? errors.departament : null}
                    >
                        <MenuItem disabled value="0">Seleccione el departamento</MenuItem>
                        {
                            departmentList.map((value, index) => (
                                <MenuItem key={index + value.nombre} value={value.id}>{value.nombre}</MenuItem>
                            ))
                        }
                    </TextField>
                </div>}
                {valueSelect === 2 && <FormularioEdad ages={ages} storeAges={storeAges} />}
                {valueSelect === 3 &&
                    <div className="d-flex mb-2 flex-column">
                        <label>Selecciona el genero</label>
                        <TextField
                            select
                            value={valueGenero}
                            onChange={onChangeValueGenero}
                            error={Boolean(valueSelect === 3 && valueDepartment === 0 && errors.genero)}
                            helperText={valueSelect === 3 && valueDepartment === 0 && errors.genero ? errors.genero : null}
                        >
                            <MenuItem disabled value="0">Seleccione el genero</MenuItem>
                            {
                                generoList.map((value, index) => (
                                    <MenuItem key={index + value.nombre} value={value.id}>{value.nombre}</MenuItem>
                                ))
                            }
                        </TextField>
                    </div>
                }
                <div className="d-flex mt-2 justify-content-between">
                    <div className="d-flex flex-column ">
                        <label>Fecha limite</label>
                        <TextField
                            fullWidth
                            type="date"
                            name="fecha_limite"
                            error={Boolean(errors.fecha_limite && avisoGeneral.fecha_limite === null)}
                            helperText={errors.fecha_limite && avisoGeneral.fecha_limite === null ? errors.fecha_limite : null}
                            onChange={onChange} />
                    </div>
                    <div className="d-flex flex-column ">
                        <label>Url</label>
                        <TextField
                            fullWidth
                            placeholder="https://www.google.com/"
                            type="text"
                            name="url_imagen"
                            onChange={onChange} />
                    </div>
                </div>
                <div className="d-flex justify-content-end mt-2">
                    <Button variant="contained" type="submit" color="primary" >Enviar</Button>
                </div>
            </div>


        </form>
    )
}

export default FormularioAvisoGeneral