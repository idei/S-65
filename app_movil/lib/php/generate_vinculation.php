<?php
 require 'db.php';
 $rela_medico = $_POST["rela_medico"];
 $id_paciente = $_POST["id_paciente"];
 $estadohabilitacion = 0;

 try {
 // insertar en la tabla usuarios_avisos 
    $stmt = $db->prepare("INSERT INTO medicos_pacientes (rela_medico, rela_paciente, estado_habilitacion) VALUES (:rela_medico, :rela_paciente, :estadohabilitacion)");
    $stmt->bindParam(':rela_medico', $rela_medico);
    $stmt->bindParam(':rela_paciente', $id_paciente);
    $stmt->bindParam(':estadohabilitacion', $estadohabilitacion);
    $stmt->execute();
        
    $insert_usuarios_avisos = $stmt->rowCount();
    if ($insert_usuarios_avisos) {
        $lista = array(
            "estado" => "Success"
            );
        
        echo json_encode($lista);
    }
    } catch(PDOException $e) {
        echo '{"error":{"text":'. $e->getMessage() .'}}';
    }