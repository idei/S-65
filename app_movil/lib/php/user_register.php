<?php
    require "db.php";
	$email = $_POST['email'];
	$password = $_POST['password'];
	$nombre = $_POST['nombre'];
	$apellido = $_POST['apellido'];
	$dni = $_POST['dni'];
	$estado_users = '1';
	$rela_rol = 0;

	$token = uniqid(random_int(100, 999),true);


	$lista = array();

	$stmt = $db->prepare("SELECT email FROM users WHERE email = '".$email."'");
	$stmt->execute();
	$result = $stmt->rowCount();

	if ($result == 1) {
		$lista = array("request"=>"Error : Ya existe un paciente con ese email");
		echo json_encode($lista);
	}else{
		
	$stmt = $db->prepare('INSERT INTO users(email,password,token) VALUES(?, ?, ?)');
    $stmt->bindParam(1,$email);
    $stmt->bindParam(2,$password);
	$stmt->bindParam(3,$token);

	$stmt->execute();

	$result = $stmt->rowCount();
		if ($result) {
			$select_email = $db->prepare("SELECT id FROM users WHERE email = '".$email."'");
			$select_email->execute();
			$rela_users= $select_email->fetch();

			$insert_paciente = $db->prepare('INSERT INTO pacientes(rela_users,nombre,apellido,estado_users,dni)VALUES(?,?,?,?,?)');
			
			$insert_paciente->bindParam(1,$rela_users['id']);
			$insert_paciente->bindParam(2,$nombre);
			$insert_paciente->bindParam(3,$apellido);
			$insert_paciente->bindParam(4,$estado_users);
			$insert_paciente->bindParam(5,$dni);
			$insert_paciente->execute();

			
			$insert_paciente = $stmt->rowCount();
			if ($insert_paciente) {
				
				$lista = array(
					"request"=>"Success",
					"token"=>$token,
					"email"=>$email,
					"password"=>$password,
					"paciente"=>[
						
						"rela_users"=>$rela_users,
						"nombre"=>$nombre,
						"apellido"=>$apellido,
						"dni"=>$dni,
						"estado_users"=>$estado_users
						]
				);
				
				echo json_encode($lista);
			}else {
				$lista = array ("request"=>"No se puedo realizar el registro");
				echo json_encode($lista);
			}
		}
	}
