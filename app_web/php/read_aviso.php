<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

$id = $data["id"];

//$email = $_GET["email"];

$response = '';

try {

    $stmt = $db->prepare("SELECT descripcion, url_imagen, fecha_creacion, fecha_limite
        FROM avisos_generales
        WHERE id = '".$id."'");

    $stmt->execute();
    $result = $stmt->fetch();
    $lista = array();
    if ($stmt->rowCount() > 0) {

        $response = array(
            "request" => "Success",
            "aviso" => $result
        );

        echo json_encode($response);
    } else {
        $response = array(
            "request" => "Vacio",
        );
        echo json_encode($response);
    }
} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: " . $e->getMessage();
    echo json_encode($error);
}
