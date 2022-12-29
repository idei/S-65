<?php
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST');
    header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');
    
    require 'db.php';
    
    $data = json_decode(file_get_contents("php://input"), true);
    
    $dni = $data["dni"];

    try {
       // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

     $select_id_users = $db->prepare("SELECT pacientes.id id
     FROM pacientes 
     WHERE dni = '".$dni."'");

     $select_id_users->execute();
     $id_users= $select_id_users->fetch();
     $id_users= $id_users["id"];
     

    $select_data_clinica = $db->prepare("SELECT presion_alta,presion_baja ,pulso, peso, circunferencia_cintura, consume_alcohol,
    consume_marihuana, otras_drogas, fuma_tabaco 
    FROM datos_clinicos 
    WHERE rela_paciente = '".$id_users."' AND estado_clinico = 1");

    $select_data_clinica->execute();

    if ($select_data_clinica->rowCount()>0) {
        $select_data_clinica= $select_data_clinica->fetch();

    $presion_alta= $select_data_clinica["presion_alta"];
    $presion_baja= $select_data_clinica["presion_baja"];
    $pulso= $select_data_clinica["pulso"];
    $peso= $select_data_clinica["peso"];
    $circunferencia_cintura= $select_data_clinica["circunferencia_cintura"];
    switch ($select_data_clinica["consume_alcohol"]) {
        case 902:
            $consume_alcohol= "A veces (una vez al mes)";
            break;
        case 903:
            $consume_alcohol= "Con frecuencia (una vez por semana)";
            break;
        case 904:
            $consume_alcohol= "Siempre (casi todos los días)";
            break;
    }
    $consume_marihuana= $select_data_clinica["consume_marihuana"];
    $otras_drogas= $select_data_clinica["otras_drogas"];
    $fuma_tabaco= $select_data_clinica["fuma_tabaco"];

   
    $lista = array(
        "request" => "Success",
        "presion_alta" => $presion_alta,
        "presion_baja" => $presion_baja,
        "pulso" => $pulso,
        "peso" => $peso,
        "circunferencia_cintura" => $circunferencia_cintura,
        "consume_alcohol" => $consume_alcohol,
        "consume_marihuana" => $consume_marihuana,
        "otras_drogas" => $otras_drogas,
        "fuma_tabaco" => $fuma_tabaco
    );
    echo json_encode($lista);
    }else {
        $lista = array(
            "request" => "Success",
            "presion_alta" => "",
            "presion_baja" => "",
            "pulso" => "",
            "peso" => "",
            "circunferencia_cintura" => "",
            "consume_alcohol" => "",
            "consume_marihuana" => "",
            "otras_drogas" => "",
            "fuma_tabaco" => "",
            "estado_clinico" => ""
        );
        echo json_encode($lista);
        
    }
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        $lista = array(
            "request" => $error
        );
        echo json_encode($lista);
    }

?>