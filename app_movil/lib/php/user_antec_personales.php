<?php
    require "db.php";
    
    $email = $_POST['email'];

    if ($_POST['retraso'] == "true") {
        $retraso = 1;
    }
    else{
        $retraso = 0;
    }

    if ($_POST['desorden'] == "true") {
        $desorden = 1;
    }
    else{
        $desorden = 0;
    }

    if ($_POST['deficit'] == "true") {
        $deficit = 1;
    }
    else{
        $deficit = 0;
    }

    if ($_POST['lesiones_cabeza'] == "true") {
        $lesiones_cabeza = 1;
    }
    else{
        $lesiones_cabeza = 0;
    }
    
    if ($_POST['perdidas'] == "true") {
        $perdidas = 1;
    }
    else{
        $perdidas = 0;
    }


    if ($_POST['accidentes_caidas'] == "true") {
        $accidentes_caidas = 1;
    }
    else{
        $accidentes_caidas = 0;
    }

    if ($_POST['lesiones_espalda'] == "true") {
        $lesiones_espalda = 1;
    }
    else{
        $lesiones_espalda = 0;
    }
    
    if ($_POST['infecciones'] == "true") {
        $infecciones = 1;
    }
    else{
        $infecciones = 0;
    }
    
    if ($_POST['toxinas'] == "true") {
        $toxinas = 1;
    }
    else{
        $toxinas = 0;
    }

    if ($_POST['acv'] == "true") {
        $acv = 1;
    }
    else{
        $acv = 0;
    }

    if ($_POST['demencia'] == "true") {
        $demencia = 1;
    }
    else{
        $demencia = 0;
    }


    if ($_POST['parkinson'] == "true") {
        $parkinson = 1;
    }
    else{
        $parkinson = 0;
    }

    if ($_POST['epilepsia'] == "true") {
        $epilepsia = 1;
    }
    else{
        $epilepsia = 0;
    }
    
    if ($_POST['esclerosis'] == "true") {
        $esclerosis = 1;
    }
    else{
        $esclerosis = 0;
    }
    
    if ($_POST['huntington'] == "true") {
        $huntington = 1;
    }
    else{
        $huntington = 0;
    }

    if ($_POST['depresion'] == "true") {
        $depresion = 1;
    }
    else{
        $depresion = 0;
    }

    if ($_POST['trastorno'] == "true") {
        $trastorno = 1;
    }
    else{
        $trastorno = 0;
    }
    
    if ($_POST['esquizofrenia'] == "true") {
        $esquizofrenia = 1;
    }
    else{
        $esquizofrenia = 0;
    }

    if ($_POST['enfermedad_desorden'] == "true") {
        $enfermedad_desorden = 1;
    }
    else{
        $enfermedad_desorden = 0;
    }
   
    if ($_POST['intoxicaciones'] == "true") {
        $intoxicaciones = 1;
    }
    else{
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
                //$select_id_paciente = $db->prepare("SELECT pacientes.id FROM `pacientes` INNER JOIN users ON pacientes.rela_users = users.id WHERE users.email = '".$email."'");
                //$select_id_paciente->execute();
                //$id_paciente= $select_id_paciente->fetch();
                //$id_paciente= $id_paciente["pacientes.id"];
                
                // SELECCION DE ID USER A PARTIR DE LA CLAVE PRINCIPAL EMAIL

                $select_id_users = $db->prepare("SELECT id FROM `users` WHERE users.email = '".$email."'");
                $select_id_users->execute();
                $id_users= $select_id_users->fetch();
                $id_users= $id_users["id"];


                // SELECCION DE ID DEL PACIENTE A PARTIR DEL ID DEL LOGIN
                $select_id_paciente = $db->prepare("SELECT id FROM `pacientes` WHERE pacientes.rela_users = '".$id_users."'");
                $select_id_paciente->execute();
                $id_paciente= $select_id_paciente->fetch();
                $id_paciente= $id_paciente["id"];
                

                // SELECCION DE EVENTOS
                $select_evento = $db->prepare("SELECT id,nombre_evento,codigo_evento FROM `eventos`");
                $select_evento->execute();
                $evento= $select_evento->fetchAll();


                // BUSCO SI EXISTEN FILAS DE ESE USUARIO/ID EN LA TABLA antecedentes_medicos_personales
                $select_id_paciente = $db->prepare("SELECT rela_paciente FROM antecedentes_medicos_personales WHERE rela_paciente = '".$id_paciente."'");
                $select_id_paciente->execute();
                
                // SI EXISTEN ENTONCES BORRO LAS FILAS COORESPONDIENTES A ESE USUARIO Y PROCEDO A CREAR NUEVOS REGISTROS
                if ($select_id_paciente->rowCount() > 0) {

                        $delete_antecedentes = $db->prepare("DELETE from antecedentes_medicos_personales
                        WHERE rela_paciente = '".$id_paciente."'");
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
                pdoMultiInsert('antecedentes_medicos_personales', $rowsToInsert, $db);

                
                echo json_encode("Success");
                
            }
           catch(PDOException $e) {
            echo json_encode('Error conectando con la base de datos: ' . $e->getMessage());
          
    }
    
    function pdoMultiInsert($tableName, $data, $pdoObject){
    
        //Will contain SQL snippets.
        $rowsSQL = array();
     
        //Will contain the values that we need to bind.
        $toBind = array();
        
        //Get a list of column names to use in the SQL statement.
        $columnNames = array_keys($data[0]);
     
        //Loop through our $data array.
        foreach($data as $arrayIndex => $row){
            $params = array();
            foreach($row as $columnName => $columnValue){
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
        foreach($toBind as $param => $val){
            $pdoStatement->bindValue($param, $val);
        }
        
        //Execute our statement (i.e. insert the data).
        return $pdoStatement->execute();
    }
?>