import Head from "next/head"
import Layout from "../../components/ui/Layout/Layout"
import Navbar from "../../components/ui/Navbar/Navbar"

const Home = () => {
    return (
        <>
            <Head>
                <title>Sistema de salud</title>
            </Head>
            <Layout>
                <Navbar />
                <div className="px-5">
                    <h1>Chequeos</h1>
                </div>
            </Layout>
        </>)
}

export default Home