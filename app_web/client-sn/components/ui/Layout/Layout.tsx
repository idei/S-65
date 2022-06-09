import Sidebar from "../Sidebar/Sidebar"

const Layout = ({ children }) => {
    return (
        <div className="d-flex">
            <Sidebar />
            <div className="d-block w-100">
                {children}
            </div>
        </div>
    )
}

export default Layout