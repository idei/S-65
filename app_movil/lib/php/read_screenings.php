<?php 
    require 'db.php';
	$id_paciente = $_POST["id_paciente"];
	$select_screening = $_POST["select_screening"];

    try {
        $select_resultados = $db->prepare("SELECT tipo_screening.id,resultados_screenings.id, rela_screening, rela_paciente, result_screening, nombre, codigo, fecha_alta
        FROM `resultados_screenings` INNER JOIN 
        tipo_screening ON resultados_screenings.rela_screening = tipo_screening.id 
        WHERE resultados_screenings.rela_paciente  = '".$id_paciente."' and tipo_screening.codigo = '".$select_screening."' ORDER BY fecha_alta DESC");
        $select_resultados->execute();
        $result= $select_resultados->fetchAll();

        $lista = array();
	if ($select_resultados->rowCount() > 0) {
        foreach ($result as $results) {
            $lista[] = $results;
        }
        echo json_encode($lista);
	}else {
        $error = "Vacio";
        echo json_encode($error);
    }
    
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
?>