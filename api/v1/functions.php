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

    try {

        $stmt = Flight::db()->prepare("SELECT * FROM users WHERE email = '" . $email . "' AND password = '" . $password . "'");
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

                //$id_paciente = $result_paciente['id'];

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
                $contacto = $result_paciente['contacto'];
                $estado_users = $result_paciente['estado_users'];


                $lista = array(      
				"token"=>$token_id,
				"email" => $email,
				//PacienteModel
				"paciente"=>[
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
				"contacto" => $contacto,
				"estado_users"=>$estado_users
				],
                );

                //echo json_encode($lista);

                $token = "";

                $returnData = msg_login("Success", $lista, $token);
            } else {
                // $lista = array ("request"=>"Error al iniciar sesión");
                // echo json_encode($lista);

                $returnData = msg_error("Fail Session", "Error al iniciar sesión", "0");
            }
        } else {

            $returnData = msg_error("Fail Session", "Error al iniciar sesión", "0");
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

        $smt = Flight::db()->prepare("select pacientes.id, dni, nombre, apellido FROM `pacientes` 
        INNER JOIN medicos_pacientes WHERE rela_medico = '" . $id_medicos . "'");
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
        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE id = '" . $id_paciente . "'");
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
                                $depresion = "Depresion";
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
                                $cardiologico = "Cardiologico";
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
                                $hipertension = "Hipertension";
                                $stack = array("hipertension" => $hipertension);
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
        // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
        $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE id = '" . $id_paciente . "'");
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
                                $depresion = "Depresion";
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

    $id_paciente = verificar($data_input, "id_paciente");


    try {
        // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

        $select_id_users = Flight::db()->prepare("SELECT pacientes.id id
     FROM pacientes 
     WHERE id = '" . $id_paciente . "'");

        $select_id_users->execute();
        $id_users = $select_id_users->fetch();
        $id_users = $id_users["id"];


        $select_data_clinica = Flight::db()->prepare("SELECT presion_alta,presion_baja ,pulso, peso, circunferencia_cintura, consume_alcohol,
    consume_marihuana, otras_drogas, fuma_tabaco, fecha_alta, talla 
    FROM datos_clinicos 
    WHERE rela_paciente = '" . $id_users . "'");

        $select_data_clinica->execute();

        if ($select_data_clinica->rowCount() > 0) {
            $result = $select_data_clinica->fetchAll();
            for ($i = 1; $i <= 10; $i++)
            foreach ($result as $results) {
               /* switch (results['consume_alcohol']) {
                    case 902:
                        results['consume_alcohol'] = "A veces (una vez al mes)";
                        break;
                    case 903:
                        results['consume_alcohol'] = "Con frecuencia (una vez por semana)";
                        break;
                    case 904:
                        results['consume_alcohol'] = "Siempre (casi todos los días)";
                        break;
                }
                switch (results["consume_marihuana"]) {
                    case 902:
                        results["consume_marihuana"] = "A veces (una vez al mes)";
                        break;
                    case 903:
                        results["consume_marihuana"] = "Con frecuencia (una vez por semana)";
                        break;
                    case 904:
                        results["consume_marihuana"] = "Siempre (casi todos los días)";
                        break;
                }
                switch (results["otras_drogas"]) {
                    case 902:
                        results["otras_drogas"] = "A veces (una vez al mes)";
                        break;
                    case 903:
                        results["otras_drogas"] = "Con frecuencia (una vez por semana)";
                        break;
                    case 904:
                        results["otras_drogas"] = "Siempre (casi todos los días)";
                        break;
                }
                switch (results["fuma_tabaco"]) {
                    case 902:
                        results["fuma_tabaco"] = "A veces (una vez al mes)";
                        break;
                    case 903:
                        results["fuma_tabaco"] = "Con frecuencia (una vez por semana)";
                        break;
                    case 904:
                        results["fuma_tabaco"] = "Siempre (casi todos los días)";
                        break;
                }*/
                $data[] = $results;
                //$lenght = count($data)
            $returnData = msg("Success", $data);
        }
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
        $stmt = Flight::db()->prepare("SELECT * FROM tipos_respuestas WHERE code IN ('TRES3','TRES49','TRES50','TRES51')");
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


        }
        else{
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
        fecha_nacimiento, celular, contacto 
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
            $contacto = $select_data["contacto"];
        } else {
            $error_msg = msg_error("Error: ", "No se encuetra usuario con el DNI ingresado", 0);
            Flight::json($error_msg);
            exit;
        }


        $select_id_users = Flight::db()->prepare("SELECT pacientes.id id
        FROM pacientes 
        WHERE dni = '" . $dni . "'");

        $select_id_users->execute();


        if ($select_id_users->rowCount() > 0) {
            $id_users = $select_id_users->fetch();
            $id_users = $id_users["id"];
        } else {
            $error_msg = msg_error("Error: ", "No se encuetra usuario con el DNI ingresado", 0);
            Flight::json($error_msg);
            exit;
        }



        $select_data_clinica = Flight::db()->prepare("SELECT presion_alta,presion_baja ,pulso, peso, circunferencia_cintura, consume_alcohol,
        consume_marihuana, otras_drogas, fuma_tabaco 
        FROM datos_clinicos 
        WHERE rela_paciente = '" . $id_users . "' AND estado_clinico = 1");

        $select_data_clinica->execute();
    
        if ($select_data_clinica->rowCount() > 0) {
            $select_data_clinica = $select_data_clinica->fetch();

            $presion_alta = $select_data_clinica["presion_alta"];
            $presion_baja = $select_data_clinica["presion_baja"];
            $pulso = $select_data_clinica["pulso"];
            $peso = $select_data_clinica["peso"];
            $circunferencia_cintura = $select_data_clinica["circunferencia_cintura"];
            switch ($select_data_clinica["consume_alcohol"]) {
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
                "contacto" => $contacto,
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
                "contacto" => $contacto,
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

function read_deptos_generos()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $tipo = verificar($data_input, "tipo");

    try {
        if ($tipo == 2) {
            $stmt = Flight::db()->prepare("SELECT id, nombre FROM generos");
            $stmt->execute();
            $result = $stmt->fetchAll();
        } elseif ($tipo == 1) {
            $stmt = Flight::db()->prepare("SELECT id, nombre FROM departamentos");
            $stmt->execute();
            $result = $stmt->fetchAll();
        }

        $data = array();
        if ($stmt->rowCount() > 0) {
            foreach ($result as $results) {
                $data[] = $results;
            }

            $returnData = msg("Success", $data);
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

    if ($criterio == 1) {
        $sql_consulta = "SELECT *
        FROM avisos_departamentos 
        JOIN departamentos ON departamentos.id = avisos_departamentos.rela_departamento
        WHERE avisos_departamentos.rela_aviso = '" . $id_aviso . "'";
    } else {
        $sql_consulta = "SELECT *
        FROM avisos_generos
        JOIN generos ON generos.id = avisos_generos.rela_genero
        WHERE avisos_generos.rela_aviso = '" . $id_aviso . "'";
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
    $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '" . $id_users . "'");
    $select_id_paciente->execute();


    if ($select_id_paciente->rowCount() > 0) {
        $id_paciente = $select_id_paciente->fetch();
        $id_paciente = $id_paciente["id"];
    } else {
        $error_msg = msg_error("Error: ", "No se encuntra el paciente", 0);
        Flight::json($error_msg);
        exit;
    }

    try {

        $stmt = Flight::db()->prepare("SELECT id,descripcion,fecha_limite,rela_estado_recordatorio,rela_paciente FROM recordatorios_pacientes
    WHERE rela_estado_recordatorio <> 2 AND rela_paciente = '" . $id_paciente . "'
        UNION ALL
        SELECT id,descripcion,fecha_limite,rela_estado_recordatorio,rela_paciente FROM recordatorios_medicos
        WHERE rela_estado_recordatorio <> 2 AND rela_paciente = '" . $id_paciente . "' ORDER BY fecha_limite ASC");

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

function chequeos_medico_paciente()
{

    $data_input = json_decode(file_get_contents("php://input"), true);

    $email = verificar($data_input, "email");
    $id_paciente = verificar($data_input, "id_paciente");

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


    // SELECCION DE ID DEL MEDICO A PARTIR DEL ID DEL LOGIN
    $select_id_medico = Flight::db()->prepare("SELECT id FROM medicos WHERE rela_users = '" . $id_users . "'");
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


    // SELECCION DE ID DEL MEDICO A PARTIR DEL ID DEL LOGIN
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
        JOIN tipo_screening on recordatorios_medicos.rela_screening = tipo_screening.id 
        JOIN estado_recordatorio ON recordatorios_medicos.rela_estado_recordatorio = estado_recordatorio.id
        JOIN resultados_screenings ON recordatorios_medicos.rela_respuesta_screening = resultados_screenings.id
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

    $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '".$email."'");
    $select_id_users->execute();
    $id_users= $select_id_users->fetch();
    $id_users= $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '".$id_users."'");
    $select_id_paciente->execute();
    $id_paciente= $select_id_paciente->fetch();
    $id_paciente= $id_paciente["id"];  


    // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
    $select_antecedentes = Flight::db()->prepare("SELECT rela_evento,nombre_evento FROM antecedentes_medicos_personales 
    JOIN eventos ON antecedentes_medicos_personales.rela_evento = eventos.id
    WHERE antecedentes_medicos_personales.rela_tipo = 1 AND rela_paciente = '".$id_paciente."'");
    $select_antecedentes->execute();
    
    $lista = array();
    try {
        if ($select_antecedentes->rowCount() > 0) {
            $antecedente= $select_antecedentes->fetchAll();
            
            foreach ($antecedente as $antecedentes) {
                $lista[] = $antecedentes;
            }
            //echo json_encode($lista);
            $returnData = msg("Success", $lista);
            //$returnData = $lista;
        }
        else{
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

    $select_id_users = Flight::db()->prepare("SELECT id FROM `users` WHERE users.email = '".$email."'");
    $select_id_users->execute();
    $id_users= $select_id_users->fetch();
    $id_users= $id_users["id"];


    // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
    $select_id_paciente = Flight::db()->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '".$id_users."'");
    $select_id_paciente->execute();
    $id_paciente= $select_id_paciente->fetch();
    $id_paciente= $id_paciente["id"];  


    // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_familiares
    $select_antecedentes = Flight::db()->prepare("SELECT rela_evento,nombre_evento FROM antecedentes_medicos_familiares 
    JOIN eventos ON antecedentes_medicos_familiares.rela_evento = eventos.id
    WHERE antecedentes_medicos_familiares.rela_tipo = 1 AND rela_paciente = '".$id_paciente."'");
    $select_antecedentes->execute();
    
    $lista = array();
    try {
        if ($select_antecedentes->rowCount() > 0) {
            $antecedente= $select_antecedentes->fetchAll();
            
            foreach ($antecedente as $antecedentes) {
                $lista[] = $antecedentes;
            }
            //echo json_encode($lista);
            $returnData = msg("Success", $lista);
            //$returnData = $lista;
        }
        else{
            //echo json_encode("Vacio");
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
