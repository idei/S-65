<?php 

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

if (isset($_POST['id_chequeo'])) {
    $id_chequeo = $_POST["id_chequeo"];
    $fecha_chequeo = $_POST['fecha_chequeo'];
    $rela_paciente = $_POST['rela_paciente'];
    $rela_medico = $_POST['rela_medico'];

}

if (isset($data)) {
	$id_chequeo = $data["id_chequeo"];
    $fecha_chequeo = $data['fecha_chequeo'];
    $rela_paciente = $data['rela_paciente'];
    $rela_medico = $data['rela_medico'];
}

$rela_estado_recordatorio = "1";
$descripcion = "Te enviaron un recordatorio de chequeo";


try {
    $stmt = $db->prepare('INSERT INTO recordatorios_medicos(descripcion,
    fecha_limite,rela_medico, rela_paciente,rela_estado_recordatorio,rela_screening) 
    VALUES(?, ?, ?, ? ,?, ?)');

    $stmt->bindParam(1, $descripcion);
    $stmt->bindParam(2, $fecha_chequeo);
    $stmt->bindParam(3, $rela_medico);
    $stmt->bindParam(4, $rela_paciente);
    $stmt->bindParam(5, $rela_estado_recordatorio);
    $stmt->bindParam(6, $id_chequeo);

    $stmt->execute();

    $lista = array("request" => "Success");

    echo json_encode($lista);

} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: " . $e->getMessage();
    $lista = array("request" => $error);

    echo json_encode($lista);
}

?>