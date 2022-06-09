<?php

require 'db.php';

$id_paciente = $_POST['id_paciente'];
$id_medicamento = $_POST['id_medicamento'];
$dosis_frecuencia = $_POST['dosis_frecuencia'];

try {
    $update_pass = $db->prepare("UPDATE medicamento_paciente
                SET dosis_frecuencia=:dosis_frecuencia
                WHERE rela_paciente=:id_paciente and rela_medicamento=:id_medicamento");

    $update_pass->execute([$dosis_frecuencia, $id_paciente,$id_medicamento]);

    echo json_encode("Success");
} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: " . $e->getMessage();
    $lista = array(
        "estado_users" => $error
    );
    echo json_encode($lista);
}
