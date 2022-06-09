import { createMuiTheme } from "@material-ui/core";
import { blue, indigo, red, } from "@material-ui/core/colors";

const theme = createMuiTheme({
    palette: {
        primary: {
            main: red[700]
        },
        secondary: indigo,
    }
})

export default theme