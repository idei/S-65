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
$lista1 = array();

//var_dump($select_antecedentes->rowCount());
if ($select_antecedentes->rowCount() > 0) {
    $stack = array("request" => "Success");
    $lista1 = array_merge($lista1, $stack);
    $antecedente = $select_antecedentes->fetchAll();

    foreach ($antecedente as $antecedentes) {

        foreach ($evento as $eventos) {

            if ($antecedentes["rela_evento"] == $eventos["id"]) {
            
                if ($eventos["codigo_evento"] == $cod_event_retraso) {
                    if($antecedentes["rela_tipo"]=="1"){
                    $retraso = "Retraso Mental";
                    $stack = array("retraso" => $retraso);
                    $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_desorden) {
                    if($antecedentes["rela_tipo"]=="1")
                   {     $desorden = "Desorden del habla";
                    $stack = array("desorden" => $desorden);
                     $lista1 = array_merge($lista1, $stack);                }
                }

                if ($eventos["codigo_evento"] == $cod_event_deficit) {
                    if($antecedentes["rela_tipo"]=="1")
                    {
                        $deficit = "Déficit de atención";
                        $stack = array("deficit" => $deficit);
                        $lista1 =  $lista1 = array_merge($lista1, $stack);
                    }
                    
                }

                if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                    if($antecedentes["rela_tipo"]=="1")
                    {$lesiones_cabeza = "Lesiones en la cabeza";
                        $stack = array("lesiones_cabeza" => $lesiones_cabeza);
                        $lista1 =  $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                    if($antecedentes["rela_tipo"]=="1")
                    {$perdidas = "Pérdidas de conocimiento";
                        $stack = array("perdidas" => $perdidas);
                         $lista1 = array_merge($lista1, $stack);
                    }   
                }

                if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                    if($antecedentes["rela_tipo"]=="1")
                   { $accidentes_caidas = "Accidentes, caídas, golpes"; 
                    $stack = array("accidentes_caidas" => $accidentes_caidas);
                     $lista1 = array_merge($lista1, $stack);
                }
                }

                if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                    if($antecedentes["rela_tipo"]=="1")
                    {
                    $lesiones_espalda = "Lesiones en la espalda o cuello";
                    $stack = array("lesiones_espalda" => $lesiones_espalda);
                      $lista1 = array_merge($lista1, $stack);}
                }

                if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                    if($antecedentes["rela_tipo"]=="1")
                   { $infecciones = "Infecciones (meningitis, encefalitis) /privación de oxígeno";
                    $stack = array("infecciones" => $infecciones);
                      $lista1 = array_merge($lista1, $stack);   
                }
                }

                if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $toxinas = "Exposición a toxinas (plomo, solventes, químicos, etc.)";
                        $stack = array("toxinas" => $toxinas);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_acv) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $acv = "Accidente Cerebrovascular (ACV)";
                        $stack = array("acv" => $acv);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_demencia) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $demencia = "Demencias (ejemplo Alzheimer)";
                        $stack = array("demencia" => $demencia);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $parkinson = "Parkinson";
                        $stack = array("parkinson" => $parkinson);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $epilepsia = "Epilepsia";
                        $stack = array("epilepsia" => $epilepsia);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $esclerosis = "Esclerosis Múltiple";
                        $stack = array("esclerosis" => $esclerosis);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_huntington) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $huntington = "Huntington";
                        $stack = array("huntington" => $huntington);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_depresion) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $depresion = "Depresion";
                        $stack = array("depresion" => $depresion);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $trastorno = "Trastorno bipolar";
                        $stack = array("trastorno" => $trastorno);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $esquizofrenia = "Esquizofrenia";
                        $stack = array("esquizofrenia" => $esquizofrenia);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $enfermedad_desorden = "Enfermedad o desorden grave (inmunológico, parálisis cerebral, polio, pulmones, etc.)";
                        $stack = array("enfermedad_desorden" => $enfermedad_desorden);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }

                if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                    if($antecedentes["rela_tipo"]=="1"){
                        $intoxicaciones = "Intoxicaciones";
                        $stack = array("intoxicaciones" => $intoxicaciones);
                          $lista1 = array_merge($lista1, $stack);
                    }
                }
            }
        }
    }
} else {
    $lista1 = array(
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

echo json_encode($lista1);
    //
