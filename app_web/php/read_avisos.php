<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

//$email = $data["email"];

session_start();
if (isset($_SESSION['email'])) {
    $email= $_SESSION['email'] ;

}

if (isset($data)) {
    $email= $data['email'] ;
}

try {

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_medico = $db->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
    $select_id_medico->execute();
    $id_medico = $select_id_medico->fetch();

    if ($select_id_medico->rowCount() > 0) {
        $id_medico = $id_medico["id"];

        $stmt = $db->prepare("SELECT avisos_generales.id id,usuarios_avisos.rela_paciente rela_paciente,
    descripcion,url_imagen,fecha_creacion,fecha_limite,rela_estado,rela_creador, avisos_generales.rela_medico, estado_leido
    FROM avisos_generales
    JOIN usuarios_avisos ON avisos_generales.id=usuarios_avisos.rela_aviso
    WHERE avisos_generales.rela_creador = '" . $id_medico . "'  ORDER BY fecha_limite ASC");

        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }

            $response = array(
                "request" => "Success",
                "avisos" => $lista
            );

            echo json_encode($response);
        } else {
            $response = array(
                "request" => "Vacio",
            );
            echo json_encode($response);
        }
    } else {
        $response = array(
            "request" => "No existe el usuario",
        );
        echo json_encode($response);
    }
} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: " . $e->getMessage();
    echo json_encode($error);
}
