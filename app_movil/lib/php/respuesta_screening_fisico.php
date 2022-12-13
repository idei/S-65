<?php
require "db.php";

$id_paciente = $_POST['id_paciente'];
$id_medico = $_POST['id_medico'];


$tipo_screening = $_POST['tipo_screening'];
$recordatorio_medico = $_POST['id_recordatorio'];
$estado = 1;

$result_screening = $_POST['cantidad'];

if ($id_medico == "null") {
    $id_medico = null;
}

if ($recordatorio_medico == "null") {
    $recordatorio_medico = null;
}


// Guardamos el resultado del screening

$insert_resultado = $db->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
$last = $db->prepare('SELECT LAST_INSERT_ID() as id');

$insert_resultado->bindParam(1, $tipo_screening);
$insert_resultado->bindParam(2, $id_paciente);
$insert_resultado->bindParam(3, $id_medico);
$insert_resultado->bindParam(4, $result_screening);

$insert_resultado->execute();
$last->execute();

$id_respuesta = $insert_resultado->fetch();
$last = $last->fetch();
$id_respuesta = $last["id"];

//--------------------------------------------------

if ($_POST['dolor_cabeza'] == "true") {
    $dolor_cabeza = 1;
} else {
    $dolor_cabeza = 0;
}

if ($_POST['mareos'] == "true") {
    $mareos = 1;
} else {
    $mareos = 0;
}

if ($_POST['nauceas'] == "true") {
    $nauceas = 1;
} else {
    $nauceas = 0;
}

if ($_POST['vomito'] == "true") {
    $vomito = 1;
} else {
    $vomito = 0;
}

if ($_POST['fatiga_excesiva'] == "true") {
    $fatiga_excesiva = 1;
} else {
    $fatiga_excesiva = 0;
}


if ($_POST['urinaria'] == "true") {
    $urinaria = 1;
} else {
    $urinaria = 0;
}

if ($_POST['problemas_instestinales'] == "true") {
    $problemas_instestinales = 1;
} else {
    $problemas_instestinales = 0;
}

if ($_POST['debilidad_lado_cuerpo'] == "true") {
    $debilidad_lado_cuerpo = 1;
} else {
    $debilidad_lado_cuerpo = 0;
}

if ($_POST['problemas_motricidad'] == "true") {
    $problemas_motricidad = 1;
} else {
    $problemas_motricidad = 0;
}

if ($_POST['temblores'] == "true") {
    $temblores = 1;
} else {
    $temblores = 0;
}

if ($_POST['inestabilidad_marcha'] == "true") {
    $inestabilidad_marcha = 1;
} else {
    $inestabilidad_marcha = 0;
}


if ($_POST['tics_mov_extranos'] == "true") {
    $tics_mov_extranos = 1;
} else {
    $tics_mov_extranos = 0;
}

if ($_POST['problemas_equilibrio'] == "true") {
    $problemas_equilibrio = 1;
} else {
    $problemas_equilibrio = 0;
}

if ($_POST['choque_cosas'] == "true") {
    $choque_cosas = 1;
} else {
    $choque_cosas = 0;
}

if ($_POST['desmayo'] == "true") {
    $desmayo = 1;
} else {
    $desmayo = 0;
}

if ($_POST['caidas'] == "true") {
    $caidas = 1;
} else {
    $caidas = 0;
}

if ($_POST['perdida_sensibilidad'] == "true") {
    $perdida_sensibilidad = 1;
} else {
    $perdida_sensibilidad = 0;
}

if ($_POST['cosquilleo_piel'] == "true") {
    $cosquilleo_piel = 1;
} else {
    $cosquilleo_piel = 0;
}

if ($_POST['ojos_claridad'] == "true") {
    $ojos_claridad = 1;
} else {
    $ojos_claridad = 0;
}

if ($_POST['perdida_audicion'] == "true") {
    $perdida_audicion = 1;
} else {
    $perdida_audicion = 0;
}



if ($_POST['utiliza_audifonos'] == "true") {
    $utiliza_audifonos = 1;
} else {
    $utiliza_audifonos = 0;
}

