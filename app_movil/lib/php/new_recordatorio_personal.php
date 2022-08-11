<?php
    require "db.php";
	$email = $_POST['email'];
	$titulo = $_POST['titulo'];
    $fecha_limite = $_POST['fecha_limite'];
	$estado_recordatorio = 0;

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_users = $db->prepare("SELECT id FROM `users` WHERE users.email = '".$email."'");
    $select_id_users->execute();
    $id_users= $select_id_users->fetch();
    $id_users= $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = $db->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '".$id_users."'");
    $select_id_paciente->execute();

	$lista = array();

    $result_paciente = $select_id_paciente->rowCount();

	if ($result_paciente == 0) {
        array_push($lista, "Error al guardar recoradtorio", $estado_users);
		echo json_encode($lista);
	}else{
		
    $id_paciente= $select_id_paciente->fetch();
    $id_paciente= $id_paciente["id"]; 
	
    $stmt = $db->prepare('INSERT INTO recordatorios_pacientes(descripcion,fecha_limite,rela_paciente,rela_estado_recordatorio) VALUES(?, ?, ?, ?)');
    $stmt->bindParam(1,$titulo);
    $stmt->bindParam(2,$fecha_limite);
    $stmt->bindParam(3,$id_paciente);
    $stmt->bindParam(4,$estado_recordatorio);

	$stmt->execute();

    $insert_recordatorio = $stmt->rowCount();
	
    if ($insert_recordatorio) {
		echo json_encode("Success");
	}

	}

?>
