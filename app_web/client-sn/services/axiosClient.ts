import axios from "axios";

const axiosClient = axios.create(
    {
        baseURL: 'http://localhost:8000/api',
        // baseURL: 'https://backsistemascreening.herokuapp.com/api'
    }
)

export default axiosClient