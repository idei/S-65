<?php
include __DIR__ . '/messeges.php';

function index()
{
    $sentencia = Flight::db()->prepare("select * FROM `pacientes`");
    $sentencia->execute();

    $datos = $sentencia->fetchAll();

    Flight::json($datos);
}

function login_doctor()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
        $password = $_POST['password'];

        session_start();
        $_SESSION['email'] = $email;
    } else {
        $email = verificar($data_input, "email");

        $password = verificar($data_input, "password");

        session_start();
        $_SESSION['email'] = $email;
    }


    try {

        $sentencia = Flight::db()->prepare("SELECT * FROM users
        join medicos on users.id = medicos.rela_users
        WHERE email = '" . $email . "' AND password = '" . $password . "'");
        $sentencia->execute();


        if ($sentencia->rowCount() > 0) {
            $datos = $sentencia->fetch();

            $id_paciente = $datos['id'];

            $nombre = $datos['nombre'];
            $apellido = $datos['apellido'];
            $dni = $datos['dni'];
            $matricula = $datos['matricula'];
            $especialidad = $datos['especialidad'];
            $telefono = $datos['telefono'];
            $domicilio = $datos['domicilio'];


            $lista = array(
                "request" => "Success",
                //"token" => $token_id,
                "email" => $email,
                //PacienteModel
                "medico" => [
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
            $_SESSION['id_medico'] = $datos['id'];

            $token = "";

            $returnData = msg_login("Success", "You have successfully logged in", $token);
        } else {

            $returnData = msg_error("Fail Session", "Error al iniciar sesión", "0");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }


    Flight::json($returnData);
}

function login_paciente()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
        $password = $_POST['password'];
    } else {
        $email = verificar($data_input, "email");

        $password = verificar($data_input, "password");
    }

    // Limpiar los espacios en blanco
    $emailLimpio = trim($email);

    try {

        $query = "SELECT * FROM users WHERE email = :email AND password = :password";
        $stmt = Flight::db()->prepare($query);
        $stmt->bindParam(":email", $emailLimpio);
        $stmt->bindParam(":password", $password);
        $stmt->execute();
        $result = $stmt->rowCount();

        if ($result > 0) {
            $result_select_users = $stmt->fetch();
            $id_user = $result_select_users['id'];
            $token_id = $result_select_users['token'];

            $result_paciente = Flight::db()->prepare("SELECT * FROM pacientes WHERE rela_users = '" . $id_user . "'");

            $result_paciente->execute();

            $result_paciente_count = $result_paciente->rowCount();

            if ($result_paciente_count > 0) {
                $result_paciente = $result_paciente->fetch();

                $id_paciente = $result_paciente['id'];

                $rela_users = $result_paciente['rela_users'];
                $rela_nivel_instruccion = $result_paciente['rela_nivel_instruccion'];
                $rela_grupo_conviviente = $result_paciente['rela_grupo_conviviente'];
                $rela_departamento = $result_paciente['rela_departamento'];
                $rela_genero = $result_paciente['rela_genero'];
                $nombre = $result_paciente['nombre'];
                $apellido = $result_paciente['apellido'];
                $dni = $result_paciente['dni'];
                $fecha_nacimiento = $result_paciente['fecha_nacimiento'];
                $celular = $result_paciente['celular'];
                $nombre_contacto = $result_paciente['nombre_contacto'];
                $apellido_contacto = $result_paciente['apellido_contacto'];
                $celular_contacto = $result_paciente['celular_contacto'];
                $estado_users = $result_paciente['estado_users'];


                $lista = array(
                    "token" => $token_id,
                    "email" => $email,
                    //PacienteModel
                    "paciente" => [
                        "rela_users" => $rela_users,
                        "rela_nivel_instruccion" => $rela_nivel_instruccion,
                        "rela_grupo_conviviente" => $rela_grupo_conviviente,
                        "rela_departamento" => $rela_departamento,
                        "rela_genero" => $rela_genero,
                        "id_paciente" => $id_paciente,
                        "nombre" => $nombre,
                        "apellido" => $apellido,
                        "dni" => $dni,
                        "fecha_nacimiento" => $fecha_nacimiento,
                        "celular" => $celular,
                        "nombre_contacto" => $nombre_contacto,
                        "apellido_contacto" => $apellido_contacto,
                        "celular_contacto" => $celular_contacto,
                        "estado_users" => $estado_users
                    ],
                );

                //echo json_encode($lista);

                $token = "";

                $returnData = msg_login("Success", $lista, $token);
            } else {
                // $lista = array ("request"=>"Error al iniciar sesión");
                // echo json_encode($lista);

                $returnData = msg_error("Fail Session", "El Email ingresado no corresponde a un paciente", "0");
            }
        } else {

            $returnData = msg_error("Fail Session", "Email o Contraseña incorrectos", "0");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }


    Flight::json($returnData);
}

function read_pacientes()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $dni = verificar($data_input, "dni");

    try {
        $data = [];

        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_medicos = Flight::db()->prepare("SELECT id FROM `medicos` WHERE dni = '" . $dni . "'");
        $select_medicos->execute();
        $id_medicos = $select_medicos->fetch();
        $id_medicos = $id_medicos["id"];

        $smt = Flight::db()->prepare("select DISTINCT pacientes.id, dni, nombre, apellido, fecha_nacimiento FROM `pacientes` 
        INNER JOIN medicos_pacientes 
        ON medicos_pacientes.rela_paciente = pacientes.id
        WHERE rela_medico = '" . $id_medicos . "' and estado_habilitacion = 2");
        $smt->execute();

        if ($smt->rowCount() > 0) {
            $result = $smt->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }


            $returnData = msg("Success", $data);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function list_pacientes()
{

    try {

        $smt = Flight::db()->prepare("select * FROM `pacientes`");
        $smt->execute();

        if ($smt->rowCount() > 0) {
            $result = $smt->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }


            $returnData = msg("Success", $data);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function estado_solicitud_medico_paciente()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $id_medico = verificar($data_input, "id_medico");

    try {

        $smt = Flight::db()->prepare("SELECT pacientes.id,nombre,apellido,dni,estado_habilitacion
        FROM `pacientes` LEFT JOIN medicos_pacientes ON medicos_pacientes.rela_paciente = pacientes.id
        where rela_medico = '" . $id_medico . "' and estado_users = 2");
        $smt->execute();

        if ($smt->rowCount() > 0) {
            $result = $smt->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function solicitud_medico_paciente()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $dni = verificar($data_input, "dni_paciente");
    //$mensaje = verificar($data_input, "mensaje_paciente");

    if (isset($_POST['mensaje_paciente'])) {
        $mensaje = $_POST["mensaje_paciente"];
    } else {
        $mensaje = verificar($data_input, "mensaje_paciente");
    }

    $id_medico = verificar($data_input, "id_medico");
    $estado_habilitacion = '1';

    try {

        $smt = Flight::db()->prepare("SELECT pacientes.id,nombre,apellido,dni,estado_habilitacion
        FROM `pacientes` LEFT JOIN medicos_pacientes ON medicos_pacientes.rela_paciente = pacientes.id
        where pacientes.dni = '" . $dni . "' and rela_medico = '" . $id_medico . "'");
        $smt->execute();

        if ($smt->rowCount() > 0) {
            $respuesta = $smt->fetch();

            $estado_habilitacion = '2';

            $id_paciente = $respuesta['id'];

            
            $data = [
                'id_paciente' => $id_paciente,
                'id_medico' => $id_medico,
                'estado_habilitacion' => $estado_habilitacion
            ];

            $update_solicitud = Flight::db()->prepare("UPDATE medicos_pacientes
                    SET estado_habilitacion=:estado_habilitacion
                    WHERE rela_paciente=:id_paciente and rela_medico=:id_medico");

            $update_solicitud->execute($data);
            $returnData = msg("Success", []);

        }else{
            $select_dni_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE dni = '" . $dni . "'");
            $select_dni_paciente->execute();

            if ($select_dni_paciente->rowCount() > 0) {
                $id_paciente = $select_dni_paciente->fetch();
            $id_paciente = $id_paciente["id"];

            $insert_resultado = Flight::db()->prepare('INSERT INTO medicos_pacientes(rela_paciente,rela_medico,estado_habilitacion,mensaje)VALUES(?,?,?,?)');

            $insert_resultado->bindParam(1, $id_paciente);
            $insert_resultado->bindParam(2, $id_medico);
            $insert_resultado->bindParam(3, $estado_habilitacion);
            $insert_resultado->bindParam(4, $mensaje);

            $insert_resultado->execute();

            $returnData = msg("Success", []);
        } else {

            $returnData = msg("Vacio", []);
        }
        }
         
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_antecedentes_familiares()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $data = [];

    $id_paciente = verificar($data_input, "id_paciente");

    $retraso = 0;
    $desorden = 0;
    $deficit = 0;
    $lesiones_cabeza = 0;
    $perdidas = 0;
    $accidentes_caidas = 0;
    $lesiones_espalda = 0;
    $infecciones = 0;
    $toxinas = 0;
    $acv = 0;
    $demencia = 0;
    $parkinson = 0;
    $epilepsia = 0;
    $esclerosis = 0;
    $huntington = 0;
    $depresion = 0;
    $trastorno = 0;
    $esquizofrenia = 0;
    $enfermedad_desorden = 0;
    $intoxicaciones = 0;
    $cancer = 0;
    $cirujia = 0;
    $trasplante = 0;
    $hipotiroidismo = 0;
    $cardiologico = 0;
    $diabetes = 0;
    $hipertension = 0;
    $colesterol = 0;


    $cod_event_retraso = "RM";
    $cod_event_desorden = 'DH';
    $cod_event_deficit = 'DA';
    $cod_event_lesiones_cabeza = 'LC';
    $cod_event_perdidas = 'PC';
    $cod_event_accidentes_caidas = 'ACG';
    $cod_event_lesiones_espalda = 'LEC';
    $cod_event_infecciones = "IPO";
    $cod_event_toxinas = 'ETOX';
    $cod_event_acv = 'ACV';
    $cod_event_demencia = 'DEM';
    $cod_event_parkinson = 'PARK';
    $cod_event_epilepsia = 'EPIL';
    $cod_event_esclerosis = 'EM';
    $cod_event_huntington = 'HUNG';
    $cod_event_depresion = 'DEPRE';
    $cod_event_trastorno = 'TB';
    $cod_event_esquizofrenia = 'ESQ';
    $cod_event_enfermedad_desorden = 'EDG';
    $cod_event_intoxicaciones = 'INTOX';

    $cod_event_cancer = 'CAN';
    $cod_event_cirujia = 'CIR';
    $cod_event_trasplante = 'TRAS';
    $cod_event_hipotiroidismo = 'HIPO';
    $cod_event_cardiologico = 'CARD';
    $cod_event_diabetes = 'DIAB';
    $cod_event_hipertension = 'HIPER';
    $cod_event_colesterol = 'COL';


    try {
      
        // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales

        $select_antecedentes = Flight::db()->prepare("SELECT * FROM antecedentes_medicos_familiares WHERE rela_paciente = '" . $id_paciente . "'");
        $select_antecedentes->execute();

        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
        $select_evento->execute();
        $evento = $select_evento->fetchAll();


        //var_dump($antecedente);
        if ($select_antecedentes->rowCount() > 0) {

            $antecedente = $select_antecedentes->fetchAll();

            foreach ($antecedente as $antecedentes) {

                foreach ($evento as $eventos) {

                    if ($antecedentes["rela_evento"] == $eventos["id"]) {

                        if ($eventos["codigo_evento"] == $cod_event_retraso) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $retraso = "Retraso Mental";
                                $stack = array("retraso" => $retraso);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_desorden) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $desorden = "Desorden del habla";
                                $stack = array("desorden" => $desorden);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_deficit) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $deficit = "Déficit de atención";
                                $stack = array("deficit" => $deficit);
                                $data =  $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $lesiones_cabeza = "Lesiones en la cabeza";
                                $stack = array("lesiones_cabeza" => $lesiones_cabeza);
                                $data =  $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $perdidas = "Pérdidas de conocimiento";
                                $stack = array("perdidas" => $perdidas);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $accidentes_caidas = "Accidentes, caídas, golpes";
                                $stack = array("accidentes_caidas" => $accidentes_caidas);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $lesiones_espalda = "Lesiones en la espalda o cuello";
                                $stack = array("lesiones_espalda" => $lesiones_espalda);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $infecciones = "Infecciones (meningitis, encefalitis) /privación de oxígeno";
                                $stack = array("infecciones" => $infecciones);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $toxinas = "Exposición a toxinas (plomo, solventes, químicos, etc.)";
                                $stack = array("toxinas" => $toxinas);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_acv) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $acv = "Accidente Cerebrovascular (ACV)";
                                $stack = array("acv" => $acv);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_demencia) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $demencia = "Demencias (ejemplo Alzheimer)";
                                $stack = array("demencia" => $demencia);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $parkinson = "Parkinson";
                                $stack = array("parkinson" => $parkinson);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $epilepsia = "Epilepsia";
                                $stack = array("epilepsia" => $epilepsia);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $esclerosis = "Esclerosis Múltiple";
                                $stack = array("esclerosis" => $esclerosis);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_huntington) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $huntington = "Huntington";
                                $stack = array("huntington" => $huntington);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_depresion) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $depresion = "Depresión";
                                $stack = array("depresion" => $depresion);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $trastorno = "Trastorno bipolar";
                                $stack = array("trastorno" => $trastorno);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $esquizofrenia = "Esquizofrenia";
                                $stack = array("esquizofrenia" => $esquizofrenia);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $enfermedad_desorden = "Enfermedad o desorden grave (inmunológico, parálisis cerebral, polio, pulmones, etc.)";
                                $stack = array("enfermedad_desorden" => $enfermedad_desorden);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $intoxicaciones = "Intoxicaciones";
                                $stack = array("intoxicaciones" => $intoxicaciones);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_cancer) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $cancer = "Cancer";
                                $stack = array("cancer" => $cancer);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_cirujia) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $cirujia = "Cirujia";
                                $stack = array("cirujia" => $cirujia);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_trasplante) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $trasplante = "Trasplante";
                                $stack = array("trasplante" => $trasplante);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_hipotiroidismo) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $hipotiroidismo = "Hipotiroidismo";
                                $stack = array("hipotiroidismo" => $hipotiroidismo);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_cardiologico) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $cardiologico = "Cardiológico";
                                $stack = array("cardiologico" => $intoxicaciones);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_diabetes) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $diabetes = "Diabetes";
                                $stack = array("diabetes" => $diabetes);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_hipertension) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $hipertension = "Hipertensión";
                                $stack = array("hipertension" => $hipertension);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_colesterol) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $colesterol = "Colesterol";
                                $stack = array("colesterol" => $colesterol);
                                $data = array_merge($data, $stack);
                            }
                        }
                    }
                }
            }

            $returnData = msg("Success", $data);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }


    Flight::json($returnData);
}

function read_antecedentes_personales()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $id_paciente = verificar($data_input, "id_paciente");

    $data = [];

    $retraso = 0;
    $desorden = 0;
    $deficit = 0;
    $lesiones_cabeza = 0;
    $perdidas = 0;
    $accidentes_caidas = 0;
    $lesiones_espalda = 0;
    $infecciones = 0;
    $toxinas = 0;
    $acv = 0;
    $demencia = 0;
    $parkinson = 0;
    $epilepsia = 0;
    $esclerosis = 0;
    $huntington = 0;
    $depresion = 0;
    $trastorno = 0;
    $esquizofrenia = 0;
    $enfermedad_desorden = 0;
    $intoxicaciones = 0;


    $cod_event_retraso = "RM";
    $cod_event_desorden = "DH";
    $cod_event_deficit = "DA";
    $cod_event_lesiones_cabeza = "LC";
    $cod_event_perdidas = "PC";
    $cod_event_accidentes_caidas = "ACG";
    $cod_event_lesiones_espalda = "LEC";
    $cod_event_infecciones = "IPO";
    $cod_event_toxinas = "ETOX";
    $cod_event_acv = "ACV";
    $cod_event_demencia = "DEM";
    $cod_event_parkinson = "PARK";
    $cod_event_epilepsia = "EPIL";
    $cod_event_esclerosis = "EM";
    $cod_event_huntington = "HUNG";
    $cod_event_depresion = "DEPRE";
    $cod_event_trastorno = "TB";
    $cod_event_esquizofrenia = "ESQ";
    $cod_event_enfermedad_desorden = "EDG";
    $cod_event_intoxicaciones = "INTOX";


    try {
    
        // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
        $select_antecedentes = Flight::db()->prepare("SELECT * FROM antecedentes_medicos_personales WHERE rela_paciente = '" . $id_paciente . "'");
        $select_antecedentes->execute();


        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
        $select_evento->execute();
        $evento = $select_evento->fetchAll();

        //var_dump($select_antecedentes->rowCount());
        if ($select_antecedentes->rowCount() > 0) {

            $antecedente = $select_antecedentes->fetchAll();

            foreach ($antecedente as $antecedentes) {

                foreach ($evento as $eventos) {

                    if ($antecedentes["rela_evento"] == $eventos["id"]) {

                        if ($eventos["codigo_evento"] == $cod_event_retraso) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $retraso = "Retraso Mental";
                                $stack = array("retraso" => $retraso);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_desorden) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $desorden = "Desorden del habla";
                                $stack = array("desorden" => $desorden);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_deficit) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $deficit = "Déficit de atención";
                                $stack = array("deficit" => $deficit);
                                $data =  $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $lesiones_cabeza = "Lesiones en la cabeza";
                                $stack = array("lesiones_cabeza" => $lesiones_cabeza);
                                $data =  $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $perdidas = "Pérdidas de conocimiento";
                                $stack = array("perdidas" => $perdidas);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $accidentes_caidas = "Accidentes, caídas, golpes";
                                $stack = array("accidentes_caidas" => $accidentes_caidas);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $lesiones_espalda = "Lesiones en la espalda o cuello";
                                $stack = array("lesiones_espalda" => $lesiones_espalda);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $infecciones = "Infecciones (meningitis, encefalitis) /privación de oxígeno";
                                $stack = array("infecciones" => $infecciones);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $toxinas = "Exposición a toxinas (plomo, solventes, químicos, etc.)";
                                $stack = array("toxinas" => $toxinas);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_acv) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $acv = "Accidente Cerebrovascular (ACV)";
                                $stack = array("acv" => $acv);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_demencia) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $demencia = "Demencias (ejemplo Alzheimer)";
                                $stack = array("demencia" => $demencia);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $parkinson = "Parkinson";
                                $stack = array("parkinson" => $parkinson);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $epilepsia = "Epilepsia";
                                $stack = array("epilepsia" => $epilepsia);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $esclerosis = "Esclerosis Múltiple";
                                $stack = array("esclerosis" => $esclerosis);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_huntington) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $huntington = "Huntington";
                                $stack = array("huntington" => $huntington);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_depresion) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $depresion = "Depresión";
                                $stack = array("depresion" => $depresion);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $trastorno = "Trastorno bipolar";
                                $stack = array("trastorno" => $trastorno);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $esquizofrenia = "Esquizofrenia";
                                $stack = array("esquizofrenia" => $esquizofrenia);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $enfermedad_desorden = "Enfermedad o desorden grave (inmunológico, parálisis cerebral, polio, pulmones, etc.)";
                                $stack = array("enfermedad_desorden" => $enfermedad_desorden);
                                $data = array_merge($data, $stack);
                            }
                        }

                        if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                            if ($antecedentes["rela_tipo"] == "1") {
                                $intoxicaciones = "Intoxicaciones";
                                $stack = array("intoxicaciones" => $intoxicaciones);
                                $data = array_merge($data, $stack);
                            }
                        }
                    }
                }
            }

            $returnData = msg("Success", $data);
        } else {
            $data = array(
                "retraso" => 0,
                "desorden" => 0,
                "deficit" => 0,
                "lesiones_cabeza" => 0,
                "perdidas" => 0,
                "accidentes_caidas" => 0,
                "lesiones_espalda" => 0,
                "infecciones" => 0,
                "toxinas" => 0,
                "acv" => 0,
                "demencia" => 0,
                "parkinson" => 0,
                "epilepsia" => 0,
                "esclerosis" => 0,
                "huntington" => 0,
                "depresion" => 0,
                "trastorno" => 0,
                "esquizofrenia" => 0,
                "enfermedad_desorden" => 0,
                "intoxicaciones" => 0,
            );

            $returnData = msg("Vacio", $data);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }


    Flight::json($returnData);
}

