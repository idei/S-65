import { Snackbar } from "@material-ui/core"
import { Alert, AlertProps, Color } from "@material-ui/lab"

import React from "react"

type ToastProps = {
    open: boolean,
    storeOpen: React.Dispatch<React.SetStateAction<boolean>>,
    text?: string,
    type: Color
}

const Toast = ({ open, storeOpen, type, text }: ToastProps) => {
    const handleClose = () => {
        storeOpen(false)
    }
    return (
        <Snackbar
            open={open}
            autoHideDuration={6000}
            onClose={handleClose}
            anchorOrigin={{
                horizontal: "right",
                vertical: "top"
            }}
        >
            <Alert
                onClose={handleClose}
                severity={type}
                elevation={6}
            >
                {text}
            </Alert>
        </Snackbar>
    )
}

export default Toast