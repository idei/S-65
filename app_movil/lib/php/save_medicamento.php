<?php 

require 'db.php';

$id_paciente = $_POST['id_paciente'];
$id_medicamento = $_POST['id_medicamento'];

try {
    $stmt = $db->prepare('INSERT INTO medicamento_paciente(rela_paciente,rela_medicamento) VALUES(?, ?)');
    $stmt->bindParam(1,$id_paciente);
    $stmt->bindParam(2,$id_medicamento);

	$stmt->execute();

    echo json_encode("Success");

} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: ".$e->getMessage(); 
    $lista = array(
        "estado_users" => $error
    );
    echo json_encode($lista);
}
