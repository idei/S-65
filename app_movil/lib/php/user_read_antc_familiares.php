<?php
    require "db.php";

    $email = $_POST['email'];
    
    $retraso ;
    $desorden ;
    $deficit ;
    $lesiones_cabeza;
    $perdidas ;
    $accidentes_caidas ;
    $lesiones_espalda ;
    $infecciones;
    $toxinas;
    $acv;
    $demencia;
    $parkinson;
    $epilepsia;
    $esclerosis;
    $huntington;
    $depresion;
    $trastorno;
    $esquizofrenia;
    $enfermedad_desorden;
    $intoxicaciones;
    $cancer;
    $cirujia;
    $trasplante;
    $hipotiroidismo;
    $cardiologico;
    $diabetes;
    $hipertension;
    $colesterol;
    

    $cod_event_retraso = $_POST['cod_event_retraso'];
    $cod_event_desorden = $_POST['cod_event_desorden'];
    $cod_event_deficit = $_POST['cod_event_deficit'];
    $cod_event_lesiones_cabeza = $_POST['cod_event_lesiones_cabeza'];
    $cod_event_perdidas = $_POST['cod_event_perdidas'];
    $cod_event_accidentes_caidas = $_POST['cod_event_accidentes_caidas'];
    $cod_event_lesiones_espalda = $_POST['cod_event_lesiones_espalda'];
    $cod_event_infecciones = $_POST['cod_event_infecciones'];
    $cod_event_toxinas = $_POST['cod_event_toxinas'];
    $cod_event_acv = $_POST['cod_event_acv'];
    $cod_event_demencia = $_POST['cod_event_demencia'];
    $cod_event_parkinson = $_POST['cod_event_parkinson'];
    $cod_event_epilepsia = $_POST['cod_event_epilepsia'];
    $cod_event_esclerosis = $_POST['cod_event_esclerosis'];
    $cod_event_huntington = $_POST['cod_event_huntington'];
    $cod_event_depresion = $_POST['cod_event_depresion'];
    $cod_event_trastorno = $_POST['cod_event_trastorno'];
    $cod_event_esquizofrenia = $_POST['cod_event_esquizofrenia'];
    $cod_event_enfermedad_desorden = $_POST['cod_event_enfermedad_desorden'];
    $cod_event_intoxicaciones = $_POST['cod_event_intoxicaciones'];

    $cod_event_cancer = $_POST['cod_event_cancer'];
    $cod_event_cirujia = $_POST['cod_event_cirujia'];
    $cod_event_trasplante = $_POST['cod_event_trasplante'];
    $cod_event_hipotiroidismo = $_POST['cod_event_hipotiroidismo'];
    $cod_event_cardiologico = $_POST['cod_event_cardiologico'];
    $cod_event_diabetes = $_POST['cod_event_diabetes'];
    $cod_event_hipertension = $_POST['cod_event_hipertension'];
    $cod_event_colesterol = $_POST['cod_event_colesterol'];
    

    try {
        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_users = $db->prepare("SELECT id FROM `users` WHERE users.email = '".$email."'");
    $select_id_users->execute();
    $id_users= $select_id_users->fetch();
    $id_users= $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = $db->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '".$id_users."'");
    $select_id_paciente->execute();
    $id_paciente= $select_id_paciente->fetch();
    $id_paciente= $id_paciente["id"];  


    // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
    $select_antecedentes = $db->prepare("SELECT * FROM antecedentes_medicos_familiares WHERE rela_paciente = '".$id_paciente."'");
    $select_antecedentes->execute();
   
    // SELECCION DE EVENTOS
    $select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
    $select_evento->execute();
    $evento= $select_evento->fetchAll();

    //var_dump($antecedente);
    if ($select_antecedentes->rowCount() > 0) {
        $antecedente= $select_antecedentes->fetchAll();

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
    
                        if ($eventos["codigo_evento"] == $cod_event_cancer) {
                            $cancer = $antecedentes["rela_tipo"];
                        }
    
                        if ($eventos["codigo_evento"] == $cod_event_cirujia) {
                            $cirujia = $antecedentes["rela_tipo"];
                        }
    
                        if ($eventos["codigo_evento"] == $cod_event_trasplante) {
                            $trasplante = $antecedentes["rela_tipo"];
                        }
    
                        if ($eventos["codigo_evento"] == $cod_event_hipotiroidismo) {
                            $hipotiroidismo = $antecedentes["rela_tipo"];
                        }
    
                        if ($eventos["codigo_evento"] == $cod_event_cardiologico) {
                            $cardiologico = $antecedentes["rela_tipo"];
                        }
    
                        if ($eventos["codigo_evento"] == $cod_event_diabetes) {
                            $diabetes = $antecedentes["rela_tipo"];
                        }
    
                        if ($eventos["codigo_evento"] == $cod_event_hipertension) {
                            $hipertension = $antecedentes["rela_tipo"];
                        }
    
                        if ($eventos["codigo_evento"] == $cod_event_colesterol) {
                            $colesterol = $antecedentes["rela_tipo"];
                        }
                        
                        }
    
            }
    }

    $lista = array(
        "estado" => "Success",
        "retraso" => $retraso,
        "desorden" => $desorden,
        "deficit" => $deficit,
        "lesiones_cabeza"=> $lesiones_cabeza,
        "perdidas" => $perdidas,
        "accidentes_caidas" => $accidentes_caidas,
        "lesiones_espalda" => $lesiones_espalda,
        "infecciones"=> $infecciones,
        "toxinas"=> $toxinas,
        "acv"=> $acv,
        "demencia"=> $demencia,
        "parkinson"=> $parkinson,
        "epilepsia"=> $epilepsia,
        "esclerosis"=> $esclerosis,
        "huntington"=> $huntington,
        "depresion"=> $depresion,
        "trastorno"=> $trastorno,
        "esquizofrenia"=> $esquizofrenia,
        "enfermedad_desorden"=> $enfermedad_desorden,
        "intoxicaciones"=> $intoxicaciones,
        "cancer" => $cancer,
        "cirujia" => $cirujia,
        "trasplante" => $trasplante,
        "hipotiroidismo" => $hipotiroidismo,
        "cardiologico" => $cardiologico,
        "diabetes" => $diabetes,
        "hipertension" => $hipertension,
        "colesterol" => $colesterol,
        );
    
}
else{

    $lista = array(
        "estado" => "Error",
        );

}
    } catch (\Throwable $th) {
        //throw $th;
    }
    

   
    

    echo json_encode($lista);
    //
?>