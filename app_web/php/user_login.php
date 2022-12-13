<?php 

	header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST');
    header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');
    
    require 'db.php';
    
    $data = json_decode(file_get_contents("php://input"), true);
    
    $email = $data["email"];
	$password = $data['password'];

	try {
	
		$stmt = $db->prepare("SELECT * FROM users WHERE email = '".$email."' AND password = '".$password."'");
	    $stmt->execute();
	    $result = $stmt->rowCount();

		
    
	if ($result > 0) {
		$result_select_users= $stmt->fetch();
		$id_user = $result_select_users['id'];
		$token_id = $result_select_users['token'];
		
		$result_paciente = $db->prepare("SELECT * FROM pacientes WHERE rela_users = '".$id_user."'");

	    $result_paciente->execute();

		$result_paciente_count = $result_paciente->rowCount();

		if ($result_paciente_count > 0) {
			$result_paciente = $result_paciente->fetch();
			
			$id_paciente = $result_paciente['id'];
			 

			$rela_users = $result_paciente['rela_users'];
			$rela_nivel_instruccion = $result_paciente['rela_nivel_instruccion'];
			$rela_grupo_conviviente = $result_paciente['rela_grupo_conviviente'];
			$rela_departamento = $result_paciente['rela_departamento'];
			$rela_genero = $result_paciente['rela_genero'];
			$nombre = $result_paciente['nombre'];
			$apellido = $result_paciente['apellido'];
			$dni = $result_paciente['dni'];
			$fecha_nacimiento = $result_paciente['fecha_nacimiento'];
			$celular = $result_paciente['celular'];
			$contacto = $result_paciente['contacto'];
			$estado_users = $result_paciente['estado_users'];


			$lista = array(
				"request"=>"Success",
				"token"=>$token_id,
				"email" => $email,
				//PacienteModel
				"paciente"=>[
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
				"estado_users"=>$estado_users
				],
			);

			
			echo json_encode($lista);



		}else{
			$lista = array ("request"=>"Error al iniciar sesión");
	        echo json_encode($lista);
		}
	
	}else{
		
		$lista = array ("request"=>"incorrect");
	    echo json_encode($lista);
		
	}
	} catch (PDOException $error) {
		$lista = array ("request"=>$error->getMessage());
	    echo json_encode($lista);
	}

	
?>