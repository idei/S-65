<?php 

require 'db.php';

$id_paciente = $_POST['id_paciente'];
$id_medicamento = $_POST['id_medicamento'];
$dosis_frecuencia =  0 ; // Se define una frecuencia por defecto de valor 0

try {
    $stmt = $db->prepare('INSERT INTO medicamento_paciente(dosis_frecuencia,rela_paciente,rela_medicamento) VALUES(?, ?, ?)');
    $stmt->bindParam(1, $dosis_frecuencia);
    $stmt->bindParam(2, $id_paciente);
    $stmt->bindParam(3, $id_medicamento);

	$stmt->execute();
 
    echo json_encode("Success");

} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: ".$e->getMessage(); 
    echo json_encode($error);
}
