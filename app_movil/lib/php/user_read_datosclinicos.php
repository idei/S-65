<?php
    require "db.php";

    $email = $_POST['email'];

    try {
       // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

     $select_id_users = $db->prepare("SELECT id FROM `users` WHERE users.email = '".$email."'");
     $select_id_users->execute();
     $id_users= $select_id_users->fetch();
     $id_users= $id_users["id"];

    $select_data_clinica = $db->prepare("SELECT presion_alta,presion_baja ,pulso, peso, circunferencia_cintura, consume_alcohol,
    consume_marihuana, otras_drogas, fuma_tabaco 
    FROM datos_clinicos 
    WHERE rela_users = '".$id_users."' AND estado_clinico = 1");

    $select_data_clinica->execute();

    if ($select_data_clinica->rowCount()>0) {
        $select_data_clinica= $select_data_clinica->fetch();

    $presion_alta= $select_data_clinica["presion_alta"];
    $presion_baja= $select_data_clinica["presion_baja"];
    $pulso= $select_data_clinica["pulso"];
    $peso= $select_data_clinica["peso"];
    $circunferencia_cintura= $select_data_clinica["circunferencia_cintura"];
    $consume_alcohol= $select_data_clinica["consume_alcohol"];
    $consume_marihuana= $select_data_clinica["consume_marihuana"];
    $otras_drogas= $select_data_clinica["otras_drogas"];
    $fuma_tabaco= $select_data_clinica["fuma_tabaco"];

   
    $lista = array(
        "estado_users" => "Success",
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
            "estado_users" => "Success",
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
            "estado_users" => $error
        );
        echo json_encode($lista);
    }

?>