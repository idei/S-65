<?php
require "db.php";

$id_paciente = $_POST['id_paciente'];
$id_medico = $_POST['id_medico'];


$tipo_screening = $_POST['tipo_screening'];
$recordatorio_medico = $_POST['id_recordatorio'];
$estado = 1;


$result_screening = 0;


if ($_POST['nutri1'] == "true") {
    $nutri1 = 1;
    $result_screening += 2;
} else {
    $nutri1 = 0;
}

if ($_POST['nutri2'] == "true") {
    $nutri2 = 1;
    $result_screening += 3;
} else {
    $nutri2 = 0;
}

if ($_POST['nutri3'] == "true") {
    $nutri3 = 1;
    $result_screening += 2;
} else {
    $nutri3 = 0;
}

if ($_POST['nutri4'] == "true") {
    $nutri4 = 1;
    $result_screening += 2;
} else {
    $nutri4 = 0;
}

if ($_POST['nutri5'] == "true") {
    $nutri5 = 1;
    $result_screening += 2;
} else {
    $nutri5 = 0;
}


if ($_POST['nutri6'] == "true") {
    $nutri6 = 1;
    $result_screening += 4;
} else {
    $nutri6 = 0;
}

if ($_POST['nutri7'] == "true") {
    $nutri7 = 1;
    $result_screening += 1;
} else {
    $nutri7 = 0;
}

if ($_POST['nutri8'] == "true") {
    $nutri8 = 1;
    $result_screening += 1;
} else {
    $nutri8 = 0;
}

if ($_POST['nutri9'] == "true") {
    $nutri9 = 1;
    $result_screening += 2;
} else {
    $nutri9 = 0;
}

if ($_POST['nutri10'] == "true") {
    $nutri10 = 1;
    $result_screening += 2;
} else {
    $nutri10 = 0;
}

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


$cod_event_nutri1 = $_POST['cod_event_nutri1'];
$cod_event_nutri2 = $_POST['cod_event_nutri2'];
$cod_event_nutri3 = $_POST['cod_event_nutri3'];
$cod_event_nutri4 = $_POST['cod_event_nutri4'];
$cod_event_nutri5 = $_POST['cod_event_nutri5'];
$cod_event_nutri6 = $_POST['cod_event_nutri6'];
$cod_event_nutri7 = $_POST['cod_event_nutri7'];
$cod_event_nutri8 = $_POST['cod_event_nutri8'];
$cod_event_nutri9 = $_POST['cod_event_nutri9'];
$cod_event_nutri10 = $_POST['cod_event_nutri10'];

try {

    $fecha = date('Y/m/d');

    // SELECCION DE EVENTOS
    $select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
                IN ('NUTRI1','NUTRI2','NUTRI3','NUTRI4','NUTRI5','NUTRI6','NUTRI7','NUTRI8','NUTRI9','NUTRI10')");

    $select_evento->execute();
    $evento = $select_evento->fetchAll();


    foreach ($evento as $eventos) {

        if ($eventos["codigo_evento"] == $cod_event_nutri1) {

            $rowsToInsert[] = array(
                'rela_tipo' => $nutri1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri2) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri3) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri4) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri4,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri5) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri5,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri6) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri6,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri7) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri7,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri8) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri8,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri9) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri9,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_nutri10) {
            $rowsToInsert[] = array(
                'rela_tipo' => $nutri10,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }
    }

    //Call our custom function.
    pdoMultiInsert('respuesta_screening', $rowsToInsert, $db);

    if ($recordatorio_medico <> null) {
        $rela_estado_recordatorio = 2;
        $update_estado_recordatorio = $db->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");
    
        $update_estado_recordatorio->execute([$rela_estado_recordatorio, $recordatorio_medico]); 
    }

    if ($result_screening <=2) {
        echo json_encode("Buen Estado nutricional");
    }

    if ($result_screening >=3) {
        if ($result_screening <=5) {
            echo json_encode("Moderado Riesgo nutricional");
        }
    }

    if ($result_screening >=6) {
        echo json_encode("Alto Riesgo nutricional");
    }
    

} catch (PDOException $e) {
    echo json_encode("Error");
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
