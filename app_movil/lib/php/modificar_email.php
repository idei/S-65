<?php 
    require 'db.php';

    $email_actual = $_POST['email'];
    $email_nuevo = $_POST['email_nuevo'];
    
    try {
        
            $stmt = $db->prepare("SELECT email FROM users WHERE email = '".$email_actual."'");
            $stmt->execute();
            
            
        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetch();
            if ($result["email"] == $email_nuevo) {
                
                $error = "Error: El correo electrónico nuevo no puede ser igual al actual"; 
                $lista = array(
                "estado" => $error
                );
                echo json_encode($lista);

            }else {
               
                $update_pass = $db->prepare("UPDATE users
                SET email=:email_nuevo
                WHERE email=:email");
                
                $update_pass->execute([$email_nuevo,$email_actual]);
                
                $lista = array(
                "estado" => "Success"
                );
            echo json_encode($lista);

            }
        }else {
            $error = "No se encontró el usuario para cambiar el correo electrónico"; 
            $lista = array(
                "estado" => $error
            );
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