import { Button, Dialog, DialogActions, DialogContent, DialogTitle } from "@material-ui/core"
import { Dispatch } from "react"
import { Paciente } from "../../../interfaces/Paciente"
import styles from './ModalFounded.module.scss'
type ModalFoundedProps = {
    show: boolean,
    storeShow: Dispatch<boolean>,
    paciente: Paciente,
    onClickAccept: ()=>void
    
}


const ModalFounded = ({ show, storeShow, paciente, onClickAccept }: ModalFoundedProps) => {
    const handleClose = () => {
        storeShow(false)
    }

    const onClickAcceptButton = () => {
        storeShow(false)
        onClickAccept()
    }


    if (!paciente) {
        return null
    }
    return (
        <Dialog
            open={show && Boolean(paciente)}
            onClose={handleClose}
        >
            <DialogTitle>Datos de paciente</DialogTitle>
            <DialogContent>
                <div className={`d-flex flex-column ${styles.container}`}>
                    <h6>Nombre: {paciente?.nombre}</h6>
                    <h6>Apellido: {paciente?.apellido}</h6>
                    <h6>Contacto: {paciente?.contacto}</h6>
                </div>
            </DialogContent>
            <DialogActions>
                <Button variant="contained" onClick={onClickAcceptButton} color="primary" >Aceptar</Button>
                <Button variant="contained" onClick={handleClose} color="secondary" >Cancelar</Button>
            </DialogActions>
        </Dialog>
    )
}

export default ModalFounded