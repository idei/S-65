<?php 
    require 'db.php';
    
    try {
        if (isset($_POST['otro'])) {
            $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES46','TRES47','TRES48')");
        }else{
            $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES41','TRES42','TRES43','TRES44','TRES45')");
        }

        $stmt->execute();
        $result = $stmt->fetchAll();
        //var_dump($result);
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