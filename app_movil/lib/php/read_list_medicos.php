<?php 
    require 'db.php';
    
    $rela_paciente = $_POST['id_paciente'];

    try {
        $stmt = $db->prepare("SELECT medicos.id, nombre, apellido, especialidad  
        FROM medicos_pacientes 
        INNER JOIN medicos 
        ON medicos_pacientes.rela_medico = medicos.id
        WHERE rela_paciente = '".$rela_paciente."'");
	$stmt->execute();
    $result = $stmt->fetchAll();
    $lista = array();
	if ($stmt->rowCount() > 0) {
        foreach ($result as $results) {
            $lista[] = $results;
        }
        echo json_encode($lista);
	}
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: ".$e->getMessage(); 
        echo json_encode($error);
    }
    //deter
?>