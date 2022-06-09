import { Button, Dialog, DialogActions, DialogContent, DialogTitle, Grid, InputAdornment, List, ListItem, ListItemText, Modal, TextField } from "@material-ui/core"
import { Search } from "@material-ui/icons"
import React, { useEffect, useState } from 'react'
import { Diagnostico } from "../../../interfaces/Diagnostico"
import diagnosticoService from "../../../services/DiagnosticoService"
type ModalDiagnosticsProps = {
    open: boolean,
    storeOpen: React.Dispatch<React.SetStateAction<boolean>>
    storeDiagnostic: (id: number) => void,
    storeValueSelect: React.Dispatch<React.SetStateAction<number>>
}


const ModalDiagnostics = ({ open, storeOpen, storeDiagnostic, storeValueSelect }: ModalDiagnosticsProps) => {

    const [diagnostics, storeDiagnostics] = useState<Diagnostico[]>([])
    const [selected, storeSelected] = useState<number>(null)
    const [search, storeSearch] = useState('')

    const onChangeSearch = async (e) => {
        storeSearch(e.target.value)
    }

    const onSelected = (id: number) => {
        storeSelected(id === selected ? null : id)
    }

    const onClose = () => {
        storeOpen(false)
        storeValueSelect(0)
    }
    
    const onClickAccept = () => {
        storeDiagnostic(selected)
        storeOpen(false)
    }

    useEffect(() => {
        let mount = true
        const fetchData = async () => {
            const response = await diagnosticoService.search(search)
            if (mount) {
                storeDiagnostics(response)
            }
        }
        if(search.trim() !== ''){
            fetchData()
        }
        return () => { mount = false }
    }, [search])


    return (
        <Dialog
            open={open}
            onClose={onClose}
            fullWidth
            maxWidth="md"
        >
            <DialogTitle title="Seleccione un diagnostico"></DialogTitle>
            <DialogContent>
                <Grid container>
                    <Grid item xs={6}>
                        <TextField
                            value={search}
                            onChange={onChangeSearch}
                            label="Escriba el nombre de un diagnostico"
                            fullWidth
                        />
                    </Grid>
                </Grid>
                <div className="mt-3">
                    <List>
                        {/* <ListItem button>
                            <ListItemText primary="datos"></ListItemText>
                        </ListItem> */}
                        {
                            diagnostics.map((value, index)=> {
                                return (
                                    <ListItem 
                                        key={index + "list"} 
                                        button 
                                        onClick={()=>onSelected(value.id)}
                                        selected={value.id === selected}
                                        >
                                        <ListItemText primary={value.nombre}></ListItemText>
                                    </ListItem>
                                )
                            })
                        }
                    </List>
                </div>
            </DialogContent>
            <DialogActions>
                <Button variant="contained" disabled={selected == null} onClick={onClickAccept} color="primary">
                    Seleccionar
                </Button>
                <Button variant="contained" onClick={onClose} color="secondary">
                    Cancelar
                </Button>
            </DialogActions>
        </Dialog>
    )
}

export default ModalDiagnostics