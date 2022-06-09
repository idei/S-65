import { Box, Button, Card, CardContent, Container, OutlinedInput, ServerStyleSheets, TextField, Typography } from '@material-ui/core'
import Head from 'next/head'
import React, { Dispatch, useContext, useEffect, useState } from 'react'
import DatosUsuarios from '../components/Principal/DatosUsuarios';
import { Paciente } from '../interfaces/Paciente';
import styles from '../styles/Home.module.scss'
import router, { useRouter } from "next/router";
import { useAuth } from '../hooks/useAuth';
import authService from '../services/AuthService';
import { useRoleSystem } from '../hooks/useRoleSystem';

type LoginForm = {
  email: string,
  password: string
}

const Home = () => {
  const initialForm: LoginForm = {
    email: '',
    password: ''
  }
  const router = useRouter()
  const { storeAuthState, storeAuth } = useAuth()
  const { setRol } = useRoleSystem()
  const [form, storeForm] = useState(initialForm)
  const [error, storeError] = useState(false)

  const onChangeForm = (e) => {
    storeForm({
      ...form,
      [e.target.name]: e.target.value
    })
  }

  const onClickLogin = async () => {
    const { email, password } = form
    ///Falta validacion de email
    const respuesta = await authService.login(email, password)
    if (respuesta) {

      storeAuth({
        nombre: email,
        token: respuesta.token,
        rol: respuesta.rol
      })
      if (respuesta.rol === 1) {
        setRol({
          id: respuesta.user_id,
          nombre: 'Medico'
        })
        router.push('/busqueda')
      } else {
        if (respuesta.rol === 3) {
          router.push('/avisos')
        }else{
          router.push('/informes')
        }
      }
    } else {
      storeError(true)
    }
  }



  useEffect(() => {
    if (window != undefined && window != null) {
      if (window.localStorage.getItem('token')) {
        const rol = Number(window.localStorage.getItem('rol'))
        switch(rol) {
          case 1:
            router.push("/busqueda")
            break;
          case 2:
            router.push("/informes")
            break;
          case 3:
            router.push("/avisos")
          default:
            break;
        }
        
      }
    }
  }, [])


  return (
    <>
      <Head>
        <title>Sistema de salud</title>
      </Head>
      <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center" minHeight="100vh">
        <Card elevation={4} className={`${styles.card}`}>
          <CardContent >
            <div className="d-flex align-items-center flex-column py-5">
              {/* <Avatar className={`${styles.avatar}`}>
                <Lock />
              </Avatar> */}
              <img src="/logo.jpeg" width={250} />

              <form className={`${styles.form} w-75 px-4`} onSubmit={(event) => { event.preventDefault(); onClickLogin() }}>
                <TextField margin="normal" required fullWidth variant="standard" label="Email" type="email" autoComplete="email" name="email" onChange={onChangeForm} />
                <TextField variant="standard"
                  margin="normal"
                  required
                  fullWidth
                  name="password"
                  label="Password"
                  type="password"
                  id="password"
                  onChange={onChangeForm}
                  autoComplete="current-password" />
                <Button variant="contained" color="primary" type="submit" className='mt-4' onClick={onClickLogin}>
                  Login
                </Button>
                {error && <label className={`${styles.labelError}`}>Email o contraseña incorrecta</label>}
              </form>
            </div>
          </CardContent>
        </Card>
      </Box>
    </>
  )
}

export default Home