if ($_POST['zumbido'] == "true") {
    $zumbido = 1;
} else {
    $zumbido = 0;
}

if ($_POST['anteojo_cerca'] == "true") {
    $anteojo_cerca = 1;
} else {
    $anteojo_cerca = 0;
}

if ($_POST['anteojo_lejos'] == "true") {
    $anteojo_lejos = 1;
} else {
    $anteojo_lejos = 0;
}

if ($_POST['vision_lado'] == "true") {
    $vision_lado = 1;
} else {
    $vision_lado = 0;
}

if ($_POST['vision_borrosa'] == "true") {
    $vision_borrosa = 1;
} else {
    $vision_borrosa = 0;
}

if ($_POST['vision_doble'] == "true") {
    $vision_doble = 1;
} else {
    $vision_doble = 0;
}

if ($_POST['cosas_no_existen'] == "true") {
    $cosas_no_existen = 1;
} else {
    $cosas_no_existen = 0;
}

if ($_POST['sensibilidad_cosas_brillantes'] == "true") {
    $sensibilidad_cosas_brillantes = 1;
} else {
    $sensibilidad_cosas_brillantes = 0;
}

if ($_POST['periodos_ceguera'] == "true") {
    $periodos_ceguera = 1;
} else {
    $periodos_ceguera = 0;
}

if ($_POST['persibe_cosas_cuerpo'] == "true") {
    $persibe_cosas_cuerpo = 1;
} else {
    $persibe_cosas_cuerpo = 0;
}

if ($_POST['dificultad_calor_frio'] == "true") {
    $dificultad_calor_frio = 1;
} else {
    $dificultad_calor_frio = 0;
}

if ($_POST['problemas_gusto'] == "true") {
    $problemas_gusto = 1;
} else {
    $problemas_gusto = 0;
}

if ($_POST['problemas_olfato'] == "true") {
    $problemas_olfato = 1;
} else {
    $problemas_olfato = 0;
}

if ($_POST['dolor'] == "true") {
    $dolor = 1;
} else {
    $dolor = 0;
}


$cod_event_dolor_cabeza = $_POST['cod_event_dolor_cabeza'];
$cod_event_mareos = $_POST['cod_event_mareos'];
$cod_event_nauceas = $_POST['cod_event_nauceas'];
$cod_event_vomito = $_POST['cod_event_vomito'];
$cod_event_fatiga_excesiva = $_POST['cod_event_fatiga_excesiva'];
$cod_event_urinaria = $_POST['cod_event_urinaria'];
$cod_event_problemas_instestinales = $_POST['cod_event_problemas_instestinales'];
$cod_event_debilidad_lado_cuerpo = $_POST['cod_event_debilidad_lado_cuerpo'];
$cod_event_problemas_motricidad = $_POST['cod_event_problemas_motricidad'];
$cod_event_temblores = $_POST['cod_event_temblores'];
$cod_event_inestabilidad_marcha = $_POST['cod_event_inestabilidad_marcha'];
$cod_event_tics_mov_extranos = $_POST['cod_event_tics_mov_extranos'];
$cod_event_problemas_equilibrio = $_POST['cod_event_problemas_equilibrio'];
$cod_event_choque_cosas = $_POST['cod_event_choque_cosas'];
$cod_event_desmayo = $_POST['cod_event_desmayo'];
$cod_event_caidas = $_POST['cod_event_caidas'];
$cod_event_perdida_sensibilidad = $_POST['cod_event_perdida_sensibilidad'];
$cod_event_cosquilleo_piel = $_POST['cod_event_cosquilleo_piel'];
$cod_event_ojos_claridad = $_POST['cod_event_ojos_claridad'];
$cod_event_perdida_audicion = $_POST['cod_event_perdida_audicion'];
$cod_event_utiliza_audifonos = $_POST['cod_event_utiliza_audifonos'];
$cod_event_zumbido = $_POST['cod_event_zumbido'];
$cod_event_anteojo_cerca = $_POST['cod_event_anteojo_cerca'];
$cod_event_anteojo_lejos = $_POST['cod_event_anteojo_lejos'];
$cod_event_vision_lado = $_POST['cod_event_vision_lado'];
$cod_event_vision_borrosa = $_POST['cod_event_vision_borrosa'];
$cod_event_vision_doble = $_POST['cod_event_vision_doble'];
$cod_event_cosas_no_existen = $_POST['cod_event_cosas_no_existen'];
$cod_event_sensibilidad_cosas_brillantes = $_POST['cod_event_sensibilidad_cosas_brillantes'];
$cod_event_periodos_ceguera = $_POST['cod_event_periodos_ceguera'];
$cod_event_persibe_cosas_cuerpo = $_POST['cod_event_persibe_cosas_cuerpo'];
$cod_event_dificultad_calor_frio = $_POST['cod_event_dificultad_calor_frio'];
$cod_event_problemas_gusto = $_POST['cod_event_problemas_gusto'];
$cod_event_problemas_olfato = $_POST['cod_event_problemas_olfato'];
$cod_event_dolor = $_POST['cod_event_dolor'];


