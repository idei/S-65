<?php 
    require 'db.php';

    $data = json_decode(file_get_contents("php://input"), true);

	$tipo = $data["tipo"];

    try {
        if ($tipo == 2) {
            $stmt = $db->prepare("SELECT * FROM generos");
            $stmt->execute();
            $result = $stmt->fetchAll();
        }
        elseif ($tipo == 1) {
            $stmt = $db->prepare("SELECT * FROM departamentos");
            $stmt->execute();
            $result = $stmt->fetchAll();
        }
        
    $lista = array();
	if ($stmt->rowCount() > 0) {
        foreach ($result as $results) {
            $lista[] = $results;
        }

        $response = array(
            "request" => "Success",
            "lista" => $lista
        );

        echo json_encode($response);
	}
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