function read_datos_clinicos()
{

    $data_input = json_decode(file_get_contents("php://input"), true);


    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }


    try {
        
        $select_data_clinica = Flight::db()->prepare("SELECT *
        FROM datos_clinicos 
        WHERE rela_paciente = '" . $id_paciente . "' ORDER BY fecha_alta DESC");

        $select_data_clinica->execute();

        if ($select_data_clinica->rowCount() > 0) {
            $result = $select_data_clinica->fetchAll();

            $returnData = msg("Success", $result);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_datos_clinicos_paciente()
{

    $data_input = json_decode(file_get_contents("php://input"), true);


    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_dato_clinico'])) {
        $id_dato_clinico = $_POST["id_dato_clinico"];
    } else {
        $id_dato_clinico = verificar($data_input, "id_dato_clinico");
    }


    try {
        
        $select_data_clinica = Flight::db()->prepare("SELECT *
        FROM datos_clinicos 
        WHERE rela_paciente = :id_paciente AND id = :id_dato_clinico");

        $select_data_clinica->execute([
            'id_paciente' => $id_paciente,
            'id_dato_clinico' => $id_dato_clinico,
        ]);

        if ($select_data_clinica->rowCount() > 0) {
            $result = $select_data_clinica->fetch();

            $returnData = msg("Success", $result);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function respuesta_datos_clinicos()
{
    try {
        $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES49','TRES50','TRES51')");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            //echo json_encode($lista);
            // $returnData = msg("Success", $lista);
            $returnData = $lista;
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_datos_personales()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    //$dni = verificar($data_input, "dni");

    $id_paciente = verificar($data_input, "id_paciente");

    try {

        $select_data = Flight::db()->prepare("SELECT rela_users, rela_nivel_instruccion,
        rela_grupo_conviviente, rela_departamento, rela_genero, nombre, apellido, dni, 
        fecha_nacimiento, celular, nombre_contacto, apellido_contacto, celular_contacto 
        FROM pacientes 
        WHERE id = '" . $id_paciente . "'");

        $select_data->execute();


        if ($select_data->rowCount() > 0) {
            $select_data = $select_data->fetch();

            $rela_users = $select_data["rela_users"];
            $rela_nivel_instruccion = $select_data["rela_nivel_instruccion"];
            $rela_grupo_conviviente = $select_data["rela_grupo_conviviente"];
            $rela_departamento = $select_data["rela_departamento"];
            $rela_genero = $select_data["rela_genero"];
            $nombre = $select_data["nombre"];
            $apellido = $select_data["apellido"];
            $dni = $select_data["dni"];
            $fecha_nacimiento = $select_data["fecha_nacimiento"];
            $celular = $select_data["celular"];
            $nombre_contacto = $select_data["nombre_contacto"];
            $apellido_contacto = $select_data["apellido_contacto"];
            $celular_contacto = $select_data["celular_contacto"];

        } else {
            $error_msg = msg_error("Error: ", "No se encuetra usuario con el DNI ingresado", 0);
            Flight::json($error_msg);
            exit;
        }


        // $select_id_users = Flight::db()->prepare("SELECT pacientes.id id
        // FROM pacientes 
        // WHERE dni = '" . $dni . "'");

        // $select_id_users->execute();


        // if ($select_id_users->rowCount() > 0) {
        //     $id_users = $select_id_users->fetch();
        //     $id_users = $id_users["id"];
        // } else {
        //     $error_msg = msg_error("Error: ", "No se encuetra usuario con el DNI ingresado", 0);
        //     Flight::json($error_msg);
        //     exit;
        // }



        $select_data_clinica = Flight::db()->prepare("SELECT presion_alta,presion_baja 
        ,pulso, peso, circunferencia_cintura, consume_alcohol,
        consume_marihuana, otras_drogas, fuma_tabaco 
        FROM datos_clinicos 
        WHERE rela_paciente = '" . $id_paciente . "' AND estado_clinico = 1");

        $select_data_clinica->execute();


        if ($select_data_clinica->rowCount() > 0) {
            $select_data_clinica = $select_data_clinica->fetch();

            $data_clinica = array(
            "presion_alta" => $select_data_clinica["presion_alta"],
            "presion_baja" => $select_data_clinica["presion_baja"],
            "pulso" => $select_data_clinica["pulso"],
            "peso" => $select_data_clinica["peso"],
            "circunferencia_cintura" => $select_data_clinica["circunferencia_cintura"]
            );

            foreach ($data_clinica as $key => $value) {
                if (empty($value)) {
                    $data_clinica[$key] = "Sin Datos";
                }else{
                    $data_clinica[$key] = $value;
                }
            }
            
            $presion_alta = $data_clinica["presion_alta"];
            $presion_baja = $data_clinica["presion_baja"];
            $pulso = $data_clinica["pulso"];
            $peso = $data_clinica["peso"];
            $circunferencia_cintura = $data_clinica["circunferencia_cintura"];

            switch ($select_data_clinica["consume_alcohol"]) {
                case 1:
                    $consume_alcohol = "Si";
                    break;
                case 2:
                        $consume_alcohol = "No";
                    break;
                case 902:
                    $consume_alcohol = "A veces (una vez al mes)";
                    break;
                case 903:
                    $consume_alcohol = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $consume_alcohol = "Siempre (casi todos los días)";
                    break;
            }
            switch ($select_data_clinica["consume_marihuana"]) {
                case 1:
                $consume_marihuana = "Si";
                break;
                case 2:
                    $consume_marihuana = "No";
                break;
                case 902:
                    $consume_marihuana = "A veces (una vez al mes)";
                    break;
                case 903:
                    $consume_marihuana = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $consume_marihuana = "Siempre (casi todos los días)";
                    break;
            }
            switch ($select_data_clinica["otras_drogas"]) {
                case 1:
                    $otras_drogas = "Si";
                    break;
                case 2:
                        $otras_drogas = "No";
                    break;
                case 902:
                    $otras_drogas = "A veces (una vez al mes)";
                    break;
                case 903:
                    $otras_drogas = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $otras_drogas = "Siempre (casi todos los días)";
                    break;
            }
            switch ($select_data_clinica["fuma_tabaco"]) {
                case 1:
                    $fuma_tabaco = "Si";
                    break;
                case 2:
                        $fuma_tabaco = "No";
                    break;
                case 902:
                    $fuma_tabaco = "A veces (una vez al mes)";
                    break;
                case 903:
                    $fuma_tabaco = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $fuma_tabaco = "Siempre (casi todos los días)";
                    break;
            }

            $data = array(
                "rela_users" => $rela_users,
                "rela_nivel_instruccion" => $rela_nivel_instruccion,
                "rela_grupo_conviviente" => $rela_grupo_conviviente,
                "rela_departamento" => $rela_departamento,
                "rela_genero" => $rela_genero,
                "nombre" => $nombre,
                "apellido" => $apellido,
                "dni" => $dni,
                "fecha_nacimiento" => $fecha_nacimiento,
                "celular" => $celular,
                "nombre_contacto" => $nombre_contacto,
                "apellido_contacto" => $apellido_contacto,
                "celular_contacto" => $celular_contacto,
                "presion_alta" => $presion_alta,
                "presion_baja" => $presion_baja,
                "pulso" => $pulso,
                "peso" => $peso,
                "circunferencia_cintura" => $circunferencia_cintura,
                "consume_alcohol" => $consume_alcohol,
                "consume_marihuana" => $consume_marihuana,
                "otras_drogas" => $otras_drogas,
                "fuma_tabaco" => $fuma_tabaco
            );

            $returnData = msg("Success", $data);
        } else {
            $data = array(
                "rela_users" => $rela_users,
                "rela_nivel_instruccion" => $rela_nivel_instruccion,
                "rela_grupo_conviviente" => $rela_grupo_conviviente,
                "rela_departamento" => $rela_departamento,
                "rela_genero" => $rela_genero,
                "nombre" => $nombre,
                "apellido" => $apellido,
                "dni" => $dni,
                "fecha_nacimiento" => $fecha_nacimiento,
                "celular" => $celular,
                "nombre_contacto" => $nombre_contacto,
                "apellido_contacto" => $apellido_contacto,
                "celular_contacto" => $celular_contacto,
                "presion_alta" => "",
                "presion_baja" => "",
                "pulso" => "",
                "peso" => "",
                "circunferencia_cintura" => "",
                "consume_alcohol" => "",
                "consume_marihuana" => "",
                "otras_drogas" => "",
                "fuma_tabaco" => "",
                "estado_clinico" => ""
            );
            $returnData = msg("Success", $data);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }




    Flight::json($returnData);
}
/*
function read_datos_clinicos_historicos()
{
    
    $data_input = json_decode(file_get_contents("php://input"), true);

    //$dni = verificar($data_input, "dni");

    $id_paciente = verificar($data_input, "id_paciente");
    try {

        $datos_clinicos_historicos = Flight::db()->prepare("SELECT presion_alta,presion_baja ,pulso, peso, circunferencia_cintura, consume_alcohol,
        consume_marihuana, otras_drogas, fuma_tabaco 
        FROM datos_clinicos 
        WHERE rela_paciente = '" . $id_users . "' AND estado_clinico = 1");

        $datos_clinicos_historicos->execute();

        
    
        if ($datos_clinicos_historicos->rowCount() > 0) {
            $datos_clinicos_historicos = $datos_clinicos_historicos->fetch();

            $presion_alta = $datos_clinicos_historicos["presion_alta"];
            $presion_baja = $datos_clinicos_historicos["presion_baja"];
            $pulso = $datos_clinicos_historicos["pulso"];
            $peso = $datos_clinicos_historicos["peso"];
            $circunferencia_cintura = $datos_clinicos_historicos["circunferencia_cintura"];
            switch ($datos_clinicos_historicos["consume_alcohol"]) {
                case 902:
                    $consume_alcohol = "A veces (una vez al mes)";
                    break;
                case 903:
                    $consume_alcohol = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $consume_alcohol = "Siempre (casi todos los días)";
                    break;
            }
            switch ($datos_clinicos_historicos["consume_marihuana"]) {
                case 902:
                    $consume_marihuana = "A veces (una vez al mes)";
                    break;
                case 903:
                    $consume_marihuana = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $consume_marihuana = "Siempre (casi todos los días)";
                    break;
            }
            switch ($datos_clinicos_historicos["otras_drogas"]) {
                case 902:
                    $otras_drogas = "A veces (una vez al mes)";
                    break;
                case 903:
                    $otras_drogas = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $otras_drogas = "Siempre (casi todos los días)";
                    break;
            }
            switch ($datos_clinicos_historicos["fuma_tabaco"]) {
                case 902:
                    $fuma_tabaco = "A veces (una vez al mes)";
                    break;
                case 903:
                    $fuma_tabaco = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $fuma_tabaco = "Siempre (casi todos los días)";
                    break;
            }

            $data = array(
                "presion_alta" => $presion_alta,
                "presion_baja" => $presion_baja,
                "pulso" => $pulso,
                "peso" => $peso,
                "circunferencia_cintura" => $circunferencia_cintura,
                "consume_alcohol" => $consume_alcohol,
                "consume_marihuana" => $consume_marihuana,
                "otras_drogas" => $otras_drogas,
                "fuma_tabaco" => $fuma_tabaco
            );

            $returnData = msg("Success", $data);
        } else {
            $data = array(
                "presion_alta" => "",
                "presion_baja" => "",
                "pulso" => "",
                "peso" => "",
                "circunferencia_cintura" => "",
                "consume_alcohol" => "",
                "consume_marihuana" => "",
                "otras_drogas" => "",
                "fuma_tabaco" => "",
                "estado_clinico" => ""
            );
            $returnData = msg("Success", $data);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }   

    Flight::json($returnData);
}*/

function read_tipos_chequeos()
{

    try {

        $stmt = Flight::db()->prepare("SELECT id, nombre FROM tipo_screening ");

        $stmt->execute();
        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetchAll();

            foreach ($result as $results) {
                $lista_chequeos[] = $results;
            }

            $data = array(
                "chequeos" => [
                    $lista_chequeos
                ],
            );

            $returnData = msg("Success", $data);
        } else {

            $data = [];

            $returnData = msg("Vacio", $data);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_deptos_generos_patologias()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    if (isset($_POST['tipo'])) {
        $tipo = $_POST["tipo"];
    } else {
        $tipo = verificar($data_input, "tipo");
    }

    try {
        switch ($tipo) {
            case '1':
                $stmt = Flight::db()->prepare("SELECT id, nombre FROM departamentos");
                $stmt->execute();
                $result = $stmt->fetchAll();
                break;
            case '2':
                $stmt = Flight::db()->prepare("SELECT id, nombre FROM generos");
                $stmt->execute();
                $result = $stmt->fetchAll();
                break;
            case '3':
                $stmt = Flight::db()->prepare("SELECT * FROM nivel_instruccion");
                $stmt->execute();
                $result = $stmt->fetchAll();
                break;

            case '4':
                $stmt = Flight::db()->prepare("SELECT * FROM grupos_convivientes");
                $stmt->execute();
                $result = $stmt->fetchAll();
                break;

            case '5':
                $stmt = Flight::db()->prepare("SELECT * FROM eventos where codigo_evento in ('RM','DH','DA','LC',
                'PC','ACG','LEC','IPO','ACV','ETOX','DEM','PARK','EPIL','EM','HUNG','DEPRE',
                'TB','ESQ','EDG','INTOX','CAN','CIR','TRAS','HIPO','CARD','DIAB','HIPER',
                'COL')");
                $stmt->execute();
                $result = $stmt->fetchAll();
                break;

            default:
                $returnData = msg("Vacio", []);
                Flight::json($returnData);
                exit;
                break;
        }


        $data = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_recordatorio_medicos()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    if (isset($_POST['id_recordatorio'])) {
        $id_recordatorio = $_POST["id_recordatorio"];
    } else {
        $id_recordatorio = verificar($data_input, "id_recordatorio");
    }

    try {

        $stmt = Flight::db()->prepare("SELECT medicos.id id_medico, medicos.nombre, medicos.apellido, medicos.dni, medicos.matricula, tipo_screening.nombre nombre_screening, tipo_screening.codigo codigo_screening
        FROM recordatorios_medicos 
        JOIN users ON users.id = recordatorios_medicos.rela_medico 
        JOIN medicos ON medicos.id = recordatorios_medicos.rela_medico
        JOIN tipo_screening ON tipo_screening.id = recordatorios_medicos.rela_screening 
        WHERE recordatorios_medicos.id = '" . $id_recordatorio . "'");

        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetch();

            $returnData = msg("Success", $result);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_avisos()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    session_start();
    if (isset($_SESSION['email'])) {
        $email = $_SESSION['email'];
    }

    $email = verificar($data_input, "email");


    try {

        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

        $select_id_medico = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
        $select_id_medico->execute();


        if ($select_id_medico->rowCount() > 0) {
            $id_medico = $select_id_medico->fetch();
            $id_medico = $id_medico["id"];

            $stmt = Flight::db()->prepare("SELECT id, descripcion,
            url_imagen,fecha_creacion,fecha_limite,rela_estado,rela_creador,
            avisos_generales.rela_medico, aviso_criterio
            FROM avisos_generales
            WHERE avisos_generales.rela_creador = '" . $id_medico . "'  ORDER BY fecha_limite ASC");

            //JOIN usuarios_avisos ON avisos_generales.id=usuarios_avisos.rela_aviso
            $stmt->execute();
            $result = $stmt->fetchAll();
            $data = array();
            if ($stmt->rowCount() > 0) {
                foreach ($result as $results) {
                    $data[] = $results;
                }

                $returnData = msg("Success", $data);
            } else {

                $returnData = msg("Vacio", []);
            }
        } else {

            $returnData = msg("No existe el usuario", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function get_criterios()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $id_aviso = verificar($data_input, "id_aviso");
    $criterio = verificar($data_input, "criterio");


    // 1 es departamentos y 2 es genero
    switch ($criterio) {
        case 1:
            $sql_consulta = "SELECT *
            FROM avisos_departamentos 
            JOIN departamentos ON departamentos.id = avisos_departamentos.rela_departamento
            WHERE avisos_departamentos.rela_aviso = '" . $id_aviso . "'";
            break;

        case 2:
            $sql_consulta = "SELECT *
                FROM avisos_generos
                JOIN generos ON generos.id = avisos_generos.rela_genero
                WHERE avisos_generos.rela_aviso = '" . $id_aviso . "'";
            break;

        case 4: 
            $lista = array(
                "nombre" => "Anuncio Personal"
            );
                $returnData = msg("Success", $lista);
                Flight::json($returnData);
                exit;
            break;

        case 5:
            $sql_consulta = "SELECT *
                    FROM avisos_patologias
                    JOIN eventos ON eventos.id = avisos_patologias.rela_patologia
                    WHERE avisos_patologias.rela_aviso = '" . $id_aviso . "'";
            break;

        default:
            # code...
            break;
    }

    try {
        $select_criterios_avisos = Flight::db()->prepare($sql_consulta);

        $select_criterios_avisos->execute();
        if ($select_criterios_avisos->rowCount() > 0) {
            $result = $select_criterios_avisos->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
        } else {

            $returnData = msg("No existen datos", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}


function read_aviso()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    if (isset($data_input["id"])) {
        if ($data_input["id"] != "") {
            $id = $data_input["id"];
        } else {
            $error_msg = msg_error("Error", "Input id vacio", 0);
            Flight::json($error_msg);
            exit;
        }
    } else {

        $error_msg = msg_error("Error", "Nombre de dato ingresado incorrecto", 0);
        Flight::json($error_msg);
        exit;
    }

    //$id = $id_aviso;


    try {

        $stmt = Flight::db()->prepare("SELECT id,descripcion, url_imagen, fecha_creacion, fecha_limite, aviso_criterio
        FROM avisos_generales
        WHERE id = '" . $id . "'");

        $stmt->execute();

        if ($stmt->rowCount() > 0) {

            $data = $stmt->fetch();

            $returnData = msg("Success", $data);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_recordatorios()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    try {

        $stmt = Flight::db()->prepare("SELECT id,descripcion,fecha_limite,rela_estado_recordatorio,rela_paciente FROM recordatorios_pacientes
        WHERE rela_estado_recordatorio != 1 AND rela_paciente = '" . $id_paciente . "'
        UNION ALL
        SELECT id,descripcion,fecha_limite,rela_estado_recordatorio,rela_paciente FROM recordatorios_medicos
        WHERE rela_estado_recordatorio != 1 AND rela_paciente = '" . $id_paciente . "' ORDER BY fecha_limite DESC");

        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_recordatorios_medico()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $email = verificar($data_input, "email");

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
    $select_id_users->execute();

    if ($select_id_users->rowCount() > 0) {
        $id_users = $select_id_users->fetch();
        $id_users = $id_users["id"];
    } else {
        $error_msg = msg_error("Error: ", "No se encuetra usuario con el Email ingresado", 0);
        Flight::json($error_msg);
        exit;
    }


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_medico = Flight::db()->prepare("SELECT id FROM `medicos` WHERE medicos.rela_users = '" . $id_users . "'");
    $select_id_medico->execute();


    if ($select_id_medico->rowCount() > 0) {
        $id_medico = $select_id_medico->fetch();
        $id_medico = $id_medico["id"];
    } else {
        $error_msg = msg_error("Error: ", "No se encuntra el medico", 0);
        Flight::json($error_msg);
        exit;
    }

    try {

        $stmt = Flight::db()->prepare("SELECT id,descripcion,fecha_limite,rela_estado_recordatorio,rela_paciente FROM recordatorios_medicos
        WHERE rela_medico = '" . $id_medico . "' ORDER BY fecha_limite ASC");

        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function crear_recordatorio_chequeo(){
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['tipo_chequeo'])) {
        $tipo_chequeo = $_POST["tipo_chequeo"];
    } else {
        $tipo_chequeo = verificar($data_input, "tipo_chequeo");
    }

    if (isset($_POST['fecha_chequeo'])) {
        $fecha_chequeo = $_POST["fecha_chequeo"];
    } else {
        $fecha_chequeo = verificar($data_input, "fecha_chequeo");
    }

    if (isset($_POST['id_medico'])) {
        $id_medico = $_POST["id_medico"];
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['descripcion'])) {
        $descripcion = $_POST["descripcion"];
    } else {
        $descripcion = verificar($data_input, "descripcion");
    }

    try {

        $rela_respuesta_screening = 1;
        $rela_estado_recordatorio = 2;

        $stmt = Flight::db()->prepare('INSERT INTO recordatorios_medicos(rela_paciente,rela_medico,rela_respuesta_screening,rela_estado_recordatorio, rela_screening,descripcion,fecha_limite) 
        VALUES(?, ?, ?, ?, ?, ?, ?)');
        $stmt->bindParam(1, $id_paciente);
        $stmt->bindParam(2, $id_medico);
        $stmt->bindParam(3, $rela_respuesta_screening);
        $stmt->bindParam(4, $rela_estado_recordatorio);
        $stmt->bindParam(5, $tipo_chequeo);
        $stmt->bindParam(6, $descripcion);
        $stmt->bindParam(7, $fecha_chequeo);

        $stmt->execute();

        // Flight::json($returnData);
        // exit;

        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function chequeos_medico_paciente()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $id_medico = verificar($data_input, "id_medico");
    $id_paciente = verificar($data_input, "id_paciente");

    try {

        $stmt = Flight::db()->prepare("SELECT recordatorios_medicos.id id, 
        descripcion,
        fecha_limite,
        fecha_creacion, 
        rela_estado_recordatorio, 
        nombre_estado,
        recordatorios_medicos.rela_paciente rela_paciente, 
        nombre,
        result_screening resultado
        FROM recordatorios_medicos 
        JOIN tipo_screening ON recordatorios_medicos.rela_screening = tipo_screening.id 
        JOIN estado_recordatorio ON recordatorios_medicos.rela_estado_recordatorio = estado_recordatorio.id
        JOIN resultados_screenings ON recordatorios_medicos.rela_respuesta_screening = resultados_screenings.id
        WHERE recordatorios_medicos.rela_medico = '" . $id_medico . "'
        AND recordatorios_medicos.rela_paciente = '" . $id_paciente . "'
        ORDER BY fecha_limite ASC");

        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function get_chequeos()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    if (isset($_POST['id_medico'])) {
        $id_medico = $_POST["id_medico"];
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    try {

        $stmt = Flight::db()->prepare("SELECT recordatorios_medicos.id id, 
        descripcion,
        fecha_limite,
        fecha_creacion, 
        rela_estado_recordatorio, 
        nombre_estado,
        recordatorios_medicos.rela_paciente rela_paciente, 
        tipo_screening.nombre,
        result_screening resultado,
        P.nombre nombre_paciente,
        P.apellido apellido_paciente
        FROM recordatorios_medicos 
        JOIN tipo_screening on recordatorios_medicos.rela_screening = tipo_screening.id 
        JOIN estado_recordatorio ON recordatorios_medicos.rela_estado_recordatorio = estado_recordatorio.id
        LEFT JOIN resultados_screenings ON recordatorios_medicos.rela_respuesta_screening = resultados_screenings.id
        JOIN pacientes AS P ON P.id = recordatorios_medicos.rela_paciente
        WHERE recordatorios_medicos.rela_medico = '" . $id_medico . "' ORDER BY fecha_creacion ASC");

        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetchAll();

            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function antecedentes_personales_paciente()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
    $select_id_users->execute();
    $id_users = $select_id_users->fetch();
    $id_users = $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
    $select_id_paciente->execute();
    $id_paciente = $select_id_paciente->fetch();
    $id_paciente = $id_paciente["id"];


    // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
    $select_antecedentes = Flight::db()->prepare("SELECT rela_evento,nombre_evento FROM antecedentes_medicos_personales 
    JOIN eventos ON antecedentes_medicos_personales.rela_evento = eventos.id
    WHERE antecedentes_medicos_personales.rela_tipo = 1 AND rela_paciente = '" . $id_paciente . "'");
    $select_antecedentes->execute();

    $lista = array();
    try {
        if ($select_antecedentes->rowCount() > 0) {
            $antecedente = $select_antecedentes->fetchAll();

            foreach ($antecedente as $antecedentes) {
                $lista[] = $antecedentes;
            }
            //echo json_encode($lista);
            $returnData = msg("Success", $lista);
            //$returnData = $lista;
        } else {
            //echo json_encode("Vacio");
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function antecedentes_familiares_paciente()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
    $select_id_users->execute();
    $id_users = $select_id_users->fetch();
    $id_users = $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
    $select_id_paciente->execute();
    $id_paciente = $select_id_paciente->fetch();
    $id_paciente = $id_paciente["id"];


    // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_familiares
    $select_antecedentes = Flight::db()->prepare("SELECT rela_evento,nombre_evento FROM antecedentes_medicos_familiares 
    JOIN eventos ON antecedentes_medicos_familiares.rela_evento = eventos.id
    WHERE antecedentes_medicos_familiares.rela_tipo = 1 AND rela_paciente = '" . $id_paciente . "'");
    $select_antecedentes->execute();

    $lista = array();
    try {
        if ($select_antecedentes->rowCount() > 0) {
            $antecedente = $select_antecedentes->fetchAll();

            foreach ($antecedente as $antecedentes) {
                $lista[] = $antecedentes;
            }
            //echo json_encode($lista);
            $returnData = msg("Success", $lista);
            //$returnData = $lista;
        } else {
            //echo json_encode("Vacio");
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function medicamentos_paciente()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

    $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
    $select_id_users->execute();
    $id_users = $select_id_users->fetch();
    $id_users = $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
    $select_id_paciente->execute();
    $id_paciente = $select_id_paciente->fetch();
    $id_paciente = $id_paciente["id"];


    try {

        $stmt = Flight::db()->prepare("SELECT * FROM `medicamento_paciente` 
        INNER JOIN medicamentos on medicamentos.id_medicamento = medicamento_paciente.rela_medicamento
         WHERE rela_paciente = '" . $id_paciente . "' ");

        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function medicamentos_paciente_vademecum()
{
    $returnData = [];

    try {

        $stmt = Flight::db()->prepare("SELECT * FROM `medicamentos`");

        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function save_dosis_frecuencia()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_medicamento'])) {
        $id_medicamento = $_POST["id_medicamento"];
    } else {
        $id_medicamento = verificar($data_input, "id_medicamento");
    }

    if (isset($_POST['dosis_frecuencia'])) {
        $dosis_frecuencia = $_POST["dosis_frecuencia"];
    } else {
        $dosis_frecuencia = verificar($data_input, "dosis_frecuencia");
    }


    try {
        $data = [
            'dosis_frecuencia' => $dosis_frecuencia,
            'id_paciente' => $id_paciente,
            'id_medicamento' => $id_medicamento,
        ];
        $update_pass = Flight::db()->prepare("UPDATE medicamento_paciente
                    SET dosis_frecuencia=:dosis_frecuencia
                    WHERE rela_paciente=:id_paciente and rela_medicamento=:id_medicamento");

        $update_pass->execute($data);

        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function delete_medicamento()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_medicamento'])) {
        $id_medicamento = $_POST["id_medicamento"];
    } else {
        $id_medicamento = verificar($data_input, "id_medicamento");
    }

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }


    try {

        $stmt = Flight::db()->prepare('DELETE FROM medicamento_paciente 
        WHERE rela_medicamento =:id_medicamento AND rela_paciente =:id_paciente');
        $stmt->bindValue(':id_medicamento', $id_medicamento);
        $stmt->bindValue(':id_paciente', $id_paciente);
        $stmt->execute();
        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function save_medicamento()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_medicamento'])) {
        $id_medicamento = $_POST["id_medicamento"];
    } else {
        $id_medicamento = verificar($data_input, "id_medicamento");
    }

    if (isset($_POST['dosis_frecuencia'])) {
        $dosis_frecuencia = $_POST["dosis_frecuencia"];
    } else {
        $dosis_frecuencia = verificar($data_input, "dosis_frecuencia");
    }

    try {
        $stmt = Flight::db()->prepare('INSERT INTO medicamento_paciente(dosis_frecuencia,rela_paciente,rela_medicamento) VALUES(?, ?, ?)');
        $stmt->bindParam(1, $dosis_frecuencia);
        $stmt->bindParam(2, $id_paciente);
        $stmt->bindParam(3, $id_medicamento);

        $stmt->execute();

        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function avisos_paciente()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }


    try {

        $stmt = Flight::db()->prepare("SELECT avisos_generales.id id,usuarios_avisos.rela_paciente rela_paciente,
    descripcion,url_imagen,fecha_limite,rela_estado,rela_creador, avisos_generales.rela_medico, estado_leido
    FROM avisos_generales
    JOIN usuarios_avisos ON avisos_generales.id=usuarios_avisos.rela_aviso
    WHERE rela_paciente = '" . $id_paciente . "'  ORDER BY fecha_limite ASC");

        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function modificar_email()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];


    if (isset($_POST['email'])) {
        $email_actual = $_POST["email"];
    } else {
        $email_actual = verificar($data_input, "email");
    }

    if (isset($_POST['email_nuevo'])) {
        $email_nuevo = $_POST["email_nuevo"];
    } else {
        $email_nuevo = verificar($data_input, "email_nuevo");
    }


    try {

        $stmt = Flight::db()->prepare("SELECT email FROM users WHERE email = '" . $email_actual . "'");
        $stmt->execute();


        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetch();
            if ($result["email"] == $email_nuevo) {

                $error = "Error: El correo electrónico nuevo no puede ser igual al actual";
                $lista = array(
                    "estado" => $error
                );
                echo json_encode($lista);
            } else {

                $update_pass = Flight::db()->prepare("UPDATE users
                SET email=:email_nuevo
                WHERE email=:email");

                $update_pass->execute([$email_nuevo, $email_actual]);

                $returnData = msg("Success", []);
            }
        } else {

            $returnData = msg("Vacio", "No se encontró el usuario para cambiar el correo electrónico");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function modificar_pass()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];


    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    if (isset($_POST['email'])) {
        $password_actual = $_POST["password"];
    } else {
        $password_actual = verificar($data_input, "password");
    }

    if (isset($_POST['password_nuevo'])) {
        $password_nuevo = $_POST["password_nuevo"];
    } else {
        $password_nuevo = verificar($data_input, "password_nuevo");
    }

    try {

        $stmt = Flight::db()->prepare("SELECT password FROM users WHERE email = '" . $email . "'");
        $stmt->execute();


        if ($stmt->rowCount() > 0) {
            $result = $stmt->fetch();
            if ($result["password"] == $password_actual) {

                $error = "Error: La clave nueva no puede ser igual a la clave actual";
                $lista = array(
                    "estado" => $error
                );
                echo json_encode($lista);
            } else {

                $update_pass = Flight::db()->prepare("UPDATE users
                SET password=:password_nuevo
                WHERE email=:email");

                $update_pass->execute([$password_nuevo, $email]);

                $returnData = msg("Success", "No se encontró el usuario para cambiar la contraseña");
            }
        } else {
            $error = "No se encontró el usuario para cambiar la contraseña";
            $returnData = msg("Success", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function recuperar_pass()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];


    if (isset($_POST['dni'])) {
        $dni = $_POST["dni"];
    } else {
        $dni = verificar($data_input, "dni");
    }

    try {

        $stmt = Flight::db()->prepare("SELECT users.password FROM `users` 
            INNER JOIN  `pacientes` ON users.id = pacientes.rela_users WHERE pacientes.dni = '" . $dni . "'");

        $stmt->execute();
        $result = $stmt->fetch();

        if ($stmt->rowCount() > 0) {
            $lista = [
                "estado" => "Success",
                "password" => $result["password"]
            ];
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}


function update_estado_aviso()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];


    if (isset($_POST['rela_aviso'])) {
        $id_aviso = $_POST["rela_aviso"];
    } else {
        $id_aviso = verificar($data_input, "rela_aviso");
    }

    if (isset($_POST['rela_paciente'])) {
        $id_paciente = $_POST["rela_paciente"];
    } else {
        $id_paciente = verificar($data_input, "rela_paciente");
    }

    if (isset($_POST['estado_leido'])) {
        $estado_aviso = $_POST["estado_leido"];
    } else {
        $estado_aviso = verificar($data_input, "estado_leido");
    }

    //echo $id_aviso.$id_paciente.$estado_aviso;
    $estado_aviso = 1;

    try {
        $data = [
            'estado_aviso' => $estado_aviso,
            'id_aviso' => $id_aviso,
            'id_paciente' => $id_paciente,
        ];

        $update_pass = Flight::db()->prepare("UPDATE usuarios_avisos
        SET estado_leido=:estado_aviso
        WHERE rela_aviso=:id_aviso AND rela_paciente=:id_paciente");

        $update_pass->execute($data);

        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function update_recordatorio_personal()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_recordatorio'])) {
        $id_recordatorio = $_POST["id_recordatorio"];
    } else {
        $id_recordatorio = verificar($data_input, "id_recordatorio");
    }

    $estado_recordatorio = 2;

    try {
        $data = [
            'id_recordatorio' => $id_recordatorio,
            "estado_recordatorio" => $estado_recordatorio
        ];

        $update_pass = Flight::db()->prepare("UPDATE recordatorios_pacientes
         SET rela_estado_recordatorio=:estado_recordatorio
         WHERE id=:id_recordatorio");

        $update_pass->execute($data);

        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function new_recordatorio_personal()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    if (isset($_POST['titulo'])) {
        $titulo = $_POST["titulo"];
    } else {
        $titulo = verificar($data_input, "titulo");
    }

    if (isset($_POST['fecha_limite'])) {
        $fecha_limite = $_POST["fecha_limite"];
    } else {
        $fecha_limite = verificar($data_input, "fecha_limite");
    }

    $estado_recordatorio = 0;


    try {
        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

        $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
        $select_id_users->execute();
        $id_users = $select_id_users->fetch();
        $id_users = $id_users["id"];

        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
        $select_id_paciente->execute();


        $result_paciente = $select_id_paciente->rowCount();

        if ($result_paciente == 0) {
            $lista = array("request" => "Error al guardar recoradtorio");
            echo json_encode($lista);
        } else {

            $id_paciente = $select_id_paciente->fetch();
            $id_paciente = $id_paciente["id"];

            $stmt = Flight::db()->prepare('INSERT INTO recordatorios_pacientes(descripcion,fecha_limite,rela_paciente,rela_estado_recordatorio) VALUES(?, ?, ?, ?)');
            $stmt->bindParam(1, $titulo);
            $stmt->bindParam(2, $fecha_limite);
            $stmt->bindParam(3, $id_paciente);
            $stmt->bindParam(4, $estado_recordatorio);

            $stmt->execute();

            $insert_recordatorio = $stmt->rowCount();

            if ($insert_recordatorio) {
                $returnData = msg("Success", []);
            }
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_tipo_screening()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['codigo_screening'])) {
        $codigo_screening = $_POST["codigo_screening"];
    } else {
        $codigo_screening = verificar($data_input, "codigo_screening");
    }


    try {
        $select_resultados = Flight::db()->prepare("SELECT id FROM tipo_screening
        WHERE  tipo_screening.codigo = '" . $codigo_screening . "'");
        $select_resultados->execute();
        $result = $select_resultados->fetch();

        if ($select_resultados->rowCount() > 0) {

            $returnData = msg("Success", $result["id"]);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function verificar($data_input, $tipo)
{

    if (isset($data_input[$tipo])) {
        if ($data_input[$tipo] != "") {
            $tipo = $data_input[$tipo];
        } else {
            $error_msg = msg_error("Error", "Input " . $tipo . " vacio", 0);
            Flight::json($error_msg);
            exit;
        }
    } else {

        $error_msg = msg_error("Error", "Nombre de " . $tipo . " ingresado incorrecto", 0);
        Flight::json($error_msg);
        exit;
    }

    return $tipo;
}

function respuesta_screening_fisico()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    $id_medico = "";
    if (isset($_POST['id_medico'])) {
        if ($_POST["id_medico"] === "null") {
            $id_medico = null;
        } else {
            $id_medico = $_POST["id_medico"];
        }
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['tipo_screening'])) {
        $tipo_screening = $_POST["tipo_screening"];
    } else {
        $tipo_screening = verificar($data_input, "tipo_screening");
    }

    if (isset($_POST['id_recordatorio'])) {
        if ($_POST["id_recordatorio"] === "null") {
            $recordatorio_medico = null;
        } else {
            $recordatorio_medico = $_POST["id_recordatorio"];
        }
    } else {

        $recordatorio_medico = verificar($data_input, "id_recordatorio");
    }


    if (isset($_POST['cantidad'])) {
        $result_screening = $_POST["cantidad"];
    } else {
        $result_screening = verificar($data_input, "cantidad");
    }


    $estado = 1;


    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

    $insert_resultado->bindParam(1, $tipo_screening);
    $insert_resultado->bindParam(2, $id_paciente);
    $insert_resultado->bindParam(3, $id_medico);
    $insert_resultado->bindParam(4, $result_screening);

    $insert_resultado->execute();

    $last->execute();

    $id_respuesta = $insert_resultado->fetch();
    $last = $last->fetch();
    $id_respuesta = $last["id"];


    //--------------------------------------------------
    $dolor_cabeza = $_POST['dolor_cabeza'] == "977" ? 1 : 0;

    $mareos = $_POST['mareos'] == "977" ? 1 : 0;

    $nauceas = $_POST['nauceas'] == "977" ? 1 : 0;

    $vomito = $_POST['vomito'] == "977" ? 1 : 0;

    $fatiga_excesiva = $_POST['fatiga_excesiva'] == "977" ? 1 : 0;

    $urinaria = $_POST['urinaria'] == "977" ? 1 : 0;

    $problemas_instestinales = $_POST['problemas_instestinales'] == "977" ? 1 : 0;

    $debilidad_lado_cuerpo = $_POST['debilidad_lado_cuerpo'] == "977" ? 1 : 0;

    $problemas_motricidad = $_POST['problemas_motricidad'] == "977" ? 1 : 0;

    $temblores = $_POST['temblores'] == "977" ? 1 : 0;

    $inestabilidad_marcha = $_POST['inestabilidad_marcha'] == "977" ? 1 : 0;

    $tics_mov_extranos = $_POST['tics_mov_extranos'] == "977" ? 1 : 0;

    $problemas_equilibrio = $_POST['problemas_equilibrio'] == "977" ? 1 : 0;

    $choque_cosas = $_POST['choque_cosas'] == "977" ? 1 : 0;

    $desmayo = $_POST['desmayo'] == "977" ? 1 : 0;

    $caidas = $_POST['caidas'] == "977" ? 1 : 0;

    $perdida_sensibilidad = $_POST['perdida_sensibilidad'] == "977" ? 1 : 0;

    $cosquilleo_piel = $_POST['cosquilleo_piel'] == "977" ? 1 : 0;

    $ojos_claridad = $_POST['ojos_claridad'] == "977" ? 1 : 0;

    $perdida_audicion = $_POST['perdida_audicion'] == "977" ? 1 : 0;

    $utiliza_audifonos = $_POST['utiliza_audifonos'] == "977" ? 1 : 0;

    $zumbido = $_POST['zumbido'] == "977" ? 1 : 0;

    $anteojo_cerca = $_POST['anteojo_cerca'] == "977" ? 1 : 0;

    $anteojo_lejos = $_POST['anteojo_lejos'] == "977" ? 1 : 0;

    $vision_lado = $_POST['vision_lado'] == "977" ? 1 : 0;

    $vision_borrosa = $_POST['vision_borrosa'] == "977" ? 1 : 0;

    $vision_doble = $_POST['vision_doble'] == "977" ? 1 : 0;

    $cosas_no_existen = $_POST['cosas_no_existen'] == "977" ? 1 : 0;

    $sensibilidad_cosas_brillantes = $_POST['sensibilidad_cosas_brillantes'] == "977" ? 1 : 0;

    $periodos_ceguera = $_POST['periodos_ceguera'] == "977" ? 1 : 0;

    $persibe_cosas_cuerpo = $_POST['persibe_cosas_cuerpo'] == "977" ? 1 : 0;

    $dificultad_calor_frio = $_POST['dificultad_calor_frio'] == "977" ? 1 : 0;

    $problemas_gusto = $_POST['problemas_gusto'] == "977" ? 1 : 0;

    $problemas_olfato = $_POST['problemas_olfato'] == "977" ? 1 : 0;

    $dolor = $_POST['dolor'] == "977" ? 1 : 0;


    $cod_event_dolor_cabeza = $_POST['cod_event_dolor_cabeza'];
    $cod_event_mareos = $_POST['cod_event_mareos'];
    $cod_event_nauceas = $_POST['cod_event_nauceas'];
    $cod_event_vomito = $_POST['cod_event_vomito'];
    $cod_event_fatiga_excesiva = $_POST['cod_event_fatiga_excesiva'];
    $cod_event_urinaria = $_POST['cod_event_urinaria'];
    $cod_event_problemas_instestinales = $_POST['cod_event_problemas_instestinales'];
    $cod_event_debilidad_lado_cuerpo = $_POST['cod_event_debilidad_lado_cuerpo'];
    $cod_event_problemas_motricidad = $_POST['cod_event_problemas_motricidad'];
    $cod_event_temblores = $_POST['cod_event_temblores'];
    $cod_event_inestabilidad_marcha = $_POST['cod_event_inestabilidad_marcha'];
    $cod_event_tics_mov_extranos = $_POST['cod_event_tics_mov_extranos'];
    $cod_event_problemas_equilibrio = $_POST['cod_event_problemas_equilibrio'];
    $cod_event_choque_cosas = $_POST['cod_event_choque_cosas'];
    $cod_event_desmayo = $_POST['cod_event_desmayo'];
    $cod_event_caidas = $_POST['cod_event_caidas'];
    $cod_event_perdida_sensibilidad = $_POST['cod_event_perdida_sensibilidad'];
    $cod_event_cosquilleo_piel = $_POST['cod_event_cosquilleo_piel'];
    $cod_event_ojos_claridad = $_POST['cod_event_ojos_claridad'];
    $cod_event_perdida_audicion = $_POST['cod_event_perdida_audicion'];
    $cod_event_utiliza_audifonos = $_POST['cod_event_utiliza_audifonos'];
    $cod_event_zumbido = $_POST['cod_event_zumbido'];
    $cod_event_anteojo_cerca = $_POST['cod_event_anteojo_cerca'];
    $cod_event_anteojo_lejos = $_POST['cod_event_anteojo_lejos'];
    $cod_event_vision_lado = $_POST['cod_event_vision_lado'];
    $cod_event_vision_borrosa = $_POST['cod_event_vision_borrosa'];
    $cod_event_vision_doble = $_POST['cod_event_vision_doble'];
    $cod_event_cosas_no_existen = $_POST['cod_event_cosas_no_existen'];
    $cod_event_sensibilidad_cosas_brillantes = $_POST['cod_event_sensibilidad_cosas_brillantes'];
    $cod_event_periodos_ceguera = $_POST['cod_event_periodos_ceguera'];
    $cod_event_persibe_cosas_cuerpo = $_POST['cod_event_persibe_cosas_cuerpo'];
    $cod_event_dificultad_calor_frio = $_POST['cod_event_dificultad_calor_frio'];
    $cod_event_problemas_gusto = $_POST['cod_event_problemas_gusto'];
    $cod_event_problemas_olfato = $_POST['cod_event_problemas_olfato'];
    $cod_event_dolor = $_POST['cod_event_dolor'];


    try {

        $fecha = date('Y/m/d');

        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
                IN ('DOLCA','MAREO','NAUS','VOM','FATEX','INCUR','PROMI','DEBCU','PROMF','TEMBL','INMAR',
                'TICS','PEQUI','FRECC','DESMA','CAIDA','PESEN','COSQP','NECCL','PERAU','UTAUD','ZUMB','UTICE',
                'UTILE','VISLA','VISBO','VISDO','COSEX','LUCBR','PERCO','PERCU','DIFFR','PROGU','PROOL','DOLOR')");

        $select_evento->execute();
        $evento = $select_evento->fetchAll();


        foreach ($evento as $eventos) {

            if ($eventos["codigo_evento"] == $cod_event_dolor_cabeza) {

                $rowsToInsert[] = array(
                    'rela_tipo' => $dolor_cabeza,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_mareos) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $mareos,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_nauceas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $nauceas,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_vomito) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $vomito,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_fatiga_excesiva) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $fatiga_excesiva,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_urinaria) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $urinaria,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_problemas_instestinales) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $problemas_instestinales,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_debilidad_lado_cuerpo) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $debilidad_lado_cuerpo,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_problemas_motricidad) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $problemas_motricidad,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_temblores) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $temblores,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_inestabilidad_marcha) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $inestabilidad_marcha,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_tics_mov_extranos) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $tics_mov_extranos,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_problemas_equilibrio) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $cod_event_problemas_equilibrio,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }


            if ($eventos["codigo_evento"] == $cod_event_choque_cosas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $choque_cosas,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_desmayo) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $desmayo,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_perdida_sensibilidad) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $perdida_sensibilidad,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_cosquilleo_piel) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $cosquilleo_piel,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_ojos_claridad) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $ojos_claridad,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_perdida_audicion) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $perdida_audicion,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_utiliza_audifonos) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $utiliza_audifonos,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_zumbido) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $zumbido,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_anteojo_cerca) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $anteojo_cerca,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_anteojo_lejos) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $anteojo_lejos,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_vision_lado) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $vision_lado,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_vision_borrosa) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $vision_borrosa,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_vision_doble) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $vision_doble,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_cosas_no_existen) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $cosas_no_existen,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_sensibilidad_cosas_brillantes) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $sensibilidad_cosas_brillantes,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }
            if ($eventos["codigo_evento"] == $cod_event_periodos_ceguera) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $periodos_ceguera,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }
            if ($eventos["codigo_evento"] == $cod_event_persibe_cosas_cuerpo) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $persibe_cosas_cuerpo,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }
            if ($eventos["codigo_evento"] == $cod_event_dificultad_calor_frio) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $dificultad_calor_frio,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }
            if ($eventos["codigo_evento"] == $cod_event_problemas_gusto) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $problemas_gusto,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }
            if ($eventos["codigo_evento"] == $cod_event_problemas_olfato) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $problemas_olfato,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                );
            }
            if ($eventos["codigo_evento"] == $cod_event_dolor) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $dolor,
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
        pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());
         
        if ($recordatorio_medico <> null) {

        $rela_estado_recordatorio = 3;
        
        $data = [
            'rela_estado_recordatorio' => $rela_estado_recordatorio,
            'recordatorio_medico' => $recordatorio_medico,
        ];
        $update_estado_recordatorio = Flight::db()->prepare("UPDATE recordatorios_medicos
                SET rela_estado_recordatorio=:rela_estado_recordatorio
                WHERE id=:recordatorio_medico");

        $update_estado_recordatorio->execute($data);
        }
        
        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function respuesta_screening_animo()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_medico'])) {

        if ($_POST["id_medico"] === "null") {
            $id_medico = null;
        } else {
            $id_medico = $_POST["id_medico"];
        }
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['tipo_screening'])) {
        $tipo_screening = $_POST["tipo_screening"];
    } else {
        $tipo_screening = verificar($data_input, "tipo_screening");
    }

    if (isset($_POST['id_recordatorio'])) {

        if ($_POST["id_recordatorio"] === "null") {
            $recordatorio_medico = null;
        } else {
            $recordatorio_medico = $_POST["id_recordatorio"];
        }
    } else {
        $recordatorio_medico = verificar($data_input, "id_recordatorio");
    }


    $estado = 1;

    $result_screening = 0;

    // 1
    if (isset($_POST['satisfecho'])) {
        $satisfecho = $_POST["satisfecho"];
        if ($satisfecho == "978") {
            $result_screening += 1;
        }
    } else {
        $satisfecho = verificar($data_input, "satisfecho");
    }

    // 2
    if (isset($_POST['abandonado'])) {
        $abandonado = $_POST["abandonado"];
        if ($abandonado == "977") {
            $result_screening += 1;
        }
    } else {
        $abandonado = verificar($data_input, "abandonado");
    }

    // 3
    if (isset($_POST['vacia'])) {
        $vacia = $_POST["vacia"];
        if ($vacia == "977") {
            $result_screening += 1;
        }
    } else {
        $vacia = verificar($data_input, "vacia");
    }

    // 4
    if (isset($_POST['aburrida'])) {
        $aburrida = $_POST["aburrida"];
        if ($abandonado == "977") {
            $result_screening += 1;
        }
    } else {
        $aburrida = verificar($data_input, "aburrida");
    }

    // 5
    if (isset($_POST['humor'])) {
        $humor = $_POST["humor"];
        if ($humor == "978") {
            $result_screening += 1;
        }
    } else {
        $humor = verificar($data_input, "humor");
    }

    // 6
    if (isset($_POST['temor'])) {
        $temor = $_POST["temor"];
        if ($temor == "977") {
            $result_screening += 1;
        }
    } else {
        $temor = verificar($data_input, "temor");
    }
    
    //  7
    if (isset($_POST['feliz'])) {
        $feliz = $_POST["feliz"];
        if ($feliz == "978") {
            $result_screening += 1;
        }
    } else {
        $feliz = verificar($data_input, "feliz");
    }

    // 8
    if (isset($_POST['desamparado'])) {
        $desamparado = $_POST["desamparado"];
        
        if ($desamparado == "977") {
            $result_screening += 1;
        }
    } else {
        $desamparado = verificar($data_input, "desamparado");
    }
    // 9
    if (isset($_POST['prefiere'])) {
        $prefiere = $_POST["prefiere"];
        if ($prefiere == "977") {
            $result_screening += 1;
        }
    } else {
        $prefiere = verificar($data_input, "prefiere");
    }
    
    // 10
    if (isset($_POST['memoria'])) {
        $memoria = $_POST["memoria"];
        if ($memoria == "977") {
            $result_screening += 1;
        }
    } else {
        $memoria = verificar($data_input, "memoria");
    }

    // 11
    if (isset($_POST['estar_vivo'])) {
        $estar_vivo = $_POST["estar_vivo"];
        if ($estar_vivo == "978") {
            $result_screening += 1;
        }
    } else {
        $estar_vivo = verificar($data_input, "estar_vivo");
    }

    // 12
    if (isset($_POST['inutil'])) {
        $inutil = $_POST["inutil"];
        if ($inutil == "977") {
            $result_screening += 1;
        }
    } else {
        $inutil = verificar($data_input, "inutil");
    }

    // 13
    if (isset($_POST['energia'])) {
        $energia = $_POST["energia"];
        if ($energia == "978") {
            $result_screening += 1;
        }
    } else {
        $energia = verificar($data_input, "energia");
    }

    // 14

    if (isset($_POST['situacion'])) {
        $situacion = $_POST["situacion"];
        if ($situacion == "977") {
            $result_screening += 1;
        }
    } else {
        $situacion = verificar($data_input, "situacion");
    }
    
    // 15
    if (isset($_POST['situacion_mejor'])) {
        $situacion_mejor = $_POST["situacion_mejor"];
        if ($situacion_mejor == "977") {
            $result_screening += 1;
        }
    } else {
        $situacion_mejor = verificar($data_input, "situacion_mejor");
    }

    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

    $insert_resultado->bindParam(1, $tipo_screening);
    $insert_resultado->bindParam(2, $id_paciente);
    $insert_resultado->bindParam(3, $id_medico);
    $insert_resultado->bindParam(4, $result_screening);

    $insert_resultado->execute();

    $last->execute();

    $id_respuesta = $insert_resultado->fetch();
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
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
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
                    'rela_tipo' => $energia,
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
        $responseInsert = pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());

        if ($recordatorio_medico <> null) {
                $rela_estado_recordatorio = 3;
            
            
            $data = [
                'rela_estado_recordatorio' => $rela_estado_recordatorio,
                'recordatorio_medico' => $recordatorio_medico,
            ];
            $update_estado_recordatorio = Flight::db()->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");

            $update_estado_recordatorio->execute($data);
        }


        if ($responseInsert) {
            //array_push($lista, "Success", $result_screening);
            $returnData = msg("Success", $result_screening);
        } else {
            $returnData = msg("Success", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function respuesta_screening_cdr()
{


    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];


    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_medico'])) {
        if ($_POST["id_medico"] === "null") {
            $id_medico = null;
        } else {
            $id_medico = $_POST["id_medico"];
        }
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['id_recordatorio'])) {

        if ($_POST["id_recordatorio"] === "null") {
            $recordatorio_medico = null;
        } else {
            $recordatorio_medico = $_POST["id_recordatorio"];
        }
    } else {
        $recordatorio_medico = verificar($data_input, "id_recordatorio");
    }

    if (isset($_POST['tipo_screening'])) {
        $tipo_screening = $_POST["tipo_screening"];
    } else {
        $tipo_screening = verificar($data_input, "tipo_screening");
    }

   

    if (isset($_POST['memoria'])) {
        $memoria = $_POST["memoria"];
    } else {
        $memoria = verificar($data_input, "memoria");
    }

    if (isset($_POST['orientacion'])) {
        $orientacion = $_POST["orientacion"];
    } else {
        $orientacion = verificar($data_input, "orientacion");
    }

    if (isset($_POST['juicio_res_problema'])) {
        $juicio_res_problema = $_POST["juicio_res_problema"];
    } else {
        $juicio_res_problema = verificar($data_input, "juicio_res_problema");
    }

    if (isset($_POST['vida_social'])) {
        $vida_social = $_POST["vida_social"];
    } else {
        $vida_social = verificar($data_input, "vida_social");
    }

    if (isset($_POST['hogar'])) {
        $hogar = $_POST["hogar"];
    } else {
        $hogar = verificar($data_input, "hogar");
    }

    if (isset($_POST['cuid_personal'])) {
        $cuid_personal = $_POST["cuid_personal"];
    } else {
        $cuid_personal = verificar($data_input, "cuid_personal");
    }


    $estado = 1;


    $result_screening = 0;

    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

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
    $select_respuesta = Flight::db()->prepare("SELECT * FROM `tipos_respuestas` WHERE code
 IN ('TRES11','TRES12', 'TRES13', 'TRES14', 'TRES15', 'TRES16', 'TRES17','TRES18', 'TRES19', 'TRES20', 'TRES21','TRES22', 'TRES23', 'TRES24', 'TRES25', 'TRES26',
 'TRES27', 'TRES28','TRES29','TRES30', 'TRES31','TRES32', 'TRES33', 'TRES34', 'TRES35', 'TRES36','TRES37', 'TRES38', 'TRES39', 'TRES40')");

    $select_respuesta->execute();
    $respuesta = $select_respuesta->fetchAll();



    $lista = array();

    try {
        $fecha = date('Y/m/d');

        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
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
                            $result_screening += 0;
                        }

                        if ($respuestas['code'] == 'TRES12') {
                            $result_screening += 0.5;
                        }

                        if ($respuestas['code'] == 'TRES13') {
                            $result_screening += 0.5;
                        }

                        if ($respuestas['code'] == 'TRES14') {
                            $result_screening += 0.5;
                        }

                        if ($respuestas['code'] == 'TRES15') {
                            $result_screening += 1;
                        }

                        if ($respuestas['code'] == 'TRES16') {
                            $result_screening += 2;
                        }

                        if ($respuestas['code'] == 'TRES17') {
                            $result_screening += 3;
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
                            $result_screening += 0;
                        }

                        if ($respuestas['code'] == 'TRES19') {
                            $result_screening += 1;
                        }

                        if ($respuestas['code'] == 'TRES20') {
                            $result_screening += 2;
                        }

                        if ($respuestas['code'] == 'TRES21') {
                            $result_screening += 3;
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
                            $result_screening += 0;
                        }

                        if ($respuestas['code'] == 'TRES23') {
                            $result_screening += 0.5;
                        }

                        if ($respuestas['code'] == 'TRES24') {
                            $result_screening += 1;
                        }

                        if ($respuestas['code'] == 'TRES25') {
                            $result_screening += 2;
                        }
                        if ($respuestas['code'] == 'TRES26') {
                            $result_screening += 3;
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
                            $result_screening += 0;
                        }

                        if ($respuestas['code'] == 'TRES28') {
                            $result_screening += 0.5;
                        }

                        if ($respuestas['code'] == 'TRES29') {
                            $result_screening += 1;
                        }

                        if ($respuestas['code'] == 'TRES30') {
                            $result_screening += 2;
                        }
                        if ($respuestas['code'] == 'TRES31') {
                            $result_screening += 3;
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
                            $result_screening += 0;
                        }

                        if ($respuestas['code'] == 'TRES33') {
                            $result_screening += 0.5;
                        }

                        if ($respuestas['code'] == 'TRES34') {
                            $result_screening += 1;
                        }

                        if ($respuestas['code'] == 'TRES35') {
                            $result_screening += 2;
                        }
                        if ($respuestas['code'] == 'TRES36') {
                            $result_screening += 3;
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
                            $result_screening += 0;
                        }

                        if ($respuestas['code'] == 'TRES38') {
                            $result_screening += 1;
                        }

                        if ($respuestas['code'] == 'TRES39') {
                            $result_screening += 2;
                        }

                        if ($respuestas['code'] == 'TRES40') {
                            $result_screening += 3;
                        }
                    }
                }
            }
        }

        $data = [
            'result_screening' => $result_screening,
            'id_respuesta' => $id_respuesta,
        ];

        $update_resultado = Flight::db()->prepare("UPDATE resultados_screenings
                    SET result_screening=:result_screening
                    WHERE id=:id_respuesta");

        $update_resultado->execute($data);

        pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());

        if ($recordatorio_medico <> null) {
            $rela_estado_recordatorio = 3 ;
            
            $data = [
                'rela_estado_recordatorio' => $rela_estado_recordatorio,
                'recordatorio_medico' => $recordatorio_medico,
            ];
            $update_estado_recordatorio = Flight::db()->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");

            $update_estado_recordatorio->execute($data);
        }

        if ($result_screening > 1) {
            $returnData = msg("Success", "Alert");
        } else {
            $returnData = msg("Success", "");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_respuesta_conductual()
{

    try {
        if (isset($_POST['otro'])) {
            $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES46','TRES47','TRES48')");
        } else {
            $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES41','TRES42','TRES43','TRES44','TRES45')");
        }

        $stmt->execute();
        $result = $stmt->fetchAll();
        //var_dump($result);
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_eventos_nutricional()
{

    try {
        
        $stmt = Flight::db()->prepare("SELECT * FROM eventos WHERE codigo_evento LIKE 'NUTRI%'");

        $stmt->execute();
        $result = $stmt->fetchAll();
        //var_dump($result);
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_eventos_animo()
{

    try {
        
        $stmt = Flight::db()->prepare("SELECT * FROM eventos WHERE codigo_evento LIKE 'ANI%'");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();

        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_eventos_fisico()
{

    try {
        
         // SELECCION DE EVENTOS
         $stmt = Flight::db()->prepare("SELECT * FROM eventos WHERE codigo_evento
         IN ('DOLCA','MAREO','NAUS','VOM','FATEX','INCUR','PROMI','DEBCU','PROMF','TEMBL','INMAR',
         'TICS','PEQUI','FRECC','DESMA','CAIDA','PESEN','COSQP','NECCL','PERAU','UTAUD','ZUMB','UTICE',
         'UTILE','VISLA','VISBO','VISDO','COSEX','LUCBR','PERCO','PERCU','DIFFR','PROGU','PROOL','DOLOR')");

        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();

        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function respuesta_screening_conductual()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_conductual1'])) {
        $id_conductual1 = $_POST["id_conductual1"];
    } else {
        $id_conductual1 = verificar($data_input, "id_conductual1");
    }

    if (isset($_POST['id_conductual2'])) {
        $id_conductual2 = $_POST["id_conductual2"];
    } else {
        $id_conductual2 = verificar($data_input, "id_conductual2");
    }

    if (isset($_POST['id_conductual3'])) {
        $id_conductual3 = $_POST["id_conductual3"];
    } else {
        $id_conductual3 = verificar($data_input, "id_conductual3");
    }

    if (isset($_POST['id_conductual4'])) {
        $id_conductual4 = $_POST["id_conductual4"];
    } else {
        $id_conductual4 = verificar($data_input, "id_conductual4");
    }

    if (isset($_POST['id_conductual5'])) {
        $id_conductual5 = $_POST["id_conductual5"];
    } else {
        $id_conductual5 = verificar($data_input, "id_conductual5");
    }

    if (isset($_POST['id_conductual6'])) {
        $id_conductual6 = $_POST["id_conductual6"];
    } else {
        $id_conductual6 = verificar($data_input, "id_conductual6");
    }

    if (isset($_POST['id_conductual7'])) {
        $id_conductual7 = $_POST["id_conductual7"];
    } else {
        $id_conductual7 = verificar($data_input, "id_conductual7");
    }

    if (isset($_POST['id_conductual8'])) {
        $id_conductual8 = $_POST["id_conductual8"];
    } else {
        $id_conductual8 = verificar($data_input, "id_conductual8");
    }

    if (isset($_POST['id_conductual9'])) {
        $id_conductual9 = $_POST["id_conductual9"];
    } else {
        $id_conductual9 = verificar($data_input, "id_conductual9");
    }

    if (isset($_POST['id_conductual10'])) {
        $id_conductual10 = $_POST["id_conductual10"];
    } else {
        $id_conductual10 = verificar($data_input, "id_conductual10");
    }

    if (isset($_POST['id_conductual11'])) {
        $id_conductual11 = $_POST["id_conductual11"];
    } else {
        $id_conductual11 = verificar($data_input, "id_conductual11");
    }

    if (isset($_POST['id_conductual12'])) {
        $id_conductual12 = $_POST["id_conductual12"];
    } else {
        $id_conductual12 = verificar($data_input, "id_conductual12");
    }

    if (isset($_POST['id_conductual13'])) {
        $id_conductual13 = $_POST["id_conductual13"];
    } else {
        $id_conductual13 = verificar($data_input, "id_conductual13");
    }
    $otro_observaciones = "";
    if (isset($_POST['observaciones'])) {
        $otro_observaciones = $_POST["observaciones"];
        $otro_observaciones = $otro_observaciones == "" ? null : $otro_observaciones;
    } else {
        $otro_observaciones = $otro_observaciones == "" ? null : $otro_observaciones;
        $otro_observaciones = verificar($data_input, "observaciones");
    }

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_medico'])) {
        if ($_POST["id_medico"] === "null") {
            $id_medico = null;
        } else {
            $id_medico = $_POST["id_medico"];
        }
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['tipo_screening'])) {
        $tipo_screening = $_POST["tipo_screening"];
    } else {
        $tipo_screening = verificar($data_input, "tipo_screening");
    }

    if (isset($_POST['id_recordatorio'])) {
        if ($_POST["id_recordatorio"] === "null") {
            $recordatorio_medico = null;
        } else {
            $recordatorio_medico = $_POST["id_medico"];
        }
    } else {
        $recordatorio_medico = verificar($data_input, "id_recordatorio");
    }


    $estado = 1;

    $result_screening = 0;


    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

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
    $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
    IN ('COND1','COND2','COND3','COND4','COND5','COND6','COND7','COND8','COND9','COND10','COND11','COND12','COND13')");

    $select_evento->execute();
    $evento = $select_evento->fetchAll();
    //-----------------------------------------------------

    // SELECCION DE CODE "Otro"----------------------------
    $select_code = Flight::db()->prepare("SELECT id FROM `tipos_respuestas` WHERE id = '" . $id_conductual1 . "' ");

    $select_code->execute();
    $select_code = $select_code->fetch();

    //----------------------------------------------------

    $resp_no_code = Flight::db()->prepare("SELECT id FROM `tipos_respuestas` WHERE code = 'TRES45'");

    $resp_no_code->execute();
   // $resp_no_code = $resp_no_code->fetch();
    $resp_no_code = (string) $resp_no_code->fetch()['id'];

    try {
        $fecha = date('Y/m/d');

        foreach ($evento as $eventos) {

            if ($eventos["codigo_evento"] == "COND1") {

                if ($select_code == 'TRES48') {
                    $observaciones = $otro_observaciones;
                } else {
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

        $data_resultados_screenings = [
            'result_screening' => $result_screening,
            'id_respuesta' => $id_respuesta,
        ];

        $update_resultado = Flight::db()->prepare("UPDATE resultados_screenings
                    SET result_screening=:result_screening
                    WHERE id=:id_respuesta");

        $update_resultado->execute($data_resultados_screenings);

        //Call our custom function.
        pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());


        if ($recordatorio_medico <> null) {
                $rela_estado_recordatorio = 3;
            
            $data_recordatorios_medicos = [
                'rela_estado_recordatorio' => $rela_estado_recordatorio,
                'recordatorio_medico' => $recordatorio_medico,
            ];

            $update_estado_recordatorio = Flight::db()->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");

            $update_estado_recordatorio->execute($data_recordatorios_medicos);
        }

        if ($result_screening > 4) {
            $returnData = msg("Success", "alert");
        } else {
            $returnData = msg("Success", "");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function respuesta_screening_nutricional()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_medico'])) {
        if ($_POST['id_medico'] === "null") {
            $id_medico = null;
        } else {
            $id_medico = $_POST['id_medico'];
        }
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['tipo_screening'])) {
        $tipo_screening = $_POST["tipo_screening"];
    } else {
        $tipo_screening = verificar($data_input, "tipo_screening");
    }

    if (isset($_POST['id_recordatorio'])) {
        if ($_POST['id_recordatorio'] === "null") {
            $recordatorio_medico = null;
        } else {
            $recordatorio_medico = $_POST['id_recordatorio'];
        }
    } else {
        $recordatorio_medico = verificar($data_input, "id_recordatorio");
    }

    $estado = 1;


    $result_screening = 0;


    if ($_POST['nutri1'] == "977") {
        $nutri1 = 1;
        $result_screening += 2;
    } else {
        $nutri1 = 0;
    }

    if ($_POST['nutri2'] == "977") {
        $nutri2 = 1;
        $result_screening += 3;
    } else {
        $nutri2 = 0;
    }

    if ($_POST['nutri3'] == "977") {
        $nutri3 = 1;
        $result_screening += 2;
    } else {
        $nutri3 = 0;
    }

    if ($_POST['nutri4'] == "977") {
        $nutri4 = 1;
        $result_screening += 2;
    } else {
        $nutri4 = 0;
    }

    if ($_POST['nutri5'] == "977") {
        $nutri5 = 1;
        $result_screening += 2;
    } else {
        $nutri5 = 0;
    }


    if ($_POST['nutri6'] == "977") {
        $nutri6 = 1;
        $result_screening += 4;
    } else {
        $nutri6 = 0;
    }

    if ($_POST['nutri7'] == "977") {
        $nutri7 = 1;
        $result_screening += 1;
    } else {
        $nutri7 = 0;
    }

    if ($_POST['nutri8'] == "977") {
        $nutri8 = 1;
        $result_screening += 1;
    } else {
        $nutri8 = 0;
    }

    // if ($_POST['nutri81'] == "977") {
    //     $nutri81 = 1;
    //     $result_screening += 1;
    // } else {
    //     $nutri81 = 0;
    // }

    if ($_POST['nutri9'] == "977") {
        $nutri9 = 1;
        $result_screening += 2;
    } else {
        $nutri9 = 0;
    }

    // if ($_POST['nutri91'] == "977") {
    //     $nutri91 = 1;
    //     $result_screening += 2;
    // } else {
    //     $nutri91 = 0;
    // }

    if ($_POST['nutri10'] == "977") {
        $nutri10 = 1;
        $result_screening += 2;
    } else {
        $nutri10 = 0;
    }

    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

    $insert_resultado->bindParam(1, $tipo_screening);
    $insert_resultado->bindParam(2, $id_paciente);
    $insert_resultado->bindParam(3, $id_medico);
    $insert_resultado->bindParam(4, $result_screening);

    $insert_resultado->execute();
    $last->execute();

    $last = $last->fetch();
    $id_respuesta = $last["id"];

    //--------------------------------------------------

    if (isset($_POST['cod_event_nutri1'])) {
        $cod_event_nutri1 = $_POST["cod_event_nutri1"];
    } else {
        $cod_event_nutri1 = verificar($data_input, "cod_event_nutri1");
    }
    if (isset($_POST['cod_event_nutri2'])) {
        $cod_event_nutri2 = $_POST["cod_event_nutri2"];
    } else {
        $cod_event_nutri2 = verificar($data_input, "cod_event_nutri2");
    }
    if (isset($_POST['cod_event_nutri3'])) {
        $cod_event_nutri3 = $_POST["cod_event_nutri3"];
    } else {
        $cod_event_nutri3 = verificar($data_input, "cod_event_nutri3");
    }
    if (isset($_POST['cod_event_nutri4'])) {
        $cod_event_nutri4 = $_POST["cod_event_nutri4"];
    } else {
        $cod_event_nutri4 = verificar($data_input, "cod_event_nutri4");
    }
    if (isset($_POST['cod_event_nutri5'])) {
        $cod_event_nutri5 = $_POST["cod_event_nutri5"];
    } else {
        $cod_event_nutri5 = verificar($data_input, "cod_event_nutri5");
    }
    if (isset($_POST['cod_event_nutri6'])) {
        $cod_event_nutri6 = $_POST["cod_event_nutri6"];
    } else {
        $cod_event_nutri6 = verificar($data_input, "cod_event_nutri6");
    }
    if (isset($_POST['cod_event_nutri7'])) {
        $cod_event_nutri7 = $_POST["cod_event_nutri7"];
    } else {
        $cod_event_nutri7 = verificar($data_input, "cod_event_nutri7");
    }
    if (isset($_POST['cod_event_nutri8'])) {
        $cod_event_nutri8 = $_POST["cod_event_nutri8"];
    } else {
        $cod_event_nutri8 = verificar($data_input, "cod_event_nutri8");
    }
    // if (isset($_POST['cod_event_nutri81'])) {
    //     $cod_event_nutri81 = $_POST["cod_event_nutri81"];
    // } else {
    //     $cod_event_nutri81 = verificar($data_input, "cod_event_nutri81");
    // }
    if (isset($_POST['cod_event_nutri9'])) {
        $cod_event_nutri9 = $_POST["cod_event_nutri9"];
    } else {
        $cod_event_nutri9 = verificar($data_input, "cod_event_nutri9");
    }
    // if (isset($_POST['cod_event_nutri91'])) {
    //     $cod_event_nutri91 = $_POST["cod_event_nutri91"];
    // } else {
    //     $cod_event_nutri91 = verificar($data_input, "cod_event_nutri91");
    // }
    if (isset($_POST['cod_event_nutri10'])) {
        $cod_event_nutri10 = $_POST["cod_event_nutri10"];
    } else {
        $cod_event_nutri10 = verificar($data_input, "cod_event_nutri10");
    }


    try {

        $fecha = date('Y/m/d');

        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
                    IN ('NUTRI1','NUTRI2','NUTRI3','NUTRI4','NUTRI5','NUTRI6','NUTRI7','NUTRI8','NUTRI81','NUTRI9','NUTRI91','NUTRI10')");

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

            // if ($eventos["codigo_evento"] == $cod_event_nutri81) {
            //     $rowsToInsert[] = array(
            //         'rela_tipo' => $nutri81,
            //         'rela_evento' => $eventos["id"],
            //         'rela_tipo_screening' => $tipo_screening,
            //         'rela_recordatorio_medico' => $recordatorio_medico,
            //         'rela_paciente' => $id_paciente,
            //         'estado' => $estado,
            //         'fecha_alta' => $fecha,
            //         'rela_resultado' => $id_respuesta,
            //     );
            // }

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

            // if ($eventos["codigo_evento"] == $cod_event_nutri91) {
            //     $rowsToInsert[] = array(
            //         'rela_tipo' => $nutri91,
            //         'rela_evento' => $eventos["id"],
            //         'rela_tipo_screening' => $tipo_screening,
            //         'rela_recordatorio_medico' => $recordatorio_medico,
            //         'rela_paciente' => $id_paciente,
            //         'estado' => $estado,
            //         'fecha_alta' => $fecha,
            //         'rela_resultado' => $id_respuesta,
            //     );
            // }

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


        pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());

        if ($recordatorio_medico <> null) {

            $rela_estado_recordatorio = 3;

            $data = [
                'rela_estado_recordatorio' => $rela_estado_recordatorio,
                'recordatorio_medico' => $recordatorio_medico,
            ];

            $update_estado_recordatorio = Flight::db()->prepare("UPDATE recordatorios_medicos
                        SET rela_estado_recordatorio=:rela_estado_recordatorio
                        WHERE id=:recordatorio_medico");

            $update_estado_recordatorio->execute($data);
        }

        if ($result_screening <= 2) {
            $returnData = msg("Success", "Buen Estado nutricional");
        }

        if ($result_screening >= 3) {
            if ($result_screening <= 5) {
                $returnData = msg("Success", "Moderado Riesgo nutricional");
            }
        }

        if ($result_screening >= 6) {
            $returnData = msg("Success", "Alto Riesgo nutricional");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_respuesta_quejas()
{
    try {
        $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES3','TRES7','TRES8','TRES10','TRES9')");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_respuesta_animo()
{
    try {
        $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('SCER60','SCER61')");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}


function respuesta_screening_adlq()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    $id_paciente = $_POST['id_paciente'];

    if ($_POST['id_medico'] === "null") {
        $id_medico = null;
    } else {
        $id_medico = $_POST['id_medico'];
    }

    if ($_POST['id_recordatorio'] === "null") {
        $recordatorio_medico = null;
    } else {
        $recordatorio_medico = $_POST['id_recordatorio'];
    }

    $id_alimentacion = $_POST['id_alimentacion'];
    $id_vestimenta = $_POST['id_vestimenta'];
    $id_arreglos_hogar = $_POST['id_arreglos_hogar'];
    $id_aspecto_personal = $_POST['id_aspecto_personal'];

    $id_bano = $_POST['id_bano'];
    $id_comprar_comida = $_POST['id_comprar_comida'];
    $id_comprension = $_POST['id_comprension'];
    $id_conducir = $_POST['id_conducir'];
    $id_conversacion = $_POST['id_conversacion'];
    $id_cuidado_hogar = $_POST['id_cuidado_hogar'];
    $id_empleo = $_POST['id_empleo'];
    $id_escritura = $_POST['id_escritura'];
    $id_evacuacion = $_POST['id_evacuacion'];
    $id_lavado_ropa = $_POST['id_lavado_ropa'];
    $id_lectura = $_POST['id_lectura'];
    $id_manejo_efectivo = $_POST['id_manejo_efectivo'];
    $id_manejo_finanzas = $_POST['id_manejo_finanzas'];
    $id_mantenimiento_hogar = $_POST['id_mantenimiento_hogar'];
    $id_movilidad_barrio = $_POST['id_movilidad_barrio'];
    $id_poner_mesa = $_POST['id_poner_mesa'];
    $id_prepara_comida = $_POST['id_prepara_comida'];
    $id_recreacion = $_POST['id_recreacion'];
    $id_reuniones = $_POST['id_reuniones'];
    $id_tomar_medicacion = $_POST['id_tomar_medicacion'];
    $id_transporte_publico = $_POST['id_transporte_publico'];
    $id_uso_telefono = $_POST['id_uso_telefono'];
    $id_viaje_fuera_ambiente = $_POST['id_viaje_fuera_ambiente'];
    $id_viajes = $_POST['id_viajes'];

    
    $tipo_screening = $_POST['tipo_screening'];
    $estado = 1;

    $randomNumber = mt_rand(2, 32);

    $result_screening = $randomNumber;
    

    // CALCULO DE RESULTADO

    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

    $insert_resultado->bindParam(1, $tipo_screening);
    $insert_resultado->bindParam(2, $id_paciente);
    $insert_resultado->bindParam(3, $id_medico);
    $insert_resultado->bindParam(4, $result_screening);

    $insert_resultado->execute();
    $last->execute();

    $last = $last->fetch();
    $id_respuesta = $last["id"];

    
        //--------------------------------------------------
        $select_evento = Flight::db()->prepare("SELECT * FROM eventos WHERE codigo_evento LIKE 'ADLQ%'");
        $select_evento->execute();
        
        $select_evento->execute();
        $evento = $select_evento->fetchAll();

    try {
        $fecha = date('Y/m/d');

        $id_respuesta = 0;

        foreach ($evento as $eventos) {

            if ($eventos["codigo_evento"] == "ADLQALI") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_alimentacion,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQVES") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_vestimenta,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQBAN") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_bano,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQEVA") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_evacuacion,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQTM") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_tomar_medicacion,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQIAP") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_aspecto_personal,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQPCC") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_prepara_comida,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

             if ($eventos["codigo_evento"] == "ADLQPM") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_poner_mesa,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQCH") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_cuidado_hogar,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQMH") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_mantenimiento_hogar,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQAH") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_arreglos_hogar,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQLR") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_lavado_ropa,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQEMP") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_empleo,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQREC") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_recreacion,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQREU") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_reuniones,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQVIA") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_viajes,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQCC") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_comprar_comida,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQMEF") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_manejo_efectivo,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQMFIN") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_manejo_finanzas,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQTM") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_transporte_publico,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQCON") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_conducir,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQMB") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_movilidad_barrio,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQVFF") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_viaje_fuera_ambiente,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQUT") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_uso_telefono,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQCONV") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_conversacion,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQCOM") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_comprension,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQLEC") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_lectura,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,

                );
            }

            if ($eventos["codigo_evento"] == "ADLQESC") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_escritura,
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
        pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());

        if ($recordatorio_medico <> null) {
            $rela_estado_recordatorio = 3;

            $data = [
                'rela_estado_recordatorio' => $rela_estado_recordatorio,
                'recordatorio_medico' => $recordatorio_medico,
            ];

            $update_estado_recordatorio = Flight::db()->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");

            $update_estado_recordatorio->execute($data);
        }

        // if ($result_screening > 20) {
        //     $returnData = msg("Success", "alert");
        // } else {
            $returnData = msg("Success", []);
        //}

    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function respuesta_screening_cerebral()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    $id_paciente = $_POST['id_paciente'];

    if ($_POST['id_medico'] === "null") {
        $id_medico = null;
    } else {
        $id_medico = $_POST['id_medico'];
    }

    if ($_POST['id_recordatorio'] === "null") {
        $recordatorio_medico = null;
    } else {
        $recordatorio_medico = $_POST['id_recordatorio'];
    }

    $actividad_fisica = $_POST['actividad_fisica'] == "true" ? 1 : 0;
    $alimentacion_saludable = $_POST['alimentacion_saludable'] == "true" ? 1 : 0;
    $contacto_social = $_POST['contacto_social'] == "true" ? 1 : 0;
    $sueno = $_POST['sueno'] == "true" ? 1 : 0;
    $actividades_esfuerzo_mental = $_POST['actividades_esfuerzo_mental'] == "true" ? 1 : 0;
    $otro = $_POST['otro'] == "true" ? 1 : 0;

    $otro_texto = "";
    if (isset($_POST['otro_texto'])) {
        $otro_texto = $_POST["otro_texto"];
        $otro_texto = $otro_texto == "" ? null : $otro_texto;
    } else {
        $otro_texto = $otro_texto == "" ? null : $otro_texto;
        $otro_observaciones = verificar($data_input, "otro_texto");
    }

    $id_actividad_fisica_moderada = $_POST['id_actividad_fisica_moderada'];
    $id_actividad_fisica_minutos = $_POST['id_actividad_fisica_minutos'];
    $id_persona_mantenida_10anos = $_POST['id_persona_mantenida_10anos'];
    $id_persona_activa_vida = $_POST['id_persona_activa_vida'];
    $id_dias_alimenta_saludable = $_POST['id_dias_alimenta_saludable'];
    $id_alimenta_saludable_vida = $_POST['id_alimenta_saludable_vida'];
    $id_contacto_social_amigos = $_POST['id_contacto_social_amigos'];
    $id_contacto_social_actividad = $_POST['id_contacto_social_actividad'];
    $id_sueno_calidad_sueno = $_POST['id_sueno_calidad_sueno'];
    $id_sueno_despierto_dia = $_POST['id_sueno_despierto_dia'];
    $id_sueno_siesta_dia = $_POST['id_sueno_siesta_dia'];
    $id_sueno_duerme = $_POST['id_sueno_duerme'];    
    $id_sueno_duerme_noche = $_POST['id_sueno_duerme_noche'];
    $id_sueno_hora_noche = $_POST['id_sueno_hora_noche'];
    $id_actividades_esfuerzo_mental = $_POST['id_actividades_esfuerzo_mental'];
    $id_actividad_indole_cultural = $_POST['id_actividad_indole_cultural'];
    $id_esperanza_habito_saludable = $_POST['id_esperanza_habito_saludable'];

    
    $tipo_screening = $_POST['tipo_screening'];
    $estado = 1;

    $randomNumber = mt_rand(3, 30);

    $result_screening = $randomNumber;

    // CALCULO DE RESULTADO

    // Array de IDs de usuarios
   
    // $respuestasAcum = [$id_actividad_fisica_moderada, $id_actividad_fisica_minutos, $id_persona_mantenida_10anos, 
    // $id_persona_activa_vida];

    // Construir la cláusula IN
    //$inClause = implode(',', $respuestasAcum);

    // Consulta SQL con la cláusula WHERE utilizando IN
    //$sql = "SELECT ponderacion FROM tipos_respuestas WHERE id IN ($inClause)";

    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

    $insert_resultado->bindParam(1, $tipo_screening);
    $insert_resultado->bindParam(2, $id_paciente);
    $insert_resultado->bindParam(3, $id_medico);
    $insert_resultado->bindParam(4, $result_screening);

    $insert_resultado->execute();
    $last->execute();

    $last = $last->fetch();
    $id_respuesta = $last["id"];

    
        //--------------------------------------------------
        $select_evento = Flight::db()->prepare("SELECT * FROM eventos WHERE codigo_evento LIKE 'ECER%'");
        $select_evento->execute();
        
        $select_evento->execute();
        $evento = $select_evento->fetchAll();
        

    try {
        $fecha = date('Y/m/d');

        $id_respuesta = 0;

        foreach ($evento as $eventos) {
            
            if ($eventos["codigo_evento"] === "ECER1") {
               
                if ($otro == 1) {
                    $observaciones = $otro_texto;
                } else {
                    $observaciones = null;
                }

                $rowsToInsert[] = array(
                    'rela_tipo' => $actividad_fisica,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => $observaciones,

                );

                $rowsToInsert[] = array(
                    'rela_tipo' => $alimentacion_saludable,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => $observaciones,

                );

                $rowsToInsert[] = array(
                    'rela_tipo' => $contacto_social,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => $observaciones,

                );

                $rowsToInsert[] = array(
                    'rela_tipo' => $sueno,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => $observaciones,

                );

                $rowsToInsert[] = array(
                    'rela_tipo' => $actividades_esfuerzo_mental,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => $observaciones,

                );

                $rowsToInsert[] = array(
                    'rela_tipo' => $otro,
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

            if ($eventos["codigo_evento"] == "ECER2") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_actividad_fisica_moderada,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER3") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_actividad_fisica_minutos,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER4") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_persona_mantenida_10anos,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER5") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_persona_activa_vida,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER6") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_dias_alimenta_saludable,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER7") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_alimenta_saludable_vida,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

             if ($eventos["codigo_evento"] == "ECER8") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_contacto_social_amigos,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER9") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_contacto_social_actividad,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER10") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_sueno_calidad_sueno,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER11") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_sueno_despierto_dia,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER12") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_sueno_siesta_dia,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER13") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_sueno_duerme,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER14") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_sueno_duerme_noche,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER15") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_sueno_hora_noche,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER16") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_actividades_esfuerzo_mental,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER17") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_actividad_indole_cultural,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER18") {

                $rowsToInsert[] = array(
                    'rela_tipo' => $id_esperanza_habito_saludable,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

            if ($eventos["codigo_evento"] == "ECER19") {

                $rowsToInsert[] = array(
                    'rela_tipo' => null,
                    'rela_evento' => $eventos["id"],
                    'rela_tipo_screening' => $tipo_screening,
                    'rela_recordatorio_medico' => $recordatorio_medico,
                    'rela_paciente' => $id_paciente,
                    'estado' => $estado,
                    'fecha_alta' => $fecha,
                    'rela_resultado' => $id_respuesta,
                    'observacion' => null,

                );
            }

        }
     
        //Call our custom function.
        pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());

        // if ($result_screening > 20) {
        //     $returnData = msg("Success", "alert");
        // } else {
            $returnData = msg("Success", "alert");
        //}

    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}


function respuesta_screening_quejas()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

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

    if ($_POST['id_medico'] === "null") {
        $id_medico = null;
    } else {
        $id_medico = $_POST['id_medico'];
    }

    if ($_POST['id_recordatorio'] === "null") {
        $recordatorio_medico = null;
    } else {
        $recordatorio_medico = $_POST['id_recordatorio'];
    }


    $tipo_screening = $_POST['tipo_screening'];
    $estado = 1;


    // CALCULO DE RESULTADO

    $result_screening = 0;


    //--------------------------------------------------
    $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES3','TRES7','TRES8','TRES10','TRES9')");
    $stmt->execute();
    $result = $stmt->fetchAll();
    $lista = array();
    if ($stmt->rowCount() > 0) {
        foreach ($result as $results) {
            $lista[] = $results;
        }
    }

    foreach ($lista as $respuesta) {
        if ($id_ate1 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }
        if ($id_ate2 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }
        if ($id_ate3 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }
        if ($id_ate4 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_ori1 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_ori2 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_ori3 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_ori4 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_funejec1 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_funejec2 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_funejec3 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_funejec4 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_memoria1 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_memoria2 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_memoria3 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_memoria4 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }


        if ($id_prexgnosia1 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_prexgnosia2 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_prexgnosia3 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_prexgnosia4 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_leng1 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_leng2 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_leng3 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }

        if ($id_leng4 == $respuesta['id']) {
            $result_screening += $respuesta['ponderacion'];
        }
    }


    //--------------------------------------------------


    // Guardamos el resultado del screening

    $insert_resultado = Flight::db()->prepare('INSERT INTO resultados_screenings(rela_screening,rela_paciente,rela_medico,result_screening)VALUES(?,?,?,?)');
    $last = Flight::db()->prepare('SELECT LAST_INSERT_ID() as id');

    $insert_resultado->bindParam(1, $tipo_screening);
    $insert_resultado->bindParam(2, $id_paciente);
    $insert_resultado->bindParam(3, $id_medico);
    $insert_resultado->bindParam(4, $result_screening);

    $insert_resultado->execute();
    $last->execute();

    $last = $last->fetch();
    $id_respuesta = $last["id"];


    // SELECCION DE EVENTOS
    $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos` WHERE codigo_evento
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
        pdoMultiInsert('respuesta_screening', $rowsToInsert, Flight::db());

        if ($recordatorio_medico <> null) {
            $rela_estado_recordatorio = 3;

            $data = [
                'rela_estado_recordatorio' => $rela_estado_recordatorio,
                'recordatorio_medico' => $recordatorio_medico,
            ];

            $update_estado_recordatorio = Flight::db()->prepare("UPDATE recordatorios_medicos
                    SET rela_estado_recordatorio=:rela_estado_recordatorio
                    WHERE id=:recordatorio_medico");

            $update_estado_recordatorio->execute($data);
        }

        if ($result_screening > 20) {
            $returnData = msg("Success", "mas_20");
        } else {
            $returnData = msg("Success", "menos_20");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_respuesta_cdr()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['estado'])) {
        $estado = $_POST["estado"];
    } else {
        $estado = verificar($data_input, "estado");
    }

    try {
        if ($estado == "M") {
            $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES11','TRES12', 'TRES13', 'TRES14', 'TRES15', 'TRES16', 'TRES17')");
        } else {
            if ($estado == "O") {
                $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES18', 'TRES19', 'TRES20', 'TRES21')");
            } else {
                if ($estado == "Q") {
                    $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES22', 'TRES23', 'TRES24', 'TRES25', 'TRES26')");
                } else {
                    if ($estado == "V") {
                        $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES27', 'TRES28','TRES29','TRES30', 'TRES31')");
                    } else {
                        if ($estado == "H") {
                            $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES32', 'TRES33', 'TRES34', 'TRES35', 'TRES36')");
                        } else {
                            if ($estado == "CP") {
                                $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES37', 'TRES38', 'TRES39', 'TRES40')");
                            }
                        }
                    }
                }
            }
        }

        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}


function tipo_respuesta_adlq()
{

    try {
       
        $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code LIKE 'ADLQ%'");


        $stmt->execute();
        $result = $stmt->fetchAll();
        //var_dump($result);
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function tipo_respuesta_salud_cerebral()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    $id_screening = 9;

    try {

        $stmt = Flight::db()->prepare("SELECT * FROM resultados_screenings 
        WHERE `rela_paciente` = '" . $id_paciente . "' AND `rela_screening` = '" . $id_screening . "'");

        $stmt->execute();
        $result = $stmt->fetchAll();
        //var_dump($result);
        $lista = array();
        if ($stmt->rowCount() == 0) {
           
        $stmt_tipo_cerebral = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code LIKE 'SCER%'");

        $stmt_tipo_cerebral->execute();
        $result = $stmt_tipo_cerebral->fetchAll();
        $lista = array();
        if ($stmt_tipo_cerebral->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
        } else {
            
            $returnData = msg("SinScreening", $result);
        }

    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function get_state_sreening_cerebral(){
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    $id_screening = 9;

    try {
       
        $stmt = Flight::db()->prepare("SELECT * FROM resultados_screenings 
        WHERE `rela_paciente` = '" . $id_paciente . "' AND `rela_screening` = '" . $id_screening . "'");

        $stmt->execute();
        $result = $stmt->fetchAll();
        //var_dump($result);
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}


function user_register()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    if (isset($_POST['password'])) {
        $password = $_POST["password"];
    } else {
        $password = verificar($data_input, "password");
    }

    if (isset($_POST['nombre'])) {
        $nombre = $_POST["nombre"];
    } else {
        $nombre = verificar($data_input, "nombre");
    }

    if (isset($_POST['apellido'])) {
        $apellido = $_POST["apellido"];
    } else {
        $apellido = verificar($data_input, "apellido");
    }

    if (isset($_POST['dni'])) {
        $dni = $_POST["dni"];
    } else {
        $dni = verificar($data_input, "dni");
    }


    $estado_users = '1';
    $rela_rol = 0;

    try {

        $token = uniqid(random_int(100, 999), true);

        // Limpiar los espacios en blanco
         $email = trim($email);

        $lista = array();

        $query = "SELECT email FROM users WHERE email = :email";
        $stmt = Flight::db()->prepare($query);
        $stmt->bindParam(":email", $email);
        $stmt->execute();
        $result = $stmt->rowCount();


        $query = "SELECT * FROM pacientes WHERE dni = :dni";
        $stmt_dni = Flight::db()->prepare($query);
        $stmt_dni->bindParam(":dni", $dni);
        $stmt_dni->execute();
        $result_dni = $stmt_dni->rowCount();

        if ($result_dni > 0) {
        
        $returnData = msg("Vacio", "Ya existe un paciente con ese DNI");
        Flight::json($returnData);
        exit;
        }
        
        if ($result == 1) {
            $lista = "Ya existe un paciente con ese EMAIL";
            
            $returnData = msg("Vacio", $lista);

        } else {

            $stmt = Flight::db()->prepare('INSERT INTO users(email,password,token) VALUES(?, ?, ?)');
            $stmt->bindParam(1, $email);
            $stmt->bindParam(2, $password);
            $stmt->bindParam(3, $token);

            $stmt->execute();

            $result = $stmt->rowCount();
            if ($result) {
                $select_email = Flight::db()->prepare("SELECT id FROM users WHERE email = '" . $email . "'");
                $select_email->execute();
                $rela_users = $select_email->fetch();

                $insert_paciente = Flight::db()->prepare('INSERT INTO pacientes(rela_users,nombre,apellido,estado_users,dni)VALUES(?,?,?,?,?)');

                $insert_paciente->bindParam(1, $rela_users['id']);
                $insert_paciente->bindParam(2, $nombre);
                $insert_paciente->bindParam(3, $apellido);
                $insert_paciente->bindParam(4, $estado_users);
                $insert_paciente->bindParam(5, $dni);
                $insert_paciente->execute();

                $lastInsertedId = Flight::db()->lastInsertId();


                $insert_paciente = $stmt->rowCount();
                if ($insert_paciente) {

                    $lista = array(
                        "request" => "Success",
                        "token" => $token,
                        "email" => $email,
                        "password" => $password,
                        "paciente" => [
                            "id_paciente"=>$lastInsertedId,
                            "rela_users" => $rela_users,
                            "nombre" => $nombre,
                            "apellido" => $apellido,
                            "dni" => $dni,
                            "estado_users" => $estado_users
                        ]
                    );
                    $returnData = msg("Success", $lista);
                } else {
                    $returnData = msg("Success", "No se pudo realizar el registro");
                }
            }
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function screenings()
{

    $returnData = [];

    try {
        $stmt = Flight::db()->prepare("SELECT * FROM tipo_screening");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", "");
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_code_screening()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_screening'])) {
        $id_screening = $_POST["id_screening"];
    } else {
        $id_screening = verificar($data_input, "id_screening");
    }

    try {
        $codigo_screening = Flight::db()->prepare("SELECT codigo FROM `tipo_screening` WHERE id = '" . $id_screening . "'");
        $codigo_screening->execute();
        $result = $codigo_screening->fetch();

        $lista = array();
        if ($codigo_screening->rowCount() > 0) {
            $lista = $result['codigo'];

            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_screenings()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['select_screening'])) {
        $select_screening = $_POST["select_screening"];
    } else {
        $select_screening = verificar($data_input, "select_screening");
    }


    try {
        $select_resultados = Flight::db()->prepare("SELECT tipo_screening.id,resultados_screenings.id, rela_screening, rela_paciente, result_screening, nombre, codigo, fecha_alta
        FROM `resultados_screenings` INNER JOIN 
        tipo_screening ON resultados_screenings.rela_screening = tipo_screening.id 
        WHERE resultados_screenings.rela_paciente  = '" . $id_paciente . "' and tipo_screening.codigo = '" . $select_screening . "' ORDER BY fecha_alta DESC");
        $select_resultados->execute();
        $result = $select_resultados->fetchAll();

        $lista = array();
        if ($select_resultados->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function user_read_antc_familiares()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    $retraso = "";
    $desorden = "";
    $deficit = "";
    $lesiones_cabeza = "";
    $perdidas = "";
    $accidentes_caidas = "";
    $lesiones_espalda = "";
    $infecciones = "";
    $toxinas = "";
    $acv = "";
    $demencia = "";
    $parkinson = "";
    $epilepsia = "";
    $esclerosis = "";
    $huntington = "";
    $depresion = "";
    $trastorno = "";
    $esquizofrenia = "";
    $enfermedad_desorden = "";
    $intoxicaciones = "";
    $cancer = "";
    $cirujia = "";
    $trasplante = "";
    $hipotiroidismo = "";
    $cardiologico = "";
    $diabetes = "";
    $hipertension = "";
    $colesterol = "";


    $cod_event_retraso = $_POST['cod_event_retraso'];
    $cod_event_desorden = $_POST['cod_event_desorden'];
    $cod_event_deficit = $_POST['cod_event_deficit'];
    $cod_event_lesiones_cabeza = $_POST['cod_event_lesiones_cabeza'];
    $cod_event_perdidas = $_POST['cod_event_perdidas'];
    $cod_event_accidentes_caidas = $_POST['cod_event_accidentes_caidas'];
    $cod_event_lesiones_espalda = $_POST['cod_event_lesiones_espalda'];
    $cod_event_infecciones = $_POST['cod_event_infecciones'];
    $cod_event_toxinas = $_POST['cod_event_toxinas'];
    $cod_event_acv = $_POST['cod_event_acv'];
    $cod_event_demencia = $_POST['cod_event_demencia'];
    $cod_event_parkinson = $_POST['cod_event_parkinson'];
    $cod_event_epilepsia = $_POST['cod_event_epilepsia'];
    $cod_event_esclerosis = $_POST['cod_event_esclerosis'];
    $cod_event_huntington = $_POST['cod_event_huntington'];
    $cod_event_depresion = $_POST['cod_event_depresion'];
    $cod_event_trastorno = $_POST['cod_event_trastorno'];
    $cod_event_esquizofrenia = $_POST['cod_event_esquizofrenia'];
    $cod_event_enfermedad_desorden = $_POST['cod_event_enfermedad_desorden'];
    $cod_event_intoxicaciones = $_POST['cod_event_intoxicaciones'];

    $cod_event_cancer = $_POST['cod_event_cancer'];
    $cod_event_cirujia = $_POST['cod_event_cirujia'];
    $cod_event_trasplante = $_POST['cod_event_trasplante'];
    $cod_event_hipotiroidismo = $_POST['cod_event_hipotiroidismo'];
    $cod_event_cardiologico = $_POST['cod_event_cardiologico'];
    $cod_event_diabetes = $_POST['cod_event_diabetes'];
    $cod_event_hipertension = $_POST['cod_event_hipertension'];
    $cod_event_colesterol = $_POST['cod_event_colesterol'];


    try {
        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

        $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
        $select_id_users->execute();
        $id_users = $select_id_users->fetch();
        $id_users = $id_users["id"];


        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
        $select_id_paciente->execute();
        $id_paciente = $select_id_paciente->fetch();
        $id_paciente = $id_paciente["id"];


        // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
        $select_antecedentes = Flight::db()->prepare("SELECT * FROM antecedentes_medicos_familiares WHERE rela_paciente = '" . $id_paciente . "'");
        $select_antecedentes->execute();

        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
        $select_evento->execute();
        $evento = $select_evento->fetchAll();

        //var_dump($antecedente);
        if ($select_antecedentes->rowCount() > 0) {
            $antecedente = $select_antecedentes->fetchAll();

            foreach ($antecedente as $antecedentes) {

                foreach ($evento as $eventos) {

                    if ($antecedentes["rela_evento"] == $eventos["id"]) {

                        if ($eventos["codigo_evento"] == $cod_event_retraso) {
                            $retraso = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_desorden) {
                            $desorden = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_deficit) {
                            $deficit = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                            $lesiones_cabeza = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                            $perdidas = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                            $accidentes_caidas = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                            $lesiones_espalda = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                            $infecciones = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                            $toxinas = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_acv) {
                            $acv = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_demencia) {
                            $demencia = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                            $parkinson = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                            $epilepsia = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                            $esclerosis = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_huntington) {
                            $huntington = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_depresion) {
                            $depresion = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                            $trastorno = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                            $esquizofrenia = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                            $enfermedad_desorden = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                            $intoxicaciones = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_cancer) {
                            $cancer = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_cirujia) {
                            $cirujia = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_trasplante) {
                            $trasplante = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_hipotiroidismo) {
                            $hipotiroidismo = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_cardiologico) {
                            $cardiologico = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_diabetes) {
                            $diabetes = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_hipertension) {
                            $hipertension = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_colesterol) {
                            $colesterol = $antecedentes["rela_tipo"];
                        }
                    }
                }
            }

            $lista = array(
                "estado" => "Success",
                "retraso" => $retraso,
                "desorden" => $desorden,
                "deficit" => $deficit,
                "lesiones_cabeza" => $lesiones_cabeza,
                "perdidas" => $perdidas,
                "accidentes_caidas" => $accidentes_caidas,
                "lesiones_espalda" => $lesiones_espalda,
                "infecciones" => $infecciones,
                "toxinas" => $toxinas,
                "acv" => $acv,
                "demencia" => $demencia,
                "parkinson" => $parkinson,
                "epilepsia" => $epilepsia,
                "esclerosis" => $esclerosis,
                "huntington" => $huntington,
                "depresion" => $depresion,
                "trastorno" => $trastorno,
                "esquizofrenia" => $esquizofrenia,
                "enfermedad_desorden" => $enfermedad_desorden,
                "intoxicaciones" => $intoxicaciones,
                "cancer" => $cancer,
                "cirujia" => $cirujia,
                "trasplante" => $trasplante,
                "hipotiroidismo" => $hipotiroidismo,
                "cardiologico" => $cardiologico,
                "diabetes" => $diabetes,
                "hipertension" => $hipertension,
                "colesterol" => $colesterol,
            );

            $returnData = msg("Success", $lista);
        } else {

            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function save_antec_familiares()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    $retraso = $_POST['retraso'] == "true" ? 1 : 0;

    $desorden = $_POST['desorden'] == "true" ? 1 : 0;

    $deficit = $_POST['deficit'] == "true" ? 1 : 0;

    $lesiones_cabeza = $_POST['lesiones_cabeza'] == "true" ? 1 : 0;

    $perdidas = $_POST['perdidas'] == "true" ? 1 : 0;

    $accidentes_caidas = $_POST['accidentes_caidas'] == "true" ? 1 : 0;

    $lesiones_espalda = $_POST['lesiones_espalda'] == "true" ? 1 : 0;

    $infecciones = $_POST['infecciones'] == "true" ? 1 : 0;

    $toxinas = $_POST['toxinas'] == "true" ? 1 : 0;

    $acv = $_POST['acv'] == "true" ? 1 : 0;

    $demencia = $_POST['demencia'] == "true" ? 1 : 0;

    $parkinson = $_POST['parkinson'] == "true" ? 1 : 0;

    $epilepsia = $_POST['epilepsia'] == "true" ? 1 : 0;

    $esclerosis = $_POST['esclerosis'] == "true" ? 1 : 0;

    $huntington = $_POST['huntington'] == "true" ? 1 : 0;

    $depresion = $_POST['depresion'] == "true" ? 1 : 0;

    $trastorno = $_POST['trastorno'] == "true" ? 1 : 0;

    $esquizofrenia = $_POST['esquizofrenia'] == "true" ? 1 : 0;

    $enfermedad_desorden = $_POST['enfermedad_desorden'] == "true" ? 1 : 0;

    $trastorno = $_POST['trastorno'] == "true" ? 1 : 0;

    $intoxicaciones = $_POST['intoxicaciones'] == "true" ? 1 : 0;

    $cancer = $_POST['cancer'] == "true" ? 1 : 0;

    $cirujia = $_POST['cirujia'] == "true" ? 1 : 0;

    $trasplante = $_POST['trasplante'] == "true" ? 1 : 0;

    $cardiologico = $_POST['cardiologico'] == "true" ? 1 : 0;

    $diabetes = $_POST['diabetes'] == "true" ? 1 : 0;

    $hipertension = $_POST['hipertension'] == "true" ? 1 : 0;

    $colesterol = $_POST['colesterol'] == "true" ? 1 : 0;

    $hipotiroidismo = $_POST['hipotiroidismo'] == "true" ? 1 : 0;



    $cod_event_retraso = $_POST['cod_event_retraso'];
    $cod_event_desorden = $_POST['cod_event_desorden'];
    $cod_event_deficit = $_POST['cod_event_deficit'];
    $cod_event_lesiones_cabeza = $_POST['cod_event_lesiones_cabeza'];
    $cod_event_perdidas = $_POST['cod_event_perdidas'];
    $cod_event_accidentes_caidas = $_POST['cod_event_accidentes_caidas'];
    $cod_event_lesiones_espalda = $_POST['cod_event_lesiones_espalda'];
    $cod_event_infecciones = $_POST['cod_event_infecciones'];
    $cod_event_toxinas = $_POST['cod_event_toxinas'];
    $cod_event_acv = $_POST['cod_event_acv'];
    $cod_event_demencia = $_POST['cod_event_demencia'];
    $cod_event_parkinson = $_POST['cod_event_parkinson'];
    $cod_event_epilepsia = $_POST['cod_event_epilepsia'];
    $cod_event_esclerosis = $_POST['cod_event_esclerosis'];
    $cod_event_huntington = $_POST['cod_event_huntington'];
    $cod_event_depresion = $_POST['cod_event_depresion'];
    $cod_event_trastorno = $_POST['cod_event_trastorno'];
    $cod_event_esquizofrenia = $_POST['cod_event_esquizofrenia'];
    $cod_event_enfermedad_desorden = $_POST['cod_event_enfermedad_desorden'];
    $cod_event_intoxicaciones = $_POST['cod_event_intoxicaciones'];
    $cod_event_cancer = $_POST['cod_event_cancer'];
    $cod_event_cirujia = $_POST['cod_event_cirujia'];
    $cod_event_trasplante = $_POST['cod_event_trasplante'];
    $cod_event_hipotiroidismo = $_POST['cod_event_hipotiroidismo'];
    $cod_event_cardiologico = $_POST['cod_event_cardiologico'];
    $cod_event_diabetes = $_POST['cod_event_diabetes'];
    $cod_event_hipertension = $_POST['cod_event_hipertension'];
    $cod_event_colesterol = $_POST['cod_event_colesterol'];


    try {

        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

        $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
        $select_id_users->execute();
        $id_users = $select_id_users->fetch();
        $id_users = $id_users["id"];


        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
        $select_id_paciente->execute();
        $id_paciente = $select_id_paciente->fetch();
        $id_paciente = $id_paciente["id"];


        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
        $select_evento->execute();
        $evento = $select_evento->fetchAll();


        // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
        $select_id_paciente = Flight::db()->prepare("SELECT rela_paciente FROM antecedentes_medicos_familiares WHERE rela_paciente = '" . $id_paciente . "'");
        $select_id_paciente->execute();

        // SI EXISTEN ENTONCES BORRO LAS FILAS COORESPONDIENTES A ESE USUARIO Y PROCEDO A CREAR NUEVOS REGISTROS
        if ($select_id_paciente->rowCount() > 0) {

            $delete_antecedentes = Flight::db()->prepare("DELETE from antecedentes_medicos_familiares
                        WHERE rela_paciente = '" . $id_paciente . "'");
            $delete_antecedentes->execute();
        }

        foreach ($evento as $eventos) {

            if ($eventos["codigo_evento"] == $cod_event_retraso) {

                $rowsToInsert[] = array(
                    'rela_tipo' => $retraso,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_desorden) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $desorden,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_deficit) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $deficit,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $lesiones_cabeza,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $perdidas,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $accidentes_caidas,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $lesiones_espalda,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $infecciones,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $toxinas,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_acv) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $acv,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_demencia) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $demencia,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $parkinson,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $epilepsia,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }


            if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $esclerosis,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_huntington) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $huntington,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_depresion) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $depresion,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $trastorno,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $esquizofrenia,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $enfermedad_desorden,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $intoxicaciones,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_cancer) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $cancer,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_cirujia) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $cirujia,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_trasplante) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $trasplante,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_hipotiroidismo) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $hipotiroidismo,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_cardiologico) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $cardiologico,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_diabetes) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $diabetes,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_hipertension) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $hipertension,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_colesterol) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $colesterol,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }
        }

        //Call our custom function.
        pdoMultiInsert('antecedentes_medicos_familiares', $rowsToInsert, Flight::db());


        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function user_read_antc_personales()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }


    $retraso = "";
    $desorden = "";
    $deficit = "";
    $lesiones_cabeza = "";
    $perdidas = "";
    $accidentes_caidas = "";
    $lesiones_espalda = "";
    $infecciones = "";
    $toxinas = "";
    $acv = "";
    $demencia = "";
    $parkinson = "";
    $epilepsia = "";
    $esclerosis = "";
    $huntington = "";
    $depresion = "";
    $trastorno = "";
    $esquizofrenia = "";
    $enfermedad_desorden = "";
    $intoxicaciones = "";



    $cod_event_retraso = $_POST['cod_event_retraso'];
    $cod_event_desorden = $_POST['cod_event_desorden'];
    $cod_event_deficit = $_POST['cod_event_deficit'];
    $cod_event_lesiones_cabeza = $_POST['cod_event_lesiones_cabeza'];
    $cod_event_perdidas = $_POST['cod_event_perdidas'];
    $cod_event_accidentes_caidas = $_POST['cod_event_accidentes_caidas'];
    $cod_event_lesiones_espalda = $_POST['cod_event_lesiones_espalda'];
    $cod_event_infecciones = $_POST['cod_event_infecciones'];
    $cod_event_toxinas = $_POST['cod_event_toxinas'];
    $cod_event_acv = $_POST['cod_event_acv'];
    $cod_event_demencia = $_POST['cod_event_demencia'];
    $cod_event_parkinson = $_POST['cod_event_parkinson'];
    $cod_event_epilepsia = $_POST['cod_event_epilepsia'];
    $cod_event_esclerosis = $_POST['cod_event_esclerosis'];
    $cod_event_huntington = $_POST['cod_event_huntington'];
    $cod_event_depresion = $_POST['cod_event_depresion'];
    $cod_event_trastorno = $_POST['cod_event_trastorno'];
    $cod_event_esquizofrenia = $_POST['cod_event_esquizofrenia'];
    $cod_event_enfermedad_desorden = $_POST['cod_event_enfermedad_desorden'];
    $cod_event_intoxicaciones = $_POST['cod_event_intoxicaciones'];

    try {
        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

        $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
        $select_id_users->execute();
        $id_users = $select_id_users->fetch();
        $id_users = $id_users["id"];


        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
        $select_id_paciente->execute();
        $id_paciente = $select_id_paciente->fetch();
        $id_paciente = $id_paciente["id"];


        // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
        $select_antecedentes = Flight::db()->prepare("SELECT * FROM antecedentes_medicos_personales WHERE rela_paciente = '" . $id_paciente . "'");
        $select_antecedentes->execute();


        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
        $select_evento->execute();
        $evento = $select_evento->fetchAll();

        //var_dump($select_antecedentes->rowCount());
        if ($select_antecedentes->rowCount() > 0) {
            $antecedente = $select_antecedentes->fetchAll();

            foreach ($antecedente as $antecedentes) {

                foreach ($evento as $eventos) {

                    if ($antecedentes["rela_evento"] == $eventos["id"]) {

                        if ($eventos["codigo_evento"] == $cod_event_retraso) {
                            $retraso = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_desorden) {
                            $desorden = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_deficit) {
                            $deficit = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                            $lesiones_cabeza = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                            $perdidas = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                            $accidentes_caidas = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                            $lesiones_espalda = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                            $infecciones = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                            $toxinas = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_acv) {
                            $acv = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_demencia) {
                            $demencia = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                            $parkinson = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                            $epilepsia = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                            $esclerosis = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_huntington) {
                            $huntington = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_depresion) {
                            $depresion = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                            $trastorno = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                            $esquizofrenia = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                            $enfermedad_desorden = $antecedentes["rela_tipo"];
                        }

                        if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                            $intoxicaciones = $antecedentes["rela_tipo"];
                        }
                    }
                }
            }

            $lista = array(
                "estado" => "Success",
                "retraso" => $retraso,
                "desorden" => $desorden,
                "deficit" => $deficit,
                "lesiones_cabeza" => $lesiones_cabeza,
                "perdidas" => $perdidas,
                "accidentes_caidas" => $accidentes_caidas,
                "lesiones_espalda" => $lesiones_espalda,
                "infecciones" => $infecciones,
                "toxinas" => $toxinas,
                "acv" => $acv,
                "demencia" => $demencia,
                "parkinson" => $parkinson,
                "epilepsia" => $epilepsia,
                "esclerosis" => $esclerosis,
                "huntington" => $huntington,
                "depresion" => $depresion,
                "trastorno" => $trastorno,
                "esquizofrenia" => $esquizofrenia,
                "enfermedad_desorden" => $enfermedad_desorden,
                "intoxicaciones" => $intoxicaciones,
            );
        } else {
            $lista = array(
                "estado" => "Success",
                "retraso" => 0,
                "desorden" => 0,
                "deficit" => 0,
                "lesiones_cabeza" => 0,
                "perdidas" => 0,
                "accidentes_caidas" => 0,
                "lesiones_espalda" => 0,
                "infecciones" => 0,
                "toxinas" => 0,
                "acv" => 0,
                "demencia" => 0,
                "parkinson" => 0,
                "epilepsia" => 0,
                "esclerosis" => 0,
                "huntington" => 0,
                "depresion" => 0,
                "trastorno" => 0,
                "esquizofrenia" => 0,
                "enfermedad_desorden" => 0,
                "intoxicaciones" => 0,
            );
        }

        $returnData = msg("Success", $lista);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function save_antec_personales()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }


    if ($_POST['retraso'] == "true") {
        $retraso = 1;
    } else {
        $retraso = 0;
    }

    if ($_POST['desorden'] == "true") {
        $desorden = 1;
    } else {
        $desorden = 0;
    }

    if ($_POST['deficit'] == "true") {
        $deficit = 1;
    } else {
        $deficit = 0;
    }

    if ($_POST['lesiones_cabeza'] == "true") {
        $lesiones_cabeza = 1;
    } else {
        $lesiones_cabeza = 0;
    }

    if ($_POST['perdidas'] == "true") {
        $perdidas = 1;
    } else {
        $perdidas = 0;
    }


    if ($_POST['accidentes_caidas'] == "true") {
        $accidentes_caidas = 1;
    } else {
        $accidentes_caidas = 0;
    }

    if ($_POST['lesiones_espalda'] == "true") {
        $lesiones_espalda = 1;
    } else {
        $lesiones_espalda = 0;
    }

    if ($_POST['infecciones'] == "true") {
        $infecciones = 1;
    } else {
        $infecciones = 0;
    }

    if ($_POST['toxinas'] == "true") {
        $toxinas = 1;
    } else {
        $toxinas = 0;
    }

    if ($_POST['acv'] == "true") {
        $acv = 1;
    } else {
        $acv = 0;
    }

    if ($_POST['demencia'] == "true") {
        $demencia = 1;
    } else {
        $demencia = 0;
    }


    if ($_POST['parkinson'] == "true") {
        $parkinson = 1;
    } else {
        $parkinson = 0;
    }

    if ($_POST['epilepsia'] == "true") {
        $epilepsia = 1;
    } else {
        $epilepsia = 0;
    }

    if ($_POST['esclerosis'] == "true") {
        $esclerosis = 1;
    } else {
        $esclerosis = 0;
    }

    if ($_POST['huntington'] == "true") {
        $huntington = 1;
    } else {
        $huntington = 0;
    }

    if ($_POST['depresion'] == "true") {
        $depresion = 1;
    } else {
        $depresion = 0;
    }

    if ($_POST['trastorno'] == "true") {
        $trastorno = 1;
    } else {
        $trastorno = 0;
    }

    if ($_POST['esquizofrenia'] == "true") {
        $esquizofrenia = 1;
    } else {
        $esquizofrenia = 0;
    }

    if ($_POST['enfermedad_desorden'] == "true") {
        $enfermedad_desorden = 1;
    } else {
        $enfermedad_desorden = 0;
    }

    if ($_POST['intoxicaciones'] == "true") {
        $intoxicaciones = 1;
    } else {
        $intoxicaciones = 0;
    }


    $cod_event_retraso = $_POST['cod_event_retraso'];
    $cod_event_desorden = $_POST['cod_event_desorden'];
    $cod_event_deficit = $_POST['cod_event_deficit'];
    $cod_event_lesiones_cabeza = $_POST['cod_event_lesiones_cabeza'];
    $cod_event_perdidas = $_POST['cod_event_perdidas'];
    $cod_event_accidentes_caidas = $_POST['cod_event_accidentes_caidas'];
    $cod_event_lesiones_espalda = $_POST['cod_event_lesiones_espalda'];
    $cod_event_infecciones = $_POST['cod_event_infecciones'];
    $cod_event_toxinas = $_POST['cod_event_toxinas'];
    $cod_event_acv = $_POST['cod_event_acv'];
    $cod_event_demencia = $_POST['cod_event_demencia'];
    $cod_event_parkinson = $_POST['cod_event_parkinson'];
    $cod_event_epilepsia = $_POST['cod_event_epilepsia'];
    $cod_event_esclerosis = $_POST['cod_event_esclerosis'];
    $cod_event_huntington = $_POST['cod_event_huntington'];
    $cod_event_depresion = $_POST['cod_event_depresion'];
    $cod_event_trastorno = $_POST['cod_event_trastorno'];
    $cod_event_esquizofrenia = $_POST['cod_event_esquizofrenia'];
    $cod_event_enfermedad_desorden = $_POST['cod_event_enfermedad_desorden'];
    $cod_event_intoxicaciones = $_POST['cod_event_intoxicaciones'];


    try {
        //$select_id_paciente = Flight::db()->prepare("SELECT pacientes.id FROM `pacientes` INNER JOIN users ON pacientes.rela_users = users.id WHERE users.email = '".$email."'");
        //$select_id_paciente->execute();
        //$id_paciente= $select_id_paciente->fetch();
        //$id_paciente= $id_paciente["pacientes.id"];

        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

        $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '" . $email . "'");
        $select_id_users->execute();
        $id_users = $select_id_users->fetch();
        $id_users = $id_users["id"];


        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
        $select_id_paciente->execute();
        $id_paciente = $select_id_paciente->fetch();
        $id_paciente = $id_paciente["id"];


        // SELECCION DE EVENTOS
        $select_evento = Flight::db()->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
        $select_evento->execute();
        $evento = $select_evento->fetchAll();


        // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
        $select_id_paciente = Flight::db()->prepare("SELECT rela_paciente FROM antecedentes_medicos_personales WHERE rela_paciente = '" . $id_paciente . "'");
        $select_id_paciente->execute();

        // SI EXISTEN ENTONCES BORRO LAS FILAS COORESPONDIENTES A ESE USUARIO Y PROCEDO A CREAR NUEVOS REGISTROS
        if ($select_id_paciente->rowCount() > 0) {

            $delete_antecedentes = Flight::db()->prepare("DELETE from antecedentes_medicos_personales
                        WHERE rela_paciente = '" . $id_paciente . "'");
            $delete_antecedentes->execute();
        }

        foreach ($evento as $eventos) {

            if ($eventos["codigo_evento"] == $cod_event_retraso) {

                $rowsToInsert[] = array(
                    'rela_tipo' => $retraso,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_desorden) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $desorden,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_deficit) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $deficit,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_lesiones_cabeza) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $lesiones_cabeza,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_perdidas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $perdidas,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_accidentes_caidas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $accidentes_caidas,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_lesiones_espalda) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $lesiones_espalda,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_infecciones) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $infecciones,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_toxinas) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $toxinas,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_acv) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $acv,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_demencia) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $demencia,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_parkinson) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $parkinson,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_epilepsia) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $epilepsia,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }


            if ($eventos["codigo_evento"] == $cod_event_esclerosis) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $esclerosis,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_huntington) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $huntington,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_depresion) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $depresion,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_trastorno) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $trastorno,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_esquizofrenia) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $esquizofrenia,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_enfermedad_desorden) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $enfermedad_desorden,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }

            if ($eventos["codigo_evento"] == $cod_event_intoxicaciones) {
                $rowsToInsert[] = array(
                    'rela_tipo' => $intoxicaciones,
                    'rela_evento' => $eventos["id"],
                    'rela_paciente' => $id_paciente,
                );
            }
        }

        //Call our custom function.
        pdoMultiInsert('antecedentes_medicos_personales', $rowsToInsert, Flight::db());


        $returnData = msg("Success", []);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}


function save_datos_clinicos()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['pulso'])) {
        $pulso = $_POST["pulso"];
    } else {
        $pulso = verificar($data_input, "pulso");
    }

    if (isset($_POST['presion_alta'])) {
        $presion_alta = $_POST["presion_alta"];
    } else {
        $presion_alta = verificar($data_input, "presion_alta");
    }

    if (isset($_POST['presion_baja'])) {
        $presion_baja = $_POST["presion_baja"];
    } else {
        $presion_baja = verificar($data_input, "presion_baja");
    }

    if (isset($_POST['presion_alta'])) {
        $presion_alta = $_POST["presion_alta"];
    } else {
        $presion_alta = verificar($data_input, "presion_alta");
    }

    if (isset($_POST['circunfer_cintura'])) {
        $circunfer_cintura = $_POST["circunfer_cintura"];
    } else {
        $circunfer_cintura = verificar($data_input, "circunfer_cintura");
    }


    if (isset($_POST['peso_corporal'])) {
        $peso_corporal = $_POST["peso_corporal"];
    } else {
        $peso_corporal = verificar($data_input, "peso_corporal");
    }

    if (isset($_POST['talla'])) {
        $talla = $_POST["talla"];
    } else {
        $talla = verificar($data_input, "talla");
    }

    if (isset($_POST['id_alcohol'])) {
        $id_alcohol = $_POST["id_alcohol"];
    } else {
        $id_alcohol = verificar($data_input, "id_alcohol");
    }

    if (isset($_POST['id_tabaco'])) {
        $id_tabaco = $_POST["id_tabaco"];
    } else {
        $id_tabaco = verificar($data_input, "id_tabaco");
    }

    if (isset($_POST['id_marihuana'])) {
        $id_marihuana = $_POST["id_marihuana"];
    } else {
        $id_marihuana = verificar($data_input, "id_marihuana");
    }

    if (isset($_POST['id_otras'])) {
        $id_otras = $_POST["id_otras"];
    } else {
        $id_otras = verificar($data_input, "id_otras");
    }

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }


    try {

        $estado_clinico = 1;
        $consult_estado = Flight::db()->prepare("SELECT estado_clinico FROM datos_clinicos WHERE estado_clinico = '" . $estado_clinico . "' AND rela_paciente = '" . $id_paciente . "'");
        $consult_estado->execute();

        $consult_estado = $consult_estado->rowCount();


        if ($consult_estado > 0) {

            $estado_clinico = 0;
            $estado_clinico1 = 1;

            $update_datos_clinicos = Flight::db()->prepare("UPDATE datos_clinicos
                    SET estado_clinico=?
                    WHERE rela_paciente=? AND estado_clinico=?");
            $update_datos_clinicos->execute([$estado_clinico, $id_paciente, $estado_clinico1]);


            $estado_clinico = 1;
            $insert_dato_clinico = Flight::db()->prepare('INSERT INTO datos_clinicos(rela_paciente,presion_alta,presion_baja,pulso,peso,
                    circunferencia_cintura,talla,consume_alcohol,consume_marihuana,otras_drogas,fuma_tabaco,estado_clinico)VALUES(?,?,?,?,?,?,?,?,?,?,?,?)');
            $insert_dato_clinico->bindParam(1, $id_paciente);
            $insert_dato_clinico->bindParam(2, $presion_alta);
            $insert_dato_clinico->bindParam(3, $presion_baja);
            $insert_dato_clinico->bindParam(4, $pulso);
            $insert_dato_clinico->bindParam(5, $peso_corporal);
            $insert_dato_clinico->bindParam(6, $circunfer_cintura);
            $insert_dato_clinico->bindParam(7, $talla);
            $insert_dato_clinico->bindParam(8, $id_alcohol);
            $insert_dato_clinico->bindParam(9, $id_marihuana);
            $insert_dato_clinico->bindParam(10, $id_otras);
            $insert_dato_clinico->bindParam(11, $id_tabaco);
            $insert_dato_clinico->bindParam(12, $estado_clinico);
            $insert_dato_clinico->execute();

            $insert_dato_clinico = $insert_dato_clinico->rowCount();
            if ($insert_dato_clinico) {
                $returnData = msg("Success", []);
            }
        } else {

            $estado_clinico = 1;
            $insert_dato_clinico = Flight::db()->prepare('INSERT INTO datos_clinicos(rela_paciente,presion_alta,presion_baja,pulso,peso,
                    circunferencia_cintura,talla,consume_alcohol,consume_marihuana,otras_drogas,fuma_tabaco,estado_clinico)VALUES(?,?,?,?,?,?,?,?,?,?,?,?)');
            $insert_dato_clinico->bindParam(1, $id_paciente);
            $insert_dato_clinico->bindParam(2, $presion_alta);
            $insert_dato_clinico->bindParam(3, $presion_baja);
            $insert_dato_clinico->bindParam(4, $pulso);
            $insert_dato_clinico->bindParam(5, $peso_corporal);
            $insert_dato_clinico->bindParam(6, $circunfer_cintura);
            $insert_dato_clinico->bindParam(7, $talla);
            $insert_dato_clinico->bindParam(8, $id_alcohol);
            $insert_dato_clinico->bindParam(9, $id_marihuana);
            $insert_dato_clinico->bindParam(10, $id_otras);
            $insert_dato_clinico->bindParam(11, $id_tabaco);
            $insert_dato_clinico->bindParam(12, $estado_clinico);
            $insert_dato_clinico->execute();

            $insert_dato_clinico = $insert_dato_clinico->rowCount();
            if ($insert_dato_clinico) {
                $returnData = msg("Success", []);
            }
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function save_datos_personales()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['nombre'])) {
        $nombre = $_POST["nombre"];
    } else {
        $nombre = verificar($data_input, "nombre");
    }

    if (isset($_POST['apellido'])) {
        $apellido = $_POST["apellido"];
    } else {
        $apellido = verificar($data_input, "apellido");
    }

    if (isset($_POST['dni'])) {
        $dni = $_POST["dni"];
    } else {
        $dni = verificar($data_input, "dni");
    }

    if (isset($_POST['fecha_nacimiento'])) {
        $fecha_nacimiento = $_POST["fecha_nacimiento"];
    } else {
        $fecha_nacimiento = verificar($data_input, "fecha_nacimiento");
    }

    if (isset($_POST['rela_genero'])) {
        $rela_genero = $_POST["rela_genero"];
    } else {
        $rela_genero = verificar($data_input, "rela_genero");
    }

    if (isset($_POST['rela_departamento'])) {
        $rela_departamento = $_POST["rela_departamento"];
    } else {
        $rela_departamento = verificar($data_input, "rela_departamento");
    }

    if (isset($_POST['rela_nivel_instruccion'])) {
        $rela_nivel_instruccion = $_POST["rela_nivel_instruccion"];
    } else {
        $rela_nivel_instruccion = verificar($data_input, "rela_nivel_instruccion");
    }

    if (isset($_POST['rela_grupo_conviviente'])) {
        $rela_grupo_conviviente = $_POST["rela_grupo_conviviente"];
    } else {
        $rela_grupo_conviviente = verificar($data_input, "rela_grupo_conviviente");
    }

    if (isset($_POST['celular'])) {
        $celular = $_POST["celular"];
    } else {
        $celular = verificar($data_input, "celular");
    }

    if (isset($_POST['nombre_contacto'])) {
        $nombre_contacto = $_POST["nombre_contacto"];
    } else {
        $nombre_contacto = verificar($data_input, "nombre_contacto");
    }

    if (isset($_POST['apellido_contacto'])) {
        $apellido_contacto = $_POST["apellido_contacto"];
    } else {
        $apellido_contacto = verificar($data_input, "apellido_contacto");
    }

    if (isset($_POST['celular_contacto'])) {
        $celular_contacto = $_POST["celular_contacto"];
    } else {
        $celular_contacto = verificar($data_input, "celular_contacto");
    }

    if (isset($_POST['estado_users'])) {
        $estado_users = $_POST["estado_users"];
    } else {
        $estado_users = verificar($data_input, "estado_users");
    }

    if (isset($_POST['rela_users'])) {
        $rela_users = $_POST["rela_users"];
    } else {
        $rela_users = verificar($data_input, "rela_users");
    }


    try {

        $data = [
            'nombre' => $nombre,
            'apellido' => $apellido,
            'dni' => $dni,
            'fecha_nacimiento' => $fecha_nacimiento,
            'rela_genero' => $rela_genero,
            'rela_nivel_instruccion' => $rela_nivel_instruccion,
            'rela_grupo_conviviente' => $rela_grupo_conviviente,
            'celular' => $celular,
            'nombre_contacto' => $nombre_contacto,
            'apellido_contacto' => $apellido_contacto,
            'celular_contacto' => $celular_contacto,
            'rela_departamento' => $rela_departamento,
            'estado_users' => $estado_users,
            'rela_users' => $rela_users
        ];

        $insert_paciente = Flight::db()->prepare("UPDATE pacientes
                SET nombre=:nombre, 
                apellido=:apellido,
                dni=:dni, 
                fecha_nacimiento=:fecha_nacimiento, 
                rela_genero=:rela_genero,
                rela_nivel_instruccion=:rela_nivel_instruccion,
                rela_grupo_conviviente=:rela_grupo_conviviente,
                celular=:celular, 
                nombre_contacto=:nombre_contacto,
                apellido_contacto=:apellido_contacto,
                celular_contacto=:celular_contacto,
                rela_departamento=:rela_departamento,
                estado_users=:estado_users,
                rela_users=:rela_users
                WHERE rela_users=:rela_users");


        $insert_paciente->execute($data);

        $select_id_paciente = Flight::db()->prepare("SELECT id FROM pacientes WHERE id = '".$id_paciente."'");
        $select_id_paciente->execute();
        $id_paciente= $select_id_paciente->fetch();
        $id_paciente= $id_paciente["id"];

        $lista = array(
            "id_paciente" => $id_paciente,
            "nombre" => $nombre,
            "apellido" => $apellido,
            "dni" => $dni,
            "rela_users" => $rela_users,
            "fecha_nacimiento" => $fecha_nacimiento,
            "rela_genero" => $rela_genero,
            "rela_nivel_instruccion" => $rela_nivel_instruccion,
            "rela_grupo_conviviente" => $rela_grupo_conviviente,
            "celular" => $celular,
            'nombre_contacto' => $nombre_contacto,
            'apellido_contacto' => $apellido_contacto,
            'celular_contacto' => $celular_contacto,
            "rela_departamento" => $rela_departamento,
            "estado_users" => $estado_users,

        );

        $returnData = msg("Success", $lista);
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function respuesta()
{
    try {
        $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES3','TRES49','TRES50','TRES51')");
        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_list_medicos()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $rela_paciente = $_POST["id_paciente"];
    } else {
        $rela_paciente = verificar($data_input, "id_paciente");
    }

    try {
    $stmt = Flight::db()->prepare("SELECT medicos.id, nombre, apellido, especialidad,estado_habilitacion, matricula  
    FROM medicos_pacientes 
    INNER JOIN medicos 
    ON medicos_pacientes.rela_medico = medicos.id
    WHERE rela_paciente = '" . $rela_paciente . "'");

        $stmt->execute();
        $result = $stmt->fetchAll();

        $lista = array();

        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }
            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function update_estado_habilitacion_medico(){
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['id_medico'])) {
        $id_medico = $_POST["id_medico"];
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['estado_paciente_medico'])) {
        $estado_paciente_medico = $_POST["estado_paciente_medico"];
    } else {
        $estado_paciente_medico = verificar($data_input, "estado_paciente_medico");
    }

    try {
        $data = [
            'id_paciente' => $id_paciente,
            'id_medico' => $id_medico,
            'estado_paciente_medico' => $estado_paciente_medico,
        ];
        $update_estado_habilitacion = Flight::db()->prepare("UPDATE medicos_pacientes
                    SET estado_habilitacion=:estado_paciente_medico
                    WHERE rela_paciente=:id_paciente and rela_medico=:id_medico");
    
        $update_estado_habilitacion->execute($data);

        $returnData = msg("Success", []);

    } catch (PDOException $error) {
        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());

    }
    
    Flight::json($returnData);

}

function consult_preference()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['email'])) {
        $email = $_POST["email"];
    } else {
        $email = verificar($data_input, "email");
    }

    try {

        $stmt = Flight::db()->prepare("SELECT id FROM users WHERE email = '" . $email . "'");
        $stmt->execute();
        if ($stmt->rowCount()) {
            $rela_users = $stmt->fetch();
            $rela_users = $rela_users["id"];


            $stmt_paciente = Flight::db()->prepare("SELECT * FROM pacientes WHERE rela_users = '" . $rela_users . "'");

            $stmt_paciente->execute();


            if ($stmt_paciente->rowCount()) {
                $result = $stmt_paciente->fetch();
                $lista = array(
                    "estado_users" => $result["estado_users"],
                    "id_paciente" => $result["id"],
                );
            } else {
                $returnData = msg("Vacio", "No exite paciente con email ingresado");
                Flight::json($returnData);
                exit;
            }

            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", "Email no encontrado");
            Flight::json($returnData);
            exit;
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function generate_vinculation()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['rela_medico'])) {
        $rela_medico = $_POST["rela_medico"];
    } else {
        $rela_medico = verificar($data_input, "rela_medico");
    }

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    if (isset($_POST['rela_medico'])) {
        $rela_medico = $_POST["rela_medico"];
    } else {
        $rela_medico = verificar($data_input, "rela_medico");
    }

    $estadohabilitacion = 0;

    try {
        // insertar en la tabla usuarios_avisos 
        $stmt = Flight::db()->prepare("INSERT INTO medicos_pacientes (rela_medico, rela_paciente, estado_habilitacion) VALUES (:rela_medico, :rela_paciente, :estadohabilitacion)");
        $stmt->bindParam(':rela_medico', $rela_medico);
        $stmt->bindParam(':rela_paciente', $id_paciente);
        $stmt->bindParam(':estadohabilitacion', $estadohabilitacion);
        $stmt->execute();

        $insert_usuarios_avisos = $stmt->rowCount();
        if ($insert_usuarios_avisos) {

            $returnData = msg("Success", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_medico()
{
    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['rela_paciente'])) {
        $id_paciente = $_POST["rela_paciente"];
    } else {
        $id_paciente = verificar($data_input, "rela_paciente");
    }

    try {


        $stmt = Flight::db()->prepare("SELECT * FROM usuarios_avisos
        JOIN avisos_generales ON avisos_generales.id = usuarios_avisos.rela_aviso
        JOIN medicos ON medicos.id = avisos_generales.rela_medico
        WHERE rela_paciente = '" . $id_paciente . "' ");

        $stmt->execute();
        $result = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        $lista = array();

        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista = $results;
            }

            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function read_medicamentos()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    try {
        $stmt = Flight::db()->prepare("SELECT * FROM medicamento_paciente
        JOIN medicamentos on medicamentos.id_medicamento = medicamento_paciente.rela_medicamento
        WHERE rela_paciente = '" . $id_paciente . "' ");

        $stmt->execute();
        $result = $stmt->fetchAll();
        $lista = array();

        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $lista[] = $results;
            }

            $returnData = msg("Success", $lista);
        } else {
            $returnData = msg("Vacio", []);
        }
    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
}

function create_avisos()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $returnData = [];

    if (isset($_POST['criterio'])) {
        $criterio = $_POST["criterio"];
    } else {
        $criterio = verificar($data_input, "criterio");
    }

    if (isset($_POST['id_medico'])) {
        $id_medico = $_POST["id_medico"];
    } else {
        $id_medico = verificar($data_input, "id_medico");
    }

    if (isset($_POST['descripcion'])) {
        $descripcion = $_POST["descripcion"];
    } else {
        $descripcion = verificar($data_input, "descripcion");
    }

    if (isset($_POST['fecha_limite'])) {
        $fecha_limite = $_POST["fecha_limite"];
    } else {
        $fecha_limite = verificar($data_input, "fecha_limite");
    }

    if (isset($_POST['id_paciente'])) {
        $id_paciente = $_POST["id_paciente"];
    } else {
        $id_paciente = verificar($data_input, "id_paciente");
    }

    $criterio = (int)$criterio;

    try {

        $data = [
            'descripcion' => $descripcion,
            'fecha_limite' => $fecha_limite,
            'aviso_criterio' => $criterio,
            'rela_estado' => 0,
            'rela_creador' => $id_medico
        ];

        $rela_creador = 0;

        $stmt = Flight::db()->prepare('INSERT INTO avisos_generales(descripcion,fecha_limite,aviso_criterio,rela_estado,rela_creador) 
        VALUES(?, ?, ?, ?, ?)');
        $stmt->bindParam(1, $descripcion);
        $stmt->bindParam(2, $fecha_limite);
        $stmt->bindParam(3, $criterio);
        $stmt->bindParam(4, $rela_creador);
        $stmt->bindParam(5, $id_medico);

        $stmt->execute();

        $id_aviso = Flight::db()->lastInsertId();


        switch ($criterio) {

            case 1:
                # Aviso general por Departamentos

                if (isset($_POST['arreglo_opcion_select'])) {
                    $arreglo_opcion_select = $_POST["arreglo_opcion_select"];
                } else {
                    $arreglo_opcion_select = verificar($data_input, "arreglo_opcion_select");
                }

                foreach ($arreglo_opcion_select as $departamentos) {
                    $stmt = Flight::db()->prepare('INSERT INTO avisos_departamentos(rela_aviso,rela_departamento) 
                    VALUES(?, ?)');
                    $stmt->bindParam(1, $id_aviso);
                    $stmt->bindParam(2, $departamentos);

                    $stmt->execute();

                    //---------------------
                    $query = "SELECT * FROM `pacientes` WHERE rela_departamento = '".$departamentos."'";
                    $select_pacientes_deptos = Flight::db()->prepare($query);
                    $select_pacientes_deptos->execute();
                    $paciente_array= $select_pacientes_deptos->fetchAll();

                    foreach ($paciente_array as $pacientes_arrays) {
                        $estado_aviso = 1;
                        $estado_leido = 1;
        
                        $stmt = Flight::db()->prepare('INSERT INTO usuarios_avisos(rela_aviso,rela_paciente,estado_aviso,rela_medico,estado_leido) 
                        VALUES(?, ?, ?, ?, ?)');
                        $stmt->bindParam(1, $id_aviso);
                        $stmt->bindParam(2, $pacientes_arrays['id']);
                        $stmt->bindParam(3, $estado_aviso);
                        $stmt->bindParam(4, $id_medico);
                        $stmt->bindParam(5, $estado_leido);
        
        
                        $stmt->execute();
                    }
                   
                    //----------------------

                    
                }
                $returnData = msg("Success", []);
                break;

            case 2:
                # Aviso general por Géneros

                if (isset($_POST['opcion_check'])) {
                    $opcion_check = $_POST["opcion_check"];
                } else {
                    $opcion_check = verificar($data_input, "opcion_check");
                }

                $stmt = Flight::db()->prepare('INSERT INTO avisos_generos(rela_aviso,rela_genero) 
                        VALUES(?, ?)');
                $stmt->bindParam(1, $id_aviso);
                $stmt->bindParam(2, $opcion_check);

                $stmt->execute();

                //---------------------
                $query = "SELECT * FROM `pacientes` WHERE rela_genero = '".$opcion_check."'";
                $select_pacientes_generos = Flight::db()->prepare($query);
                $select_pacientes_generos->execute();
                $paciente_array= $select_pacientes_generos->fetchAll();

                foreach ($paciente_array as $pacientes_arrays) {
                    $estado_aviso = 1;
                    $estado_leido = 1;
    
                    $stmt = Flight::db()->prepare('INSERT INTO usuarios_avisos(rela_aviso,rela_paciente,estado_aviso,rela_medico,estado_leido) 
                    VALUES(?, ?, ?, ?, ?)');
                    $stmt->bindParam(1, $id_aviso);
                    $stmt->bindParam(2, $pacientes_arrays['id']);
                    $stmt->bindParam(3, $estado_aviso);
                    $stmt->bindParam(4, $id_medico);
                    $stmt->bindParam(5, $estado_leido);
    
    
                    $stmt->execute();
                }
               
                //----------------------
               

                $returnData = msg("Success", []);

                break;
            case 4:
                //Aviso Individual
                $estado_aviso = 1;
                $estado_leido = 1;

                $stmt = Flight::db()->prepare('INSERT INTO usuarios_avisos(rela_aviso,rela_paciente,estado_aviso,rela_medico,estado_leido) 
                VALUES(?, ?, ?, ?, ?)');
                $stmt->bindParam(1, $id_aviso);
                $stmt->bindParam(2, $id_paciente);
                $stmt->bindParam(3, $estado_aviso);
                $stmt->bindParam(4, $id_medico);
                $stmt->bindParam(5, $estado_leido);


                $stmt->execute();

                $returnData = msg("Success", []);

                break;

            case 5:
                # Aviso general por Patologias

                if (isset($_POST['arreglo_opcion_select'])) {
                    $arreglo_opcion_select = $_POST["arreglo_opcion_select"];
                } else {
                    $arreglo_opcion_select = verificar($data_input, "arreglo_opcion_select");
                }

                foreach ($arreglo_opcion_select as $patologias) {
                    $stmt = Flight::db()->prepare('INSERT INTO avisos_patologias(rela_aviso,rela_patologia) 
                            VALUES(?, ?)');
                    $stmt->bindParam(1, $id_aviso);
                    $stmt->bindParam(2, $patologias);

                    $stmt->execute();

                    //$returnData = msg("Success", []);
                }

                $estado_aviso = 1;
                $estado_leido = 1;

                $stmt = Flight::db()->prepare('INSERT INTO usuarios_avisos(rela_aviso,rela_paciente,estado_aviso,rela_medico,estado_leido) 
                VALUES(?, ?, ?, ?, ?)');
                $stmt->bindParam(1, $id_aviso);
                $stmt->bindParam(2, $id_paciente);
                $stmt->bindParam(3, $estado_aviso);
                $stmt->bindParam(4, $id_medico);
                $stmt->bindParam(5, $estado_leido);


                $stmt->execute();

                $returnData = msg("Success", []);
                break;

            default:
                $returnData = msg("Error", "Criterio Invalido");
                Flight::json($returnData);
                exit;
                break;
        }

    } catch (PDOException $error) {

        $returnData = msg_error("Error", $error->getMessage(), $error->getCode());
    }

    Flight::json($returnData);
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
