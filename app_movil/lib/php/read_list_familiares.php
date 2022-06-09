<?php
    require "db.php";

    $email = $_POST['email'];
    

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_users = $db->prepare("SELECT id FROM `users` WHERE users.email = '".$email."'");
    $select_id_users->execute();
    $id_users= $select_id_users->fetch();
    $id_users= $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = $db->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '".$id_users."'");
    $select_id_paciente->execute();
    $id_paciente= $select_id_paciente->fetch();
    $id_paciente= $id_paciente["id"];  


    // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
    $select_antecedentes = $db->prepare("SELECT rela_evento,nombre_evento FROM antecedentes_medicos_familiares 
    JOIN eventos ON antecedentes_medicos_familiares.rela_evento = eventos.id
    WHERE antecedentes_medicos_familiares.rela_tipo = 1 AND rela_paciente = '".$id_paciente."'");
    $select_antecedentes->execute();
    
    $lista = array();
    try {
        if ($select_antecedentes->rowCount() > 0) {
            $antecedente= $select_antecedentes->fetchAll();
            
            foreach ($antecedente as $antecedentes) {
                $lista[] = $antecedentes;
            }
            echo json_encode($lista);
    
        }

    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
?>