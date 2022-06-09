<?php 
    require 'db.php';
	//$nombre = $_POST['nombre'];

    try {

    //$stmt = $db->prepare("SELECT * FROM `medicamentos` where nombre_comercial LIKE '%".$nombre."%'");

    $stmt = $db->prepare("SELECT * FROM `medicamentos`");

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