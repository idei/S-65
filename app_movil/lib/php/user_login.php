<?php 
    require 'db.php';
	$email = $_POST['email'];
	$password = $_POST['password'];
	
	$lista = array();

	$stmt = $db->prepare("SELECT * FROM users WHERE email = '".$email."' AND password = '".$password."'");
	$stmt->execute();
	$result = $stmt->rowCount();
    
	if ($result > 0) {
		$result_select_users= $stmt->fetch();
		$id_user = $result_select_users['id'];
		//$token_id = $result_select_users['token'];
		
		$result_estado = $db->prepare("SELECT * FROM pacientes WHERE rela_users = '".$id_user."'");

	    $result_estado->execute();

		$result_estado_count = $result_estado->rowCount();
		
		//if ($result_estado_count > 0) {
			$estado_user = $result_estado->fetch();
			
			$id_paciente = $estado_user['id'];
			 
			$estado_user = $estado_user['estado_users'];
             
			$array = array(
				"estado_login" => "Success",
				"estado_users" => $estado_user,
				"id_paciente" => $id_paciente,
				//"token"=> $token_id
			);
			//array_push($lista, "Success", "estado_login");
			//array_push($lista, $estado_user, "estado_users");
			echo json_encode($array);
		/*}else{
			$array = array(
				"estado_login" => "Error",
			);
			echo json_encode($array);
		}*/
	
	}else{
		$array = array(
			"estado_login" => "Error"
		);
		//array_push($lista, "Error", "estado_login");
		echo json_encode($array);
	}
?>