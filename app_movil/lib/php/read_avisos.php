<?php 
    require 'db.php';
	$id_paciente = $_POST["id_paciente"];

    try {

    $stmt = $db->prepare("SELECT avisos_generales.id id,usuarios_avisos.rela_paciente rela_paciente,
    descripcion,url_imagen,fecha_limite,rela_estado,rela_creador, avisos_generales.rela_medico, estado_leido
    FROM avisos_generales
    JOIN usuarios_avisos ON avisos_generales.id=usuarios_avisos.rela_aviso
    WHERE rela_paciente = '".$id_paciente."'  ORDER BY fecha_limite ASC");

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