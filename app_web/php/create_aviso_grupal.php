<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Authorization, X-Requested-With');

require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);

if (isset($_POST['id_chequeo'])) {
    $id_chequeo = $_POST["id_chequeo"];
    $fecha_chequeo = $_POST['fecha_chequeo'];
    $rela_paciente = $_POST['rela_paciente'];
    $rela_medico = $_POST['rela_medico'];
}

if (isset($data)) {
    $descripcion = $data["descripcion"];
    $fecha_limite = $data['fecha_limite'];
    $email_medico = $data['email_medico'];
    
    if ( $data['genero'] != "" ) {
        $id_genero = $data['genero'];
        add_generos($db, $email_medico, $descripcion, $fecha_limite, $id_genero);
    }

    if ( count($data['arreglo']) > 0) {
        $arreglo = $data['arreglo'];
        add_departamentos($db, $email_medico, $descripcion, $fecha_limite, $arreglo);
    }
}




function add_generos($db, $email_medico, $descripcion, $fecha_limite, $id_genero)
{

    $rela_estado =  0; // Se define estado 0 por defecto

    // rela_creador define el usuario que crea el aviso 
    // (
    // 0 Medico
    // 1 Investigador
    // 2 Prestador de Salud
    // )
    $rela_creador = 0;

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_medico = $db->prepare("SELECT id FROM `users` WHERE users.email = '" . $email_medico . "'");
    $select_id_medico->execute();
    $id_medico = $select_id_medico->fetch();

    if ($select_id_medico->rowCount() > 0) {
        $rela_creador = $id_medico["id"];
    }


    try {
        $stmt = $db->prepare('INSERT INTO avisos_generales(descripcion,fecha_limite,rela_estado, rela_creador) VALUES(?, ?, ?, ?)');
        $stmt->bindParam(1, $descripcion);
        $stmt->bindParam(2, $fecha_limite);
        $stmt->bindParam(3, $rela_estado);
        $stmt->bindParam(4, $rela_creador);

        $stmt->execute();

        $rela_aviso = $db->lastInsertId();

        //Insertar relacion aviso con pacientes

        $stmt = $db->prepare("SELECT pacientes.id FROM users
    INNER JOIN pacientes ON users.id = pacientes.rela_users
    WHERE pacientes.rela_genero = '" . $id_genero . "'");

        $stmt->execute();

        $return_generos = $stmt->fetchAll();

        $estado_aviso = 1;
        $estado_leido = 0;

        if ($stmt->rowCount() > 0) {

            foreach ($return_generos as $element) {

                $stmt = $db->prepare('INSERT INTO usuarios_avisos(rela_aviso,rela_paciente,estado_aviso, estado_leido) VALUES(?, ?, ?, ?)');
                $stmt->bindParam(1, $rela_aviso);
                $stmt->bindParam(2, $element["id"]);
                $stmt->bindParam(3, $estado_aviso);
                $stmt->bindParam(4, $estado_leido);

                $stmt->execute();
            }

            $lista = array("request" => "Success");

            echo json_encode($lista);
        } else {
            $lista = array("request" => "No se pudo generar el aviso grupal");

            echo json_encode($lista);
        }



        // SELECT * FROM users
        // INNER JOIN pacientes ON users.id = pacientes.rela_users
        // WHERE pacientes.rela_departamento = 8;




    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: " . $e->getMessage();
        $lista = array("request" => $error);

        echo json_encode($lista);
    }
}


function add_departamentos($db, $email_medico, $descripcion, $fecha_limite, $arreglo)
{
    $rela_estado =  0; // Se define estado 0 por defecto

    // rela_creador define el usuario que crea el aviso 
    // (
    // 0 Medico
    // 1 Investigador
    // 2 Prestador de Salud
    // )
    $rela_creador = 0;

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_medico = $db->prepare("SELECT id FROM `users` WHERE users.email = '" . $email_medico . "'");
    $select_id_medico->execute();
    $id_medico = $select_id_medico->fetch();

    if ($select_id_medico->rowCount() > 0) {
        $rela_creador = $id_medico["id"];
    }


    try {
        $stmt = $db->prepare('INSERT INTO avisos_generales(descripcion,fecha_limite,rela_estado, rela_creador) VALUES(?, ?, ?, ?)');
        $stmt->bindParam(1, $descripcion);
        $stmt->bindParam(2, $fecha_limite);
        $stmt->bindParam(3, $rela_estado);
        $stmt->bindParam(4, $rela_creador);

        $stmt->execute();

        $rela_aviso = $db->lastInsertId();

        //Insertar relacion aviso con pacientes

        $sql = "SELECT pacientes.id FROM users
        INNER JOIN pacientes ON users.id = pacientes.rela_users
        WHERE pacientes.rela_departamento IN (" . implode(',', $arreglo) . ")";


        $stmt = $db->prepare($sql);

        $stmt->execute();

        $return_deptos_pacientes = $stmt->fetchAll();

        $estado_aviso = 1;
        $estado_leido = 0;

        if ($stmt->rowCount() > 0) {

            foreach ($return_deptos_pacientes as $element) {

                $stmt = $db->prepare('INSERT INTO usuarios_avisos(rela_aviso,rela_paciente,estado_aviso, estado_leido) VALUES(?, ?, ?, ?)');
                $stmt->bindParam(1, $rela_aviso);
                $stmt->bindParam(2, $element["id"]);
                $stmt->bindParam(3, $estado_aviso);
                $stmt->bindParam(4, $estado_leido);

                $stmt->execute();
            }

            $lista = array("request" => "Success");

            echo json_encode($lista);
        } else {
            $lista = array("request" => "No se pudo generar el aviso grupal");

            echo json_encode($lista);
        }
    } catch (PDOException $e) {
        $error = "Error conectando con la base de datos: " . $e->getMessage();
        $lista = array("request" => $error);

        echo json_encode($lista);
    }
}
