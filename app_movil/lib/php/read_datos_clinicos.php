<?php 
    require 'db.php';
	$id_paciente = $_POST["id_paciente"];

    
    try {

    $stmt = $db->prepare("SELECT * 
    FROM datos_clinicos
    WHERE rela_paciente = '".$id_paciente."'  ORDER BY fecha_alta ASC");

	$stmt->execute();
    $result = $stmt->fetchAll();
    $lista = array();
	if ($stmt->rowCount() > 0) {
        foreach ($result as $results) {
            $lista[] = $results;
        }
        echo json_encode($lista);

	}else {
        $pepe = "Error";
        echo json_encode($pepe);
    }
    
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
?>