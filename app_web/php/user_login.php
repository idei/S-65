<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';

session_start();
//$data = json_decode(file_get_contents("php://input"), true);

$email = $_POST["email"];
$password = $_POST['password'];

try {

	$stmt = $db->prepare("SELECT * FROM users
		join medicos on users.id = medicos.rela_users
		WHERE email = '" . $email . "' AND password = '" . $password . "'");
	$stmt->execute();


	if ($stmt->rowCount() > 0) {
		$result_medico = $stmt->fetch();

		$id_paciente = $result_medico['id'];

		$nombre = $result_medico['nombre'];
		$apellido = $result_medico['apellido'];
		$dni = $result_medico['dni'];
		$matricula = $result_medico['matricula'];
		$especialidad = $result_medico['especialidad'];
		$telefono = $result_medico['telefono'];
		$domicilio = $result_medico['domicilio'];


		$lista = array(
			"request" => "Success",
			//"token" => $token_id,
			"email" => $email,
			//PacienteModel
			"medico" => [
				"nombre" => $nombre,
				"apellido" => $apellido,
				"dni" => $dni,
				"matricula" => $matricula,
				"especialidad" => $especialidad,
				"telefono" => $telefono,
				"domicilio" => $domicilio
			],
		);

		 $_SESSION['email'] = $email;
		 $_SESSION['password'] = $password;
		 $_SESSION['id_medico'] = $result_medico['id'];
        
		
		echo json_encode($lista);
	} else {
		$lista = array("request" => "Error al iniciar sesión");
		echo json_encode($lista);
	}
	
} catch (PDOException $error) {
	$lista = array("request" => $error->getMessage());
	echo json_encode($lista);
}
