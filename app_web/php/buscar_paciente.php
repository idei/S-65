<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require '../php/db.php';

session_start();
$data = json_decode(file_get_contents("php://input"), true);


if (isset($_SESSION['dni'])) {
    $dni = $data["dni"];
}

if (isset($data)) {
	$dni = $data["dni"];
}


try {
    
    $stmt = $db->prepare("SELECT *
        FROM pacientes
        WHERE dni = '".$dni."'");

    $stmt->execute();
    if ($stmt->rowCount() > 0) {
        $result = $stmt->fetch();

        $response = array(
            "request" => "Success",
            "paciente"=>[
                "nombre" => $result["nombre"],
                "apellido" => $result["apellido"],
            ],
        );

        echo json_encode($response);
    }else{
        $response = array(
            "request" => "Vacio",
        );

        echo json_encode($response);
    }
} catch (\Throwable $th) {
    //throw $th;
}
?>