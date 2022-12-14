<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require "db.php";

$data = json_decode(file_get_contents("php://input"), true);

$dni = $data["dni"];

$retraso = 0;
$desorden = 0;
$deficit = 0;
$lesiones_cabeza = 0;
$perdidas = 0;
$accidentes_caidas = 0;
$lesiones_espalda = 0;
$infecciones = 0;
$toxinas = 0;
$acv = 0;
$demencia = 0;
$parkinson = 0;
$epilepsia = 0;
$esclerosis = 0;
$huntington = 0;
$depresion = 0;
$trastorno = 0;
$esquizofrenia = 0;
$enfermedad_desorden = 0;
$intoxicaciones = 0;


$cod_event_retraso = "RM";
$cod_event_desorden = "DH";
$cod_event_deficit = "DA";
$cod_event_lesiones_cabeza = "LC";
$cod_event_perdidas = "PC";
$cod_event_accidentes_caidas = "ACG";
$cod_event_lesiones_espalda = "LEC";
$cod_event_infecciones = "IPO";
$cod_event_toxinas = "ETOX";
$cod_event_acv = "ACV";
$cod_event_demencia = "DEM";
$cod_event_parkinson = "PARK";
$cod_event_epilepsia = "EPIL";
$cod_event_esclerosis = "EM";
$cod_event_huntington = "HUNG";
$cod_event_depresion = "DEPRE";
$cod_event_trastorno = "TB";
$cod_event_esquizofrenia = "ESQ";
$cod_event_enfermedad_desorden = "EDG";
$cod_event_intoxicaciones = "INTOX";


// SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
$select_id_paciente = $db->prepare("SELECT id FROM `pacientes` WHERE dni = '" . $dni . "'");
$select_id_paciente->execute();
$id_paciente = $select_id_paciente->fetch();
$id_paciente = $id_paciente["id"];


// BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
$select_antecedentes = $db->prepare("SELECT * FROM antecedentes_medicos_personales WHERE rela_paciente = '" . $id_paciente . "'");
$select_antecedentes->execute();


// SELECCION DE EVENTOS
$select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
$select_evento->execute();
$evento = $select_evento->fetchAll();

//var_dump($select_antecedentes->rowCount());
if ($select_antecedentes->rowCount() > 0) {
    $antecedente = $select_antecedentes->fetchAll();

    foreach ($antecedente as $antecedentes) {

        foreach ($evento as $eventos) {

            if ($antecedentes["rela_evento"] == $eventos["id"]) {

                if ($eventos["codigo_evento"] == $cod_event_retraso) {
                    $retraso = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_desorden) {
                    $desorden = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_deficit) {
                    $deficit = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                    $lesiones_cabeza = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                    $perdidas = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                    $accidentes_caidas = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                    $lesiones_espalda = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                    $infecciones = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                    $toxinas = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_acv) {
                    $acv = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_demencia) {
                    $demencia = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                    $parkinson = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                    $epilepsia = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                    $esclerosis = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_huntington) {
                    $huntington = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_depresion) {
                    $depresion = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                    $trastorno = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                    $esquizofrenia = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                    $enfermedad_desorden = $antecedentes["rela_tipo"];
                }

                if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                    $intoxicaciones = $antecedentes["rela_tipo"];
                }
            }
        }
    }

    $lista = array(
        "request" => "Success",
        "retraso" => $retraso,
        "desorden" => $desorden,
        "deficit" => $deficit,
        "lesiones_cabeza" => $lesiones_cabeza,
        "perdidas" => $perdidas,
        "accidentes_caidas" => $accidentes_caidas,
        "lesiones_espalda" => $lesiones_espalda,
        "infecciones" => $infecciones,
        "toxinas" => $toxinas,
        "acv" => $acv,
        "demencia" => $demencia,
        "parkinson" => $parkinson,
        "epilepsia" => $epilepsia,
        "esclerosis" => $esclerosis,
        "huntington" => $huntington,
        "depresion" => $depresion,
        "trastorno" => $trastorno,
        "esquizofrenia" => $esquizofrenia,
        "enfermedad_desorden" => $enfermedad_desorden,
        "intoxicaciones" => $intoxicaciones,
    );
} else {
    $lista = array(
        "request" => "Success",
        "retraso" => 0,
        "desorden" => 0,
        "deficit" => 0,
        "lesiones_cabeza" => 0,
        "perdidas" => 0,
        "accidentes_caidas" => 0,
        "lesiones_espalda" => 0,
        "infecciones" => 0,
        "toxinas" => 0,
        "acv" => 0,
        "demencia" => 0,
        "parkinson" => 0,
        "epilepsia" => 0,
        "esclerosis" => 0,
        "huntington" => 0,
        "depresion" => 0,
        "trastorno" => 0,
        "esquizofrenia" => 0,
        "enfermedad_desorden" => 0,
        "intoxicaciones" => 0,
    );
}

echo json_encode($lista);
    //
