import { DatoClinico } from "../../../interfaces/DatoClinico"

type ClinicDataProps = {
    dato_clinico: DatoClinico
}

const ClinicData = ({ dato_clinico }: ClinicDataProps) => {
    return (
        <>
            <label><b>Fecha: </b>{dato_clinico.fecha_alta}</label>
            <div className="d-flex w-75 justify-content-between">

                <div className="d-flex flex-column">
                    <label><b>Presion alta: </b>{dato_clinico.presion_alta}</label>
                    <label><b>Pulso: </b>{dato_clinico.pulso}</label>
                    <label><b>Circunferencia de la cintura: </b>{dato_clinico.circunferencia_cintura}</label>
                    <label><b>Fuma: </b>{dato_clinico.fuma_tabaco !== 0 ? <>Si</> : <>No</>}</label>
                    <label><b>Consume marihuana: </b>{dato_clinico.consume_marihuana !== 0 ? <>Si</> : <>No</>}</label>
                </div>
                <div className="d-flex flex-column">
                    <label><b>Presion baja: </b>{dato_clinico.presion_baja}</label>
                    <label><b>Peso: </b>{dato_clinico.peso}</label>
                    <label><b>Talla: </b>{dato_clinico.talla !== '' ? dato_clinico.talla : 'Datos no disponibles'}</label>
                    <label><b>Consume alcohol: </b>{dato_clinico.consume_alcohol !== 0 ? <>Si</> : <>No</>}</label>
                    <label><b>Otras drogas: </b>{dato_clinico.otras_drogas !== 0 ? <>Si</> : <>No</>}</label>
                </div>
            </div>
        </>

    )
}

export default ClinicData