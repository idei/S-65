<?php 
    require 'db.php';

    $estado = $_POST["estado"];

    try {
        if ($estado == "M") {
            $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES11','TRES12', 'TRES13', 'TRES14', 'TRES15', 'TRES16', 'TRES17')");
        }else{
            if ($estado == "O") {
                $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES18', 'TRES19', 'TRES20', 'TRES21')");
            } else {
                if ($estado == "Q") {
                    $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES22', 'TRES23', 'TRES24', 'TRES25', 'TRES26')");
                } else {
                    if ($estado == "V") {
                        $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES27', 'TRES28','TRES29','TRES30', 'TRES31')");
                    } else {
                        if ($estado == "H") {
                            $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES32', 'TRES33', 'TRES34', 'TRES35', 'TRES36')");
                        } else {
                            if ($estado == "CP") {
                                $stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES37', 'TRES38', 'TRES39', 'TRES40')");
                            }
                        }
                    }
                }
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