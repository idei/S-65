<?php 
    require 'db.php';
     
    try {
        //$stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE respuesta IN ('Nunca','Una vez por mes','Una vez por semana','Casi todos los días')");
        $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES3','TRES49','TRES50','TRES51')");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            echo json_encode($lista);
        }
    } catch(PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage();  
        echo json_encode($error);
    }
?>