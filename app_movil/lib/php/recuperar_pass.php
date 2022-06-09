<?php 
    require 'db.php';

    $dni = $_POST['dni'];
    
    try {
        
            $stmt = $db->prepare("SELECT users.password FROM `users` 
            INNER JOIN  `pacientes` ON users.id = pacientes.rela_users WHERE pacientes.dni = '".$dni."'");
            
            $stmt->execute();
            $result = $stmt->fetch();
            
            if ($stmt->rowCount() > 0) {
                $lista = [
                    "estado" => "Success",
                    "password" => $result["password"]
                ];
                echo json_encode($lista);
            } else {
                $lista = [
                    "estado" => "Error"
                ];
                echo json_encode($lista);
            }
       
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        $lista = array(
            "estado" => $error
        );
        echo json_encode($lista);
    }
?>