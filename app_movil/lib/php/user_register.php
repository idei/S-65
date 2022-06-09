<?php
    require "db.php";
	$email = $_POST['email'];
	$password = $_POST['password'];
	$nombre = $_POST['nombre'];
	$apellido = $_POST['apellido'];
	$dni = $_POST['dni'];
	$estado_users = 1;

	$lista = array();

	$stmt = $db->prepare("SELECT email FROM users WHERE email = '".$email."'");
	$stmt->execute();
	$result = $stmt->rowCount();

	if ($result == 1) {
		echo json_encode("Error : Ya existe una cuenta con ese email");
	}else{
		
	$stmt = $db->prepare('INSERT INTO users(email,password) VALUES(?, ?)');
    $stmt->bindParam(1,$email);
    $stmt->bindParam(2,$password);

	$stmt->execute();

	$result = $stmt->rowCount();
		if ($result) {
			$select_email = $db->prepare("SELECT id FROM users WHERE email = '".$email."'");
			$select_email->execute();
			$rela_users= $select_email->fetch();

			$insert_paciente = $db->prepare('INSERT INTO pacientes(rela_users,nombre,apellido,estado_users,dni)VALUES(?,?,?,?,?)');
			
			/*,rela_nivel_instruccion,rela_grupo_conviviente,celular,contacto,
			rela_departamento*/
			
			$insert_paciente->bindParam(1,$rela_users['id']);
			$insert_paciente->bindParam(2,$nombre);
			$insert_paciente->bindParam(3,$apellido);
			$insert_paciente->bindParam(4,$estado_users);
			$insert_paciente->bindParam(5,$dni);
			/*$insert_paciente->bindParam(7,0);
			$insert_paciente->bindParam(8,0);
			$insert_paciente->bindParam(9,"");
			$insert_paciente->bindParam(10,"");
			$insert_paciente->bindParam(11,0);*/
			$insert_paciente->execute();

			
			$insert_paciente = $stmt->rowCount();
			if ($insert_paciente) {
				array_push($lista, "Success", $estado_users);
				echo json_encode($lista);
			}
		}
	}

?>
