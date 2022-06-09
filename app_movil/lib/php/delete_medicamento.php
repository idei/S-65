<?php

require 'db.php';

$id_medicamento = $_POST['id_medicamento'];

    try {
    
        $sql = 'DELETE FROM medicamentos WHERE id_medicamento = :id_medicamento';
        $s = $db->prepare($sql);
        $s->bindValue(':id_medicamento', $id_medicamento);
        $s->execute();
        echo json_encode('Medicamento eliminado');

    } catch (PDOException $e) {
        $error = 'Error al eliminar medicamento: ' . $e->getMessage();
        echo json_encode($error);
        exit();
    }

?>