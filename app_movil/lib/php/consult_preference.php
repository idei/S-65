<?php 
    require 'db.php';

    $email = $_POST['email'];
    
    try {

        $select_email = $db->prepare("SELECT id FROM users WHERE email = '".$email."'");
        $select_email->execute();
        $rela_users= $select_email->fetch();
        $rela_users= $rela_users["id"];
    
    
        $consult_estado = $db->prepare("SELECT * FROM pacientes WHERE rela_users = '".$rela_users."'");
        
        $consult_estado->execute();
        
        $result = $consult_estado->fetch();
        
    
        
        if ($consult_estado->rowCount()) {
            $result_estado = $result["estado_users"];
            $result_id_paciente = $result["id"];
        }else{
            $result_estado = 0;
        }

        $lista = array(
            "estado_users" => $result_estado,
            "id_paciente" => $result_id_paciente,
            "request" => "Success"
        );

        echo json_encode($lista);
        

    } catch(PDOException $e) {

        $lista = array(
            "estado_read_date" => $error
        );


        echo json_encode($lista);
    }
?>