try {

    $fecha = date('Y/m/d');

    // SELECCION DE EVENTOS
    $select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
                IN ('DOLCA','MAREO','NAUS','VOM','FATEX','INCUR','PROMI','DEBCU','PROMF','TEMBL','INMAR',
                'TICS','PEQUI','FRECC','DESMA','CAIDA','PESEN','COSQP','NECCL','PERAU','UTAUD','ZUMB','UTICE',
                'UTILE','VISLA','VISBO','VISDO','COSEX','LUCBR','PERCO','PERCU','DIFFR','PROGU','PROOL','DOLOR')");

    $select_evento->execute();
    $evento = $select_evento->fetchAll();


    foreach ($evento as $eventos) {

        if ($eventos["codigo_evento"] == $cod_event_dolor_cabeza) {

            $rowsToInsert[] = array(
                'rela_tipo' => $dolor_cabeza,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,



            );
        }

        if ($eventos["codigo_evento"] == $cod_event_mareos) {
            $rowsToInsert[] = array(
                'rela_tipo' => $mareos,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nauceas) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nauceas,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_vomito) {
            $rowsToInsert[] = array(
                'rela_tipo' => $vomito,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_fatiga_excesiva) {
            $rowsToInsert[] = array(
                'rela_tipo' => $fatiga_excesiva,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_urinaria) {
            $rowsToInsert[] = array(
                'rela_tipo' => $urinaria,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_problemas_instestinales) {
            $rowsToInsert[] = array(
                'rela_tipo' => $problemas_instestinales,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_debilidad_lado_cuerpo) {
            $rowsToInsert[] = array(
                'rela_tipo' => $debilidad_lado_cuerpo,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_problemas_motricidad) {
            $rowsToInsert[] = array(
                'rela_tipo' => $problemas_motricidad,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_temblores) {
            $rowsToInsert[] = array(
                'rela_tipo' => $temblores,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_inestabilidad_marcha) {
            $rowsToInsert[] = array(
                'rela_tipo' => $inestabilidad_marcha,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_tics_mov_extranos) {
            $rowsToInsert[] = array(
                'rela_tipo' => $tics_mov_extranos,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_problemas_equilibrio) {
            $rowsToInsert[] = array(
                'rela_tipo' => $cod_event_problemas_equilibrio,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }


        if ($eventos["codigo_evento"] == $cod_event_choque_cosas) {
            $rowsToInsert[] = array(
                'rela_tipo' => $choque_cosas,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_desmayo) {
            $rowsToInsert[] = array(
                'rela_tipo' => $desmayo,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_perdida_sensibilidad) {
            $rowsToInsert[] = array(
                'rela_tipo' => $perdida_sensibilidad,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_cosquilleo_piel) {
            $rowsToInsert[] = array(
                'rela_tipo' => $cosquilleo_piel,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_ojos_claridad) {
            $rowsToInsert[] = array(
                'rela_tipo' => $ojos_claridad,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_perdida_audicion) {
            $rowsToInsert[] = array(
                'rela_tipo' => $perdida_audicion,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_utiliza_audifonos) {
            $rowsToInsert[] = array(
                'rela_tipo' => $utiliza_audifonos,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_zumbido) {
            $rowsToInsert[] = array(
                'rela_tipo' => $zumbido,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_anteojo_cerca) {
            $rowsToInsert[] = array(
                'rela_tipo' => $anteojo_cerca,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_anteojo_lejos) {
            $rowsToInsert[] = array(
                'rela_tipo' => $anteojo_lejos,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_vision_lado) {
            $rowsToInsert[] = array(
                'rela_tipo' => $vision_lado,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_vision_borrosa) {
            $rowsToInsert[] = array(
                'rela_tipo' => $vision_borrosa,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_vision_doble) {
            $rowsToInsert[] = array(
                'rela_tipo' => $vision_doble,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_cosas_no_existen) {
            $rowsToInsert[] = array(
                'rela_tipo' => $cosas_no_existen,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_sensibilidad_cosas_brillantes) {
            $rowsToInsert[] = array(
                'rela_tipo' => $sensibilidad_cosas_brillantes,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
        if ($eventos["codigo_evento"] == $cod_event_periodos_ceguera) {
            $rowsToInsert[] = array(
                'rela_tipo' => $periodos_ceguera,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
        if ($eventos["codigo_evento"] == $cod_event_persibe_cosas_cuerpo) {
            $rowsToInsert[] = array(
                'rela_tipo' => $persibe_cosas_cuerpo,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
        if ($eventos["codigo_evento"] == $cod_event_dificultad_calor_frio) {
            $rowsToInsert[] = array(
                'rela_tipo' => $dificultad_calor_frio,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
        if ($eventos["codigo_evento"] == $cod_event_problemas_gusto) {
            $rowsToInsert[] = array(
                'rela_tipo' => $problemas_gusto,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
        if ($eventos["codigo_evento"] == $cod_event_problemas_olfato) {
            $rowsToInsert[] = array(
                'rela_tipo' => $problemas_olfato,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
        if ($eventos["codigo_evento"] == $cod_event_dolor) {
            $rowsToInsert[] = array(
                'rela_tipo' => $dolor,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
    }

    //Call our custom function.
    pdoMultiInsert('respuesta_screening', $rowsToInsert, $db);

    $rela_estado_recordatorio = 2;
    $update_estado_recordatorio = $db->prepare("UPDATE recordatorios_medicos
                SET rela_estado_recordatorio=:rela_estado_recordatorio
                WHERE id=:recordatorio_medico");

    $update_estado_recordatorio->execute([$rela_estado_recordatorio, $recordatorio_medico]);

    echo json_encode("Success");
} catch (PDOException $e) {
    echo json_encode('Error conectando con la base de datos: ' . $e->getMessage());
}


function pdoMultiInsert($tableName, $data, $pdoObject)
{

    //Will contain SQL snippets.
    $rowsSQL = array();

    //Will contain the values that we need to bind.
    $toBind = array();

    //Get a list of column names to use in the SQL statement.
    $columnNames = array_keys($data[0]);

    //Loop through our $data array.
    foreach ($data as $arrayIndex => $row) {
        $params = array();
        foreach ($row as $columnName => $columnValue) {
            $param = ":" . $columnName . $arrayIndex;
            $params[] = $param;
            $toBind[$param] = $columnValue;
        }
        $rowsSQL[] = "(" . implode(", ", $params) . ")";
    }

    //Construct our SQL statement
    $sql = "INSERT INTO `$tableName` (" . implode(", ", $columnNames) . ") VALUES " . implode(", ", $rowsSQL);

    //Prepare our PDO statement.
    $pdoStatement = $pdoObject->prepare($sql);

    //Bind our values.
    foreach ($toBind as $param => $val) {
        $pdoStatement->bindValue($param, $val);
    }

    //Execute our statement (i.e. insert the data).
    return $pdoStatement->execute();
}
