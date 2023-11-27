<?php

header('Content-Type: application/json; charset=utf8');

// Base de datos gratis de db4free
// $db_name = "id16812178_app65";
// $db_server = "db4free.net:3306";
// $db_user = "id16812177_s65";
// $db_pass = "Mas65-2021bue";
// //$certificado = 'http://192.168.100.143/S-65/app_movil/lib/php/certificado.pem';

// $certificado = 'https://alanalizador.000webhostapp.com/php/certificado.pem';

//Base de datos de Hosting UNSJ
//  $db_name = "s65";
//  $db_server = "localhost";
//  $db_user = "user_s65";
//  $db_pass = "A8smFW7#";
//$certificado = 'https://190.124.224.143/php/certificado.pem';

//-------------- LOCAL -----------------------

$db_name = "dbs65";
$db_server = "localhost";
$db_user = "root";
$db_pass = "";
 //$certificado = 'C:/xampp/htdocs/S-65/app_movil/lib/php/certificado.pem';

try {

$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);

} catch (PDOException $error) {
	echo $error->getMessage();
}


if (isset($_POST['email'])) {
    $email = $_POST["email"];
    $password = $_POST['password'];
}

try {
    
    $sentencia = $db->prepare("SELECT nombre,apellido,especialidad,telefono,domicilio,dni,matricula, users.id, token, rela_rol, medicos.id id_medico
    FROM users
    join medicos on users.id = medicos.rela_users
    WHERE email = '" . $email . "' AND password = '" . $password . "'");
    $sentencia->execute();


    if ($sentencia->rowCount() > 0) {
        $datos = $sentencia->fetch();


        $id_medico = $datos['id_medico'];
        $nombre = $datos['nombre'];
        $apellido = $datos['apellido'];
        $dni = $datos['dni'];
        $matricula = $datos['matricula'];
        $especialidad = $datos['especialidad'];
        $telefono = $datos['telefono'];
        $domicilio = $datos['domicilio'];


        $lista = array(
            "status" => "Success",
            //"token" => $token_id,
            "email" => $email,
            //PacienteModel
            "medico" => [
                "id_medico" => $id_medico,
                "nombre" => $nombre,
                "apellido" => $apellido,
                "dni" => $dni,
                "matricula" => $matricula,
                "especialidad" => $especialidad,
                "telefono" => $telefono,
                "domicilio" => $domicilio
            ],
        );

        session_start();

        $_SESSION['email'] = $email;
        $_SESSION['password'] = $password;
        $_SESSION['id_medico'] = $datos['id_medico'];
        $_SESSION['dni'] = $datos['dni'];
        $_SESSION['nombre'] = $datos['nombre'];
        $_SESSION['apellido'] = $datos['apellido'];

        $token = "";

        echo json_encode($lista);

    } else {

        echo json_encode(["status" => "Error", "message" => "Error al iniciar sesión"]);

    }
} catch (PDOException $error) {

    echo "Error", $error->getMessage(), $error->getCode();
}

?>