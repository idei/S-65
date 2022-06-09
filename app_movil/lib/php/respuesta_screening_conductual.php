<?php

require "db.php";

$id_conductual1 = $_POST['id_conductual1'];
$id_conductual2 = $_POST['id_conductual2'];
$id_conductual3 = $_POST['id_conductual3'];
$id_conductual4 = $_POST['id_conductual4'];

$id_conductual5 = $_POST['id_conductual5'];
$id_conductual6 = $_POST['id_conductual6'];
$id_conductual7 = $_POST['id_conductual7'];
$id_conductual8 = $_POST['id_conductual8'];

$id_conductual9 = $_POST['id_conductual9'];
$id_conductual10 = $_POST['id_conductual10'];
$id_conductual11 = $_POST['id_conductual11'];
$id_conductual12 = $_POST['id_conductual12'];
$id_conductual13 = $_POST['id_conductual13'];


$otro_observaciones = $_POST['observaciones'];
$id_paciente = $_POST['id_paciente'];
$id_medico = $_POST['id_medico'];


$tipo_screening = $_POST['tipo_screening'];
$recordatorio_medico = $_POST['id_recordatorio'];
$estado = 1;


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



// SELECCION DE EVENTOS-------------------------------
$select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
IN ('COND1','COND2','COND3','COND4','COND5','COND6','COND7','COND8','COND9','COND10','COND11','COND12',
'COND13')");

$select_evento->execute();
$evento = $select_evento->fetchAll();
//-----------------------------------------------------

// SELECCION DE CODE "Otro"----------------------------
$select_code = $db->prepare("SELECT code FROM `tipos_respuestas` WHERE id = '".$id_conductual1."' ");

$select_code->execute();
$select_code = $select_code->fetch();

//----------------------------------------------------

$resp_no_code = $db->prepare("SELECT code FROM `tipos_respuestas` WHERE code = 'TRES45'");

$resp_no_code->execute();
$resp_no_code = $resp_no_code->fetch();



try {
    $fecha = date('Y/m/d');

    foreach ($evento as $eventos) {

        if ($eventos["codigo_evento"] == "COND1") {

            if ($select_code == 'TRES48') {
                $observaciones = $otro_observaciones;
            }else{
                $observaciones = null;
            }

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => $observaciones,

            );
        }

        if ($eventos["codigo_evento"] == "COND2") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual2) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND3") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual3) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND4") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual4,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual4) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND5") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual5,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual5) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND6") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual6,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual6) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND7") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual7,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual7) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND8") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual8,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual8) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND9") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual9,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual9) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND10") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual10,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual10) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND11") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual11,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual11) {
                $result_screening += 1;
            }
        }

        if ($eventos["codigo_evento"] == "COND12") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual12,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual12) {
                $result_screening += 1;
            }
        }


        if ($eventos["codigo_evento"] == "COND13") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_conductual13,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
                'observacion' => null,

            );

            if ($resp_no_code <> $id_conductual13) {
                $result_screening += 1;
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
    
    if ($result_screening > 4) {
        echo json_encode("alert");
    }else{
        echo json_encode("Success");
    }
    

} catch (PDOException $e) {
    $error = "Error conectando con la base de datos: " . $e->getMessage();
    echo json_encode($error);
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
