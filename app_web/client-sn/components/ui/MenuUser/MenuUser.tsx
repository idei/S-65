import { Divider, List, ListItem, ListItemIcon, ListItemText, Popover } from "@material-ui/core"
import { Dispatch } from "react"
import { useRouter } from 'next/router'
import { ExitToApp } from "@material-ui/icons"
import { useAuth } from "../../../hooks/useAuth"
type MenuUserProps = {
    open: any,
    storeOpenMenu: Dispatch<any>
}

const MenuUser = ({ open, storeOpenMenu }: MenuUserProps) => {
    const handleClose = () => {
        storeOpenMenu(null)
    }
    const { deleteToken } = useAuth()
    const router = useRouter()

    const logOut = () => {
        deleteToken()
        router.push('../')
    }
    return (
        <Popover
            open={Boolean(open)}
            anchorEl={open}
            id='menuuser'
            anchorOrigin={{
                vertical: 'bottom',
                horizontal: 'center'
            }}
            transformOrigin={{
                vertical: 'top',
                horizontal: 'right'
            }}
            onClose={handleClose}
        >
            <div className="">

                <List>
                    <ListItem button onClick={logOut}>
                        <ListItemIcon>
                            <ExitToApp />
                        </ListItemIcon>
                        <ListItemText primary="Cerrar sesion" />
                    </ListItem>
                </List>

            </div>
        </Popover>
    )
}

export default MenuUser