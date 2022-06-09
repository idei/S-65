<?php 
    require 'db.php';
	$id_screening = $_POST["id_screening"];
    
    
    try {
        $codigo_screening = $db->prepare("SELECT codigo FROM `tipo_screening` WHERE id = '".$id_screening."'");
        $codigo_screening->execute();
        $result= $codigo_screening->fetch();
        
        $lista = array();
	if ($codigo_screening->rowCount() > 0) {
        echo json_encode($result['codigo']);
	}else {
        $pepe = "Error";
        echo json_encode($pepe);
    }
    
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
?>