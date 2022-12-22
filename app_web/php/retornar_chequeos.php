<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';

try {
    
    $stmt = $db->prepare("SELECT *
        FROM tipo_screening ");

    $stmt->execute();
    if ($stmt->rowCount() > 0) {
        $result = $stmt->fetchAll();

        foreach ($result as $results) {
            $lista_chequeos[] = $results;
        }

        $response = array(
            "request" => "Success",
            "chequeos"=>[
               $lista_chequeos
            ],
        );

        echo json_encode($response);
    }else{
        $response = array(
            "request" => "No hay chequeos cargados",
        );

        echo json_encode($response);
    }

} catch (\Throwable $th) {
    //throw $th;
}


?>