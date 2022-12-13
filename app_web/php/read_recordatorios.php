<?php 

    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST');
    header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');
    
    require 'db.php';
    
    $data = json_decode(file_get_contents("php://input"), true);
    
    $email = $data["email"];

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

    try {
    $num = 1;
    $stmt = $db->prepare("SELECT id,descripcion,fecha_limite,rela_estado_recordatorio,rela_paciente FROM recordatorios_pacientes
    WHERE rela_estado_recordatorio <> 2 AND rela_paciente = '".$id_paciente."'
        UNION ALL
        SELECT id,descripcion,fecha_limite,rela_estado_recordatorio,rela_paciente FROM recordatorios_medicos
        WHERE rela_estado_recordatorio <> 2 AND rela_paciente = '".$id_paciente."' ORDER BY fecha_limite ASC");

	$stmt->execute();
    $result = $stmt->fetchAll();
    $lista = array();
	if ($stmt->rowCount() > 0) {
        foreach ($result as $results) {
            $lista[] = $results;
        }
        $response = array(
            "request"=>"Success",
            "recordatorios"=>$lista
        );
        echo json_encode($response);
	}else {
        $response = array(
            "request"=>"Vacio"
        );
        echo json_encode($response);
    }
    
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
?>