import { AppBar, Toolbar } from "@material-ui/core"
import { Person } from "@material-ui/icons"
import { useState } from "react"
import MenuUser from "../MenuUser/MenuUser"
import styles from './Navbar.module.scss'
const Navbar = () => {
    const [openMenu, storeOpenMenu] = useState(null)
    
    return (
        <AppBar position="static">
            <Toolbar>
                <div className="d-flex w-100 pr-5 justify-content-end">
                    <h5 className="text-white mt-1">Carolina</h5>
                    <button aria-describedby={'menuuser'} className={`${styles.accountButton}`} onClick={(e)=>storeOpenMenu(e.currentTarget)}>
                        <Person  />
                    </button>
                    <MenuUser open={openMenu} storeOpenMenu={storeOpenMenu} />
                </div>
            </Toolbar>
        </AppBar>
    )
}

export default Navbar