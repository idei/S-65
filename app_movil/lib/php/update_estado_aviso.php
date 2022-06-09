<?php
 require 'db.php';
 $id_aviso = $_POST["id_aviso"];
 $id_paciente = $_POST["id_paciente"];
 $estado_aviso = 1;

 try {
    $update_pass = $db->prepare("UPDATE usuarios_avisos
    SET estado_leido=:estado_aviso
    WHERE rela_aviso=:id_aviso AND rela_paciente=:id_paciente");
    
    $update_pass->execute([$estado_aviso,$id_aviso,$id_paciente]);
    
    $lista = array(
    "estado" => "Success"
    );
echo json_encode($lista);
 } catch (PDOException $e) {
    $error = "Error conectando con la base de datos: ".$e->getMessage(); 
    $lista = array(
        "estado" => $error
    );
    echo json_encode($lista);
 }


?>
