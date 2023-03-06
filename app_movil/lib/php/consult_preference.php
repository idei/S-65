<?php 
    require 'db.php';

    $email = $_POST['email'];
    
    try {

        $stmt = $db->prepare("SELECT id FROM users WHERE email = '".$email."'");
        $stmt->execute();
        $rela_users= $stmt->fetch();
        $rela_users= $rela_users["id"];
    
    
        $stmt_paciente = $db->prepare("SELECT * FROM pacientes WHERE rela_users = '".$rela_users."'");
        
        $stmt_paciente->execute();
        
        $result = $stmt_paciente->fetch();
        
    
        
        if ($stmt_paciente->rowCount() > 0) {
            
            $lista = array(
                "estado_users" => $result["estado_users"],
                "id_paciente" => $result["id"],
            );

        }else{
            $result_estado = 0;
        }

        echo json_encode($lista);
        

    } catch(PDOException $e) {

        $lista = array(
            "estado_read_date" => $error
        );


        echo json_encode($lista);
    }
?>