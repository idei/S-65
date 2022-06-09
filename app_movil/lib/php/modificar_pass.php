<?php 
    require 'db.php';

    $email = $_POST['email'];
    $password_actual = $_POST['password'];
    $password_nuevo = $_POST['password_nuevo'];
    
    try {
        
            $stmt = $db->prepare("SELECT password FROM users WHERE email = '".$email."'");
            $stmt->execute();
            
            
        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetch();
            if ($result["password"] == $password_actual) {
                
                $error = "Error: La clave nueva no puede ser igual a la clave actual"; 
                $lista = array(
                "estado" => $error
                );
                echo json_encode($lista);

            }else {
               
                $update_pass = $db->prepare("UPDATE users
                SET password=:password_nuevo
                WHERE email=:email");
                
                $update_pass->execute([$password_nuevo,$email]);
                
                $lista = array(
                "estado" => "Success"
                );
            echo json_encode($lista);

            }
        }else {
            $error = "No se encontró el usuario para cambiar la contraseña"; 
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