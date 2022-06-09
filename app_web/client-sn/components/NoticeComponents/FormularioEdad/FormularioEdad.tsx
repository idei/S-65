import styles from './FormularioEdad.module.scss'
import { TextField } from '@material-ui/core'
import { AgeType } from '../../../types/AgeType'
import React from 'react'

type FormularioEdadProps = {
    ages: AgeType,
    storeAges: React.Dispatch<React.SetStateAction<AgeType>>
}

const FormularioEdad = ({ ages, storeAges }: FormularioEdadProps) => {
    const onChangeAges = (e) => {
        storeAges({
            ...ages,
            [e.target.name]: e.target.value
        })
    }
    const validateMinAge = (): boolean => {
        if (String(ages.min) !== '') {
            return ages.min >= 0 && ages.min <= 100 && ages.min <= ages.max
        } else {
            return Boolean(ages.max)
        }
    }

    const validateMaxAge = (): boolean => {
        if (String(ages.max) !== '') {
            return ages.max >= 0 && ages.max <= 100 && ages.min <= ages.max
        } else {
            return Boolean(ages.min)
        }
    }
    const errorStringMin = ():String => {
        if (String(ages.min) !== '') {
            if(Number(ages.min) <= 0){
                return 'El valor debe ser mayor a 0'
            }
            if(ages.min > 100){
                return 'El valor debe ser menor a 100'
            }
            if(ages.min > ages.max){
                return 'El minimo debe ser menor al maximo'
            }
            return null
        } else {
            return !Boolean(ages.max) ? 'Debe tener una edad minima o una maxima' : null
        }
    }
    return (
        <div className="d-flex mb-2 flex-column">
            <label>Escriba la edad</label>
            <div className="d-flex aling-items-center">
                <div className={`${styles.paddingRight}`}>
                    <TextField
                        value={ages.min}
                        onChange={onChangeAges}
                        name="min"
                        label="Edad minima"
                        error={!validateMinAge()}
                        helperText={errorStringMin()}
                        type="number"
                        fullWidth
                        InputProps={{ inputProps: { min: 0 } }}
                    />
                </div>
                <div className={`${styles.paddingRight}`}>
                    <TextField
                        value={ages.max}
                        onChange={onChangeAges}
                        label="Edad maxima"
                        name="max"
                        type="number"
                        error={!validateMaxAge()}
                        fullWidth
                        InputProps={{ inputProps: { min: 1 } }}
                    />
                </div>
            </div>
        </div>
    )
}

export default FormularioEdad