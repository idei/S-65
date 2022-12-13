<?php

require "db.php";

$id_ate1 = $_POST['id_ate1'];
$id_ate2 = $_POST['id_ate2'];
$id_ate3 = $_POST['id_ate3'];
$id_ate4 = $_POST['id_ate4'];

$id_ori1 = $_POST['id_ori1'];
$id_ori2 = $_POST['id_ori2'];
$id_ori3 = $_POST['id_ori3'];
$id_ori4 = $_POST['id_ori4'];

$id_funejec1 = $_POST['id_funejec1'];
$id_funejec2 = $_POST['id_funejec2'];
$id_funejec3 = $_POST['id_funejec3'];
$id_funejec4 = $_POST['id_funejec4'];

$id_memoria1 = $_POST['id_memoria1'];
$id_memoria2 = $_POST['id_memoria2'];
$id_memoria3 = $_POST['id_memoria3'];
$id_memoria4 = $_POST['id_memoria4'];

$id_prexgnosia1 = $_POST['id_prexgnosia1'];
$id_prexgnosia2 = $_POST['id_prexgnosia2'];
$id_prexgnosia3 = $_POST['id_prexgnosia3'];
$id_prexgnosia4 = $_POST['id_prexgnosia4'];

$id_leng1 = $_POST['id_leng1'];
$id_leng2 = $_POST['id_leng2'];
$id_leng3 = $_POST['id_leng3'];
$id_leng4 = $_POST['id_leng4'];

$id_paciente = $_POST['id_paciente']; 
$id_medico = $_POST['id_medico'];


$tipo_screening = $_POST['tipo_screening'];
$recordatorio_medico = $_POST['id_recordatorio'];
$estado = 1;


if ($id_medico == "null") {
    $id_medico = null;
}

if ($recordatorio_medico == "null") {
    $recordatorio_medico = null;
}



// CALCULO DE RESULTADO

$result_screening = 0;


//--------------------------------------------------
$stmt = $db->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES3','TRES7','TRES8','TRES10','TRES9')");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
        }

foreach ($lista as $respuesta) {
    if($id_ate1 == $respuesta['id']){
       $result_screening +=$respuesta['ponderacion'];
    }
    if($id_ate2 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }
     if($id_ate3 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }
     if($id_ate4 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_ori1 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_ori2 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_ori3 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_ori4 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_funejec1 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_funejec2 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_funejec3 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_funejec4 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_memoria1 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_memoria2 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_memoria3 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_memoria4 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     
     if($id_prexgnosia1 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_prexgnosia2 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_prexgnosia3 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_prexgnosia4 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_leng1 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_leng2 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_leng3 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

     if($id_leng4 == $respuesta['id']){
        $result_screening +=$respuesta['ponderacion'];
     }

}


//--------------------------------------------------


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


// SELECCION DE EVENTOS
$select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
IN ('ATE1','ATE2','ATE3','ATE4','ARI1','ARI2','ARI3','ARI4','FUNE1','FUNE2','FUNE3','FUNE4',
'MEM1','MEM2','MEM3','MEM4','PYG1','PYG2','PYG3','PYG4','LEN1','LEN2','LEN3','LEN4'
)");

$select_evento->execute();
$evento = $select_evento->fetchAll();

try {
    $fecha = date('Y/m/d');

    foreach ($evento as $eventos) {

        if ($eventos["codigo_evento"] == "ATE1") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ate1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "ATE2") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ate2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "ATE3") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ate3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "ATE4") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ate4,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "ARI1") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ori1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "ARI2") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ori2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "ARI3") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ori3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "ARI4") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_ori4,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "FUNE1") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_funejec1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "FUNE2") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_funejec2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "FUNE3") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_funejec3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "FUNE4") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_funejec4,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }


        if ($eventos["codigo_evento"] == "MEM1") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_memoria1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "MEM2") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_memoria2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "MEM3") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_memoria3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "MEM4") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_memoria4,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }


        if ($eventos["codigo_evento"] == "PYG1") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_prexgnosia1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "PYG2") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_prexgnosia2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "PYG3") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_prexgnosia3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "PYG4") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_prexgnosia4,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "LEN1") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_leng1,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "LEN2") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_leng2,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "LEN3") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_leng3,
                'rela_evento' => $eventos["id"],
                'rela_tipo_screening' => $tipo_screening,
                'rela_recordatorio_medico' => $recordatorio_medico,
                'rela_paciente' => $id_paciente,
                'estado' => $estado,
                'fecha_alta' => $fecha,
                'rela_resultado' => $id_respuesta,

            );
        }

        if ($eventos["codigo_evento"] == "LEN4") {

            $rowsToInsert[] = array(
                'rela_tipo' => $id_leng4,
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
    
    if ($result_screening > 20) {
        echo json_encode("alert");
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
