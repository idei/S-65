import { ServerStyleSheets } from '@material-ui/core/styles';
import Document, { Html, Head, Main, NextScript } from 'next/document'
import React from 'react'
export default class MyDocument extends Document{
    render() {
        return (
          <Html lang="en">
            <Head>
              {/* Not exactly required, but this is the PWA primary color */}
              {/* <meta name="theme-color" content={theme.palette.primary.main} /> */}
            </Head>
            <body>
              <Main />
              <NextScript />
            </body>
          </Html>
        );
      }
}

/*MyDocument.getInitialProps =  async (ctx) => {
    const sheets = new ServerStyleSheets();
    const originalRenderPage = ctx.renderPage;

    ctx.renderPage = () => {
        return originalRenderPage({
            enhanceApp: (App) => (props) => sheets.collect(<App {...props} />)
        })
    }

    const initialProps = await Document.getInitialProps(ctx)

    return {
        ...initialProps,
        styles: [...React.Children.toArray(initialProps.styles),sheets.getStyleElement]
    }
}*/