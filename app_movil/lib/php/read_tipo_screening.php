<?php 
    require 'db.php';
	$codigo_screening = $_POST["codigo_screening"];

    try {
        $select_resultados = $db->prepare("SELECT id FROM tipo_screening
        WHERE  tipo_screening.codigo = '".$codigo_screening."'");
        $select_resultados->execute();
        $result= $select_resultados->fetch();

	if ($select_resultados->rowCount() > 0) {

        echo json_encode($result["id"]);
        
	}
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
?>