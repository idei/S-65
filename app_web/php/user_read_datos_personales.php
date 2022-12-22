<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data)) {
	$dni = $data["dni"];
}

    try {
        $select_data = $db->prepare("SELECT rela_users, rela_nivel_instruccion,
    rela_grupo_conviviente, rela_departamento, rela_genero, nombre, apellido, dni, 
    fecha_nacimiento, celular, contacto 
    FROM pacientes 
    WHERE dni = '".$dni."'");

    $select_data->execute();
    $select_data= $select_data->fetch();

    $rela_users= $select_data["rela_users"];
    $rela_nivel_instruccion= $select_data["rela_nivel_instruccion"];
    $rela_grupo_conviviente= $select_data["rela_grupo_conviviente"];
    $rela_departamento= $select_data["rela_departamento"];
    $rela_genero= $select_data["rela_genero"];
    $nombre= $select_data["nombre"];
    $apellido= $select_data["apellido"];
    $dni= $select_data["dni"];
    $fecha_nacimiento= $select_data["fecha_nacimiento"];
    $celular= $select_data["celular"];
    $contacto= $select_data["contacto"];

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
    switch ($select_data_clinica["consume_marihuana"]) {
        case 902:
            $consume_marihuana= "A veces (una vez al mes)";
            break;
        case 903:
            $consume_marihuana= "Con frecuencia (una vez por semana)";
            break;
        case 904:
            $consume_marihuana= "Siempre (casi todos los días)";
            break;
    }
    switch ($select_data_clinica["otras_drogas"]) {
        case 902:
            $otras_drogas= "A veces (una vez al mes)";
            break;
        case 903:
            $otras_drogas= "Con frecuencia (una vez por semana)";
            break;
        case 904:
            $otras_drogas= "Siempre (casi todos los días)";
            break;
    }
    switch ($select_data_clinica["fuma_tabaco"]) {
        case 902:
            $fuma_tabaco= "A veces (una vez al mes)";
            break;
        case 903:
            $fuma_tabaco= "Con frecuencia (una vez por semana)";
            break;
        case 904:
            $fuma_tabaco= "Siempre (casi todos los días)";
            break;
    }

    $lista = array(
        "request" => "Success",
        "rela_users" => $rela_users,
        "rela_nivel_instruccion" => $rela_nivel_instruccion,
        "rela_grupo_conviviente" => $rela_grupo_conviviente,
        "rela_departamento" => $rela_departamento,
        "rela_genero" => $rela_genero,
        "nombre" => $nombre,
        "apellido" => $apellido,
        "dni" => $dni,
        "fecha_nacimiento" => $fecha_nacimiento,
        "celular" => $celular,
        "contacto" => $contacto,
         "presion_alta" => $presion_alta,
         "presion_baja" => $presion_baja,
         "pulso" => $pulso,
         "peso" => $peso,
         "circunferencia_cintura" => $circunferencia_cintura,
         "consume_alcohol" => $consume_alcohol,
         "consume_marihuana" => $consume_marihuana,
         "otras_drogas" => $otras_drogas,
         "fuma_tabaco" => $fuma_tabaco
        //"email" => $email,
    );
    echo json_encode($lista);
}
else {
    $lista = array(
        "request" => "Success",
        "rela_users" => $rela_users,
        "rela_nivel_instruccion" => $rela_nivel_instruccion,
        "rela_grupo_conviviente" => $rela_grupo_conviviente,
        "rela_departamento" => $rela_departamento,
        "rela_genero" => $rela_genero,
        "nombre" => $nombre,
        "apellido" => $apellido,
        "dni" => $dni,
        "fecha_nacimiento" => $fecha_nacimiento,
        "celular" => $celular,
        "contacto" => $contacto,
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
    
    } catch (PDOException $error) {
        echo json_encode("Error: "+ $error);
    }
?>