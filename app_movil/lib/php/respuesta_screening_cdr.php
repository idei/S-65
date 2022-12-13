<?php
require "db.php";

$id_paciente = $_POST['id_paciente'];
$id_medico = $_POST['id_medico'];
$recordatorio_medico = $_POST['id_recordatorio'];
$tipo_screening = $_POST['tipo_screening'];
$memoria = $_POST['memoria'];
$orientacion = $_POST['orientacion'];
$juicio_res_problema = $_POST['juicio_res_problema'];
$vida_social = $_POST['vida_social'];
$hogar = $_POST['hogar'];
$cuid_personal = $_POST['cuid_personal'];

$estado = 1;

if ($id_medico == "null") {
    $id_medico = null;
}

if ($recordatorio_medico == "null") {
    $recordatorio_medico = null;
}


$result_screening = 0;

// Guardamos el resultado del screening

$insert_resultado = $db->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
$last = $db->prepare('SELECT LAST_INSERT_ID() as id');

$insert_resultado->bindParam(1, $tipo_screening);
$insert_resultado->bindParam(2, $id_paciente);
$insert_resultado->bindParam(3, $id_medico);
$insert_resultado->bindParam(4, $result_screening);

$insert_resultado->execute();
$last->execute();


$last = $last->fetch();
$id_respuesta = $last["id"];

//--------------------------------------------------


