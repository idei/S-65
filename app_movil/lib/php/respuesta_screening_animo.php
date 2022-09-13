<?php
require "db.php";

$id_paciente = $_POST['id_paciente'];
$id_medico = $_POST['id_medico'];

$tipo_screening = $_POST['tipo_screening'];
$recordatorio_medico = $_POST['id_recordatorio'];
$estado = 1;

$result_screening = 0;


if ($_POST['satisfecho'] == "true") {
    $satisfecho = 1;
    $result_screening += 0;
} else {
    $satisfecho = 0;
    $result_screening += 1;
}

if ($_POST['abandonado'] == "true") {
    $abandonado = 1;
    $result_screening += 1;
} else {
    $abandonado = 0;
    $result_screening += 0;
}

if ($_POST['vacia'] == "true") {
    $vacia = 1;
    $result_screening += 1;
} else {
    $vacia = 0;
    $result_screening += 0;
}

if ($_POST['aburrida'] == "true") {
    $aburrida = 1;
    $result_screening += 1;
} else {
    $aburrida = 0;
    $result_screening += 0;
}

if ($_POST['humor'] == "true") {
    $humor = 1;
    $result_screening += 0;
} else {
    $humor = 0;
    $result_screening += 1;
}


if ($_POST['temor'] == "true") {
    $temor = 1;
    $result_screening += 1;
} else {
    $temor = 0;
    $result_screening += 0;
}

if ($_POST['feliz'] == "true") {
    $feliz = 1;
    $result_screening += 0;
} else {
    $feliz = 0;
    $result_screening += 1;
}


if ($_POST['desamparado'] == "true") {
    $desamparado = 1;
    $result_screening += 1;
} else {
    $desamparado = 0;
    $result_screening += 0;
}

if ($_POST['prefiere'] == "true") {
    $prefiere = 1;
    $result_screening += 1;
} else {
    $prefiere = 0;
    $result_screening += 0;
}

if ($_POST['memoria'] == "true") {
    $memoria = 1;
    $result_screening += 1;
} else {
    $memoria = 0;
    $result_screening += 0;
}

if ($_POST['estar_vivo'] == "true") {
    $estar_vivo = 1;
    $result_screening += 0;
} else {
    $estar_vivo = 0;
    $result_screening += 1;
}


if ($_POST['inutil'] == "true") {
    $inutil = 1;
    $result_screening += 1;
} else {
    $inutil = 0;
    $result_screening += 0;
}

if ($_POST['energia'] == "true") {
    $energia = 1;
    $result_screening += 0;
} else {
    $energia = 0;
    $result_screening += 1;
}

if ($_POST['situacion'] == "true") {
    $situacion = 1;
    $result_screening += 1;
} else {
    $situacion = 0;
    $result_screening += 0;
}

if ($_POST['situacion_mejor'] == "true") {
    $situacion_mejor = 1;
    $result_screening += 1;
} else {
    $situacion_mejor = 0;
    $result_screening += 0;
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


$cod_event_satisfecho = $_POST['cod_event_satisfecho'];
$cod_event_abandonado = $_POST['cod_event_abandonado'];
$cod_event_vacia = $_POST['cod_event_vacia'];
$cod_event_aburrida = $_POST['cod_event_aburrida'];
$cod_event_humor = $_POST['cod_event_humor'];
$cod_event_temor = $_POST['cod_event_temor'];
$cod_event_feliz = $_POST['cod_event_feliz'];
$cod_event_desamparado = $_POST['cod_event_desamparado'];
$cod_event_prefiere = $_POST['cod_event_prefiere'];
$cod_event_memoria = $_POST['cod_event_memoria'];
$cod_event_estar_vivo = $_POST['cod_event_estar_vivo'];
$cod_event_inutil = $_POST['cod_event_inutil'];
$cod_event_energia = $_POST['cod_event_energia'];
$cod_event_situacion = $_POST['cod_event_situacion'];
$cod_event_situacion_mejor = $_POST['cod_event_situacion_mejor'];


try {


    $fecha = date('Y/m/d');


    // SELECCION DE EVENTOS
    $select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
                IN ('ANI1','ANI2','ANI3','ANI4','ANI5','ANI6','ANI7','ANI8','ANI9','ANI10','ANI11','ANI12','ANI13','ANI14','ANI15')");

    $select_evento->execute();
    $evento = $select_evento->fetchAll();


    foreach ($evento as $eventos) {

        if ($eventos["codigo_evento"] == $cod_event_satisfecho) {

            $rowsToInsert[] = array(
                'rela_tipo' => $satisfecho,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == $cod_event_abandonado) {
            $rowsToInsert[] = array(
                'rela_tipo' => $abandonado,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_vacia) {
            $rowsToInsert[] = array(
                'rela_tipo' => $vacia,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_aburrida) {
            $rowsToInsert[] = array(
                'rela_tipo' => $aburrida,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_humor) {
            $rowsToInsert[] = array(
                'rela_tipo' => $humor,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_temor) {
            $rowsToInsert[] = array(
                'rela_tipo' => $temor,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_feliz) {
            $rowsToInsert[] = array(
                'rela_tipo' => $feliz,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_desamparado) {
            $rowsToInsert[] = array(
                'rela_tipo' => $desamparado,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_prefiere) {
            $rowsToInsert[] = array(
                'rela_tipo' => $prefiere,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_memoria) {
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
        }

        if ($eventos["codigo_evento"] == $cod_event_estar_vivo) {
            $rowsToInsert[] = array(
                'rela_tipo' => $estar_vivo,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_inutil) {
            $rowsToInsert[] = array(
                'rela_tipo' => $inutil,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_energia) {
            $rowsToInsert[] = array(
                'rela_tipo' => $cod_event_energia,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }


        if ($eventos["codigo_evento"] == $cod_event_situacion) {
            $rowsToInsert[] = array(
                'rela_tipo' => $situacion,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,
            );
        }

        if ($eventos["codigo_evento"] == $cod_event_situacion_mejor) {
            $rowsToInsert[] = array(
                'rela_tipo' => $situacion_mejor,
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
    $responseInsert = pdoMultiInsert('respuesta_screening', $rowsToInsert, $db);

    if ($recordatorio_medico <> null) {
        $rela_estado_recordatorio = 2;
        $update_estado_recordatorio = $db->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");
    
        $update_estado_recordatorio->execute([$rela_estado_recordatorio, $recordatorio_medico]); 
    }

    $lista = array();

    if ($responseInsert) {
        array_push($lista, "Success", $result_screening);
        echo json_encode($lista);
    }else {
        echo json_encode("No se puedo realizar el registro");
    }

} catch (PDOException $e) {
    echo json_encode('Error conectando con la base de datos: ' . $e->getMessage());
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
