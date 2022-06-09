<?php
 require 'db.php';
 $id_recordatorio = $_POST["id_recordatorio"];
 $estado_recordatorio = 2;

 try {
    $update_pass = $db->prepare("UPDATE recordatorios_pacientes
    SET rela_estado_recordatorio=:estado_recordatorio
    WHERE id=:id_recordatorio");
    
    $update_pass->execute([$estado_recordatorio,$id_recordatorio]);
    
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