// SELECCION DE RESPUESTAS
$select_respuesta = $db->prepare("SELECT * FROM `tipos_respuestas` WHERE code
IN ('TRES11','TRES12', 'TRES13', 'TRES14', 'TRES15', 'TRES16', 'TRES17','TRES18', 'TRES19', 'TRES20', 'TRES21','TRES22', 'TRES23', 'TRES24', 'TRES25', 'TRES26',
'TRES27', 'TRES28','TRES29','TRES30', 'TRES31','TRES32', 'TRES33', 'TRES34', 'TRES35', 'TRES36','TRES37', 'TRES38', 'TRES39', 'TRES40')");

$select_respuesta->execute();
$respuesta = $select_respuesta->fetchAll();



$lista = array();

try {
    $fecha = date('Y/m/d');

    // SELECCION DE EVENTOS
    $select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
             IN ('MEM','ORIEN','JYRP','VS','HYA','CUIDP')");

    $select_evento->execute();
    $evento = $select_evento->fetchAll();


    foreach ($evento as $eventos) {

        if ($eventos["codigo_evento"] == 'MEM') {

            $rowsToInsert[] = array(
                'rela_tipo' => $memoria,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );

            foreach ($respuesta as $respuestas) {
                if ($memoria == $respuestas['id']) {
                    if ($respuestas['code'] == 'TRES11') {
                        $result_screening +=0;
                        
                    }

                    if ($respuestas['code'] == 'TRES12') {
                        $result_screening +=0.5;
                        
                    }

                    if ($respuestas['code'] == 'TRES13') {
                        $result_screening +=0.5;
                        
                    }

                    if ($respuestas['code'] == 'TRES14') {
                        $result_screening +=0.5;
                        
                    }

                    if ($respuestas['code'] == 'TRES15') {
                        $result_screening +=1;
                        
                    }

                    if ($respuestas['code'] == 'TRES16') {
                        $result_screening +=2;
                        
                    }

                    if ($respuestas['code'] == 'TRES17') {
                        $result_screening +=3;
                        
                    }
                }
            }
        }

        if ($eventos["codigo_evento"] == 'ORIEN') {

            $rowsToInsert[] = array(
                'rela_tipo' => $orientacion,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );

            foreach ($respuesta as $respuestas) {
                if ($orientacion == $respuestas['id']) {
                    if ($respuestas['code'] == 'TRES18') {
                        $result_screening +=0;
                        
                    }

                    if ($respuestas['code'] == 'TRES19') {
                        $result_screening +=1;
                        
                    }

                    if ($respuestas['code'] == 'TRES20') {
                        $result_screening +=2;
                        
                    }

                    if ($respuestas['code'] == 'TRES21') {
                        $result_screening +=3;
                        
                    }
                }
            }

        }

        if ($eventos["codigo_evento"] == 'JYRP') {

            $rowsToInsert[] = array(
                'rela_tipo' => $juicio_res_problema,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );

            foreach ($respuesta as $respuestas) {
                if ($juicio_res_problema == $respuestas['id']) {
                    if ($respuestas['code'] == 'TRES22') {
                        $result_screening +=0;
                        
                    }

                    if ($respuestas['code'] == 'TRES23') {
                        $result_screening +=0.5;
                        
                    }

                    if ($respuestas['code'] == 'TRES24') {
                        $result_screening +=1;
                        
                    }

                    if ($respuestas['code'] == 'TRES25') {
                        $result_screening +=2;
                        
                    }
                    if ($respuestas['code'] == 'TRES26') {
                        $result_screening +=3;
                        
                    }
                }
            }

        }

        if ($eventos["codigo_evento"] == 'VS') {

            $rowsToInsert[] = array(
                'rela_tipo' => $vida_social,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );

            foreach ($respuesta as $respuestas) {
                if ($vida_social == $respuestas['id']) {
                    if ($respuestas['code'] == 'TRES27') {
                        $result_screening +=0;
                        
                    }

                    if ($respuestas['code'] == 'TRES28') {
                        $result_screening +=0.5;
                        
                    }

                    if ($respuestas['code'] == 'TRES29') {
                        $result_screening +=1;
                        
                    }

                    if ($respuestas['code'] == 'TRES30') {
                        $result_screening +=2;
                        
                    }
                    if ($respuestas['code'] == 'TRES31') {
                        $result_screening +=3;
                        
                    }
                }
            }

        }

        if ($eventos["codigo_evento"] == 'HYA') {

            $rowsToInsert[] = array(
                'rela_tipo' => $hogar,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );


            foreach ($respuesta as $respuestas) {
                if ($hogar == $respuestas['id']) {
                    if ($respuestas['code'] == 'TRES32') {
                        $result_screening +=0;
                        
                    }

                    if ($respuestas['code'] == 'TRES33') {
                        $result_screening +=0.5;
                        
                    }

                    if ($respuestas['code'] == 'TRES34') {
                        $result_screening +=1;
                        
                    }

                    if ($respuestas['code'] == 'TRES35') {
                        $result_screening +=2;
                        
                    }
                    if ($respuestas['code'] == 'TRES36') {
                        $result_screening +=3;
                        
                    }
                }
            }

            
        }

        if ($eventos["codigo_evento"] == 'CUIDP') {

            $rowsToInsert[] = array(
                'rela_tipo' => $cuid_personal,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );

            foreach ($respuesta as $respuestas) {
                if ($cuid_personal == $respuestas['id']) {
                    if ($respuestas['code'] == 'TRES37') {
                        $result_screening +=0;
                        
                    }

                    if ($respuestas['code'] == 'TRES38') {
                        $result_screening +=1;
                        
                    }

                    if ($respuestas['code'] == 'TRES39') {
                        $result_screening +=2;
                        
                    }

                    if ($respuestas['code'] == 'TRES40') {
                        $result_screening +=3;
                        
                    }
                }
            }

        }
    }
    
    $update_resultado = $db->prepare("UPDATE resultados_screenings
                    SET result_screening=:result_screening
                    WHERE id=:id_respuesta");
    
        $update_resultado->execute([$result_screening, $id_respuesta]); 

    //Call our custom function.
    pdoMultiInsert('respuesta_screening', $rowsToInsert, $db);

    if ($recordatorio_medico <> null) {
        $rela_estado_recordatorio = 2;
        $update_estado_recordatorio = $db->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");
    
        $update_estado_recordatorio->execute([$rela_estado_recordatorio, $recordatorio_medico]); 
    }

    if ($result_screening > 1) {
        echo json_encode("Alert");
    }else{
        echo json_encode("Success");
    }

    

} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: " . $e->getMessage();
    $lista = array(
        "estado_users" =>  $error
    );
    echo json_encode($lista);
}

function pdoMultiInsert($tableName, $data, $pdoObject)
{

    //Will contain SQL snippets.
    $rowsSQL = array();

    //Will contain the values that we need to bind.
    $toBind = array();

    //Get a list of column names to use in the SQL statement.
    $columnNames = array_keys($data[0]);

    //Loop through our $data array.
    foreach ($data as $arrayIndex => $row) {
        $params = array();
        foreach ($row as $columnName => $columnValue) {
            $param = ":" . $columnName . $arrayIndex;
            $params[] = $param;
            $toBind[$param] = $columnValue;
        }
        $rowsSQL[] = "(" . implode(", ", $params) . ")";
    }

    //Construct our SQL statement
    $sql = "INSERT INTO `$tableName` (" . implode(", ", $columnNames) . ") VALUES " . implode(", ", $rowsSQL);

    //Prepare our PDO statement.
    $pdoStatement = $pdoObject->prepare($sql);

    //Bind our values.
    foreach ($toBind as $param => $val) {
        $pdoStatement->bindValue($param, $val);
    }

    //Execute our statement (i.e. insert the data).
    return $pdoStatement->execute();
}
