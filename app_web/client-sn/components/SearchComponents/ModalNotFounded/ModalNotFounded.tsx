import { Button, Dialog, DialogActions, DialogContent, DialogTitle } from "@material-ui/core"
import { Dispatch } from "react"
import { Paciente } from "../../../interfaces/Paciente"
import styles from './ModalNotFounded.module.scss'
type ModalNotFoundedProps = {
    show: boolean,
    storeShow: Dispatch<boolean>,
    
}


const ModalNotFounded = ({ show, storeShow }: ModalNotFoundedProps) => {
    const handleClose = () => {
        storeShow(false)
    }
    
    return (
        <Dialog
            open={show}
            onClose={handleClose}
        >
            
            <DialogContent>
                <div className={`d-flex flex-column ${styles.container}`}>
                    <h4 className="text-danger">No se encontro ningun paciente con ese dni</h4>
                </div>
            </DialogContent>
            <DialogActions>
                <Button variant="contained" onClick={handleClose} color="primary" >Aceptar</Button>
            </DialogActions>
        </Dialog>
    )
}

export default ModalNotFounded