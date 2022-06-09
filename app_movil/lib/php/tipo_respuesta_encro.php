<?php 
    require 'db.php';

    $estado = $_POST["estado"];

    try {
        if ($estado == "AP" or $estado == "G") {
            $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES1','TRES2')");
        }else{
            
            if ($estado == "FD") {
                    $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES2', 'TRES55', 'TRES56')");
            }
        }
            
        
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