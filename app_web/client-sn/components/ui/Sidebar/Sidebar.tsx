import { Divider, Drawer, List, ListItem, ListItemIcon, ListItemText } from "@material-ui/core"
import { FileCopy, Info, Person } from "@material-ui/icons"
import styles from './Sidebar.module.scss'
import Link from 'next/link'
import { useAuth } from "../../../hooks/useAuth"

const Sidebar = () => {

    const { pacientes, informes, recordatorios } = useAuth()
    
    return (
        <>
            {/* <div className={`${styles.sidebarWidth} ${styles.minHeigh}`}>
            </div> */}
            <Drawer
                anchor="left"
                variant="persistent"
                open={true}
                className={`${styles.sidebarWidth}`}
            >
                <List className={`${styles.sidebarWidth}`}>
                    <div className={`${styles.blockStart}`}>
                        <img src="/logo.jpeg" width={120} />
                    </div>

                    {pacientes ?
                        <>
                            <Divider />
                            <Link href="/busqueda">
                                <a href="/busqueda" >
                                    <ListItem button>
                                        <ListItemIcon>
                                            <Person />
                                        </ListItemIcon>
                                        <ListItemText primary="Pacientes" />
                                    </ListItem>
                                </a>
                            </Link>
                        </> : null
                    }
                    <Divider />
                    {
                        recordatorios ?
                            <>
                                <Link href="/avisos">
                                    <a href="/avisos" >
                                        <ListItem button>
                                            <ListItemIcon>
                                                <Info />
                                            </ListItemIcon>
                                            <ListItemText primary="Avisos" />
                                        </ListItem>
                                    </a>
                                </Link>
                            </> : null
                    }
                    {
                        informes ?
                            <>
                                <Link href="/informes">
                                    <a href="/informes" >
                                        <ListItem button>
                                            <ListItemIcon>
                                                <FileCopy />
                                            </ListItemIcon>
                                            <ListItemText primary="Informes" />
                                        </ListItem>
                                    </a>
                                </Link>
                            </> : null
                   }
                    <Divider />
    
                </List>
            </Drawer>
        </>
    )
}

export default Sidebar