<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

$descripcion_aviso = $data["descripcion"];
$fecha_limite = $data["feha_limite"];
$email_paciente = $data["email_paciente"];
$email_medico = $data["email_medico"];

$rela_estado =  0; // Se define estado 0 por defecto

// rela_creador define el usuario que crea el aviso 
// (
// 0 Medico
// 1 Investigador
// 2 Prestador de Salud
// )
$rela_creador = 0;


// SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

$select_id_medico = $db->prepare("SELECT id FROM `users` WHERE users.email = '" . $email_medico . "'");
$select_id_medico->execute();
$id_medico = $select_id_medico->fetch();

if ($select_id_medico->rowCount() > 0) {
    $rela_creador = $id_medico["id"];
}


// SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

$select_id_paciente = $db->prepare("SELECT id FROM `users` WHERE users.email = '" . $email_paciente . "'");
$select_id_paciente->execute();
$id_paciente = $select_id_paciente->fetch();

if ($select_id_paciente->rowCount() > 0) {
    $id_paciente = $id_paciente["id"];

    $result_paciente = $db->prepare("SELECT * FROM pacientes WHERE rela_users = '" . $id_paciente . "'");

    $result_paciente->execute();

    $result_paciente_count = $result_paciente->rowCount();

    if ($result_paciente_count > 0) {
        $result_paciente = $result_paciente->fetch();

        $id_paciente = $result_paciente['id'];
    }
}

try {
    $stmt = $db->prepare('INSERT INTO avisos_generales(descripcion,fecha_limite,rela_estado, rela_creador) VALUES(?, ?, ?, ?)');
    $stmt->bindParam(1, $descripcion_aviso);
    $stmt->bindParam(2, $fecha_limite);
    $stmt->bindParam(3, $rela_estado);
    $stmt->bindParam(4, $rela_creador);

    $stmt->execute();

    $rela_aviso = $db->lastInsertId();

    $estado_aviso = 1;
    $estado_leido = 0;

    $stmt = $db->prepare('INSERT INTO usuarios_avisos(rela_aviso,rela_paciente,estado_aviso, estado_leido) VALUES(?, ?, ?, ?)');
    $stmt->bindParam(1, $rela_aviso);
    $stmt->bindParam(2, $id_paciente);
    $stmt->bindParam(3, $estado_aviso);
    $stmt->bindParam(4, $estado_leido);

    $stmt->execute();

    $lista = array("request" => "Success");

    echo json_encode($lista);
} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: " . $e->getMessage();
    $lista = array("request" => $error);

    echo json_encode($lista);
}
