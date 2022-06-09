import { AppProps } from 'next/dist/next-server/lib/router/router'
import '../styles/globals.scss'
import { AuthProvider } from '../hooks/useAuth'
import { ThemeProvider } from '@material-ui/styles'
import theme from '../hooks/useTheme'
import { RoleSystemProvider } from '../hooks/useRoleSystem'
function MyApp({ Component, pageProps }: AppProps) {
  return (

    <AuthProvider>
      <RoleSystemProvider>
        <ThemeProvider theme={theme}>
          <Component {...pageProps} />
        </ThemeProvider>
      </RoleSystemProvider>
    </AuthProvider>

  )
}

export default MyApp
