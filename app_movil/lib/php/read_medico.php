<?php 
    require 'db.php';
	$id_paciente = $_POST["rela_paciente"];
 
    try {

        //$stmt = $db->prepare("SELECT nombre, apellido FROM usuarios_avisos
        //JOIN avisos_generales ON avisos_generales.id = usuarios_avisos.rela_aviso
        //JOIN medicos ON medicos.id = avisos_generales.rela_medico
        //WHERE rela_paciente = '".$id_paciente."' ");

$stmt = $db->prepare("SELECT * FROM usuarios_avisos
JOIN avisos_generales ON avisos_generales.id = usuarios_avisos.rela_aviso
JOIN medicos ON medicos.id = avisos_generales.rela_medico
WHERE rela_paciente = '".$id_paciente."' ");
    
        $stmt->execute();
        $result = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        $lista = array();
        
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista = $results;
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
