<?php
    require "db.php";
    
    $pulso = $_POST['pulso'];
    $presion_alta = $_POST['presion_alta'];
    $presion_baja = $_POST['presion_baja'];
    $circunfer_cintura = $_POST['circunfer_cintura'];
    $peso_corporal = $_POST['peso_corporal'];
    $talla = $_POST['talla'];
    $id_alcohol = $_POST['id_alcohol'];
    $id_tabaco = $_POST['id_tabaco'];
    $id_marihuana = $_POST['id_marihuana'];
    $id_otras = $_POST['id_otras'];
    $id_paciente = $_POST['id_paciente'];


    $lista = array();
    
        try {

                $estado_clinico = 1;
                $consult_estado = $db->prepare("SELECT estado_clinico FROM datos_clinicos WHERE estado_clinico = '".$estado_clinico."' AND rela_paciente = '".$id_paciente."'");
                $consult_estado->execute();
                
                $consult_estado = $consult_estado->rowCount();
               

                if ($consult_estado > 0) {

                    $estado_clinico = 0;
                    $estado_clinico1 = 1;

                    $update_datos_clinicos= $db->prepare("UPDATE datos_clinicos
                    SET estado_clinico=?
                    WHERE rela_paciente=? AND estado_clinico=?");
                    $update_datos_clinicos->execute([$estado_clinico,$id_paciente,$estado_clinico1]);


                    $estado_clinico = 1;
                    $insert_dato_clinico = $db->prepare('INSERT INTO datos_clinicos(rela_paciente,presion_alta,presion_baja,pulso,peso,
                    circunferencia_cintura,talla,consume_alcohol,consume_marihuana,otras_drogas,fuma_tabaco,estado_clinico)VALUES(?,?,?,?,?,?,?,?,?,?,?,?)');
                    $insert_dato_clinico->bindParam(1,$id_paciente);
                    $insert_dato_clinico->bindParam(2,$presion_alta);
                    $insert_dato_clinico->bindParam(3,$presion_baja);
                    $insert_dato_clinico->bindParam(4,$pulso);
                    $insert_dato_clinico->bindParam(5,$peso_corporal);
                    $insert_dato_clinico->bindParam(6,$circunfer_cintura); 
                    $insert_dato_clinico->bindParam(7,$talla);
                    $insert_dato_clinico->bindParam(8,$id_alcohol);
                    $insert_dato_clinico->bindParam(9,$id_marihuana);
                    $insert_dato_clinico->bindParam(10,$id_otras);
                    $insert_dato_clinico->bindParam(11,$id_tabaco);
                    $insert_dato_clinico->bindParam(12,$estado_clinico);
                    $insert_dato_clinico->execute();

                    $insert_dato_clinico = $insert_dato_clinico->rowCount();
                if ($insert_dato_clinico) {
                    //array_push($lista, "Success", 'estado_users');
                    
                    $lista = array(
                        "estado_users" => "Success"
                    );

                    echo json_encode($lista);
                }
                
                }else {

                    $estado_clinico = 1;
                    $insert_dato_clinico = $db->prepare('INSERT INTO datos_clinicos(id_paciente,presion_alta,presion_baja,pulso,peso,
                    circunferencia_cintura,talla,consume_alcohol,consume_marihuana,otras_drogas,fuma_tabaco,estado_clinico)VALUES(?,?,?,?,?,?,?,?,?,?,?,?)');
                    $insert_dato_clinico->bindParam(1,$id_paciente);
                    $insert_dato_clinico->bindParam(2,$presion_alta);
                    $insert_dato_clinico->bindParam(3,$presion_baja);
                    $insert_dato_clinico->bindParam(4,$pulso);
                    $insert_dato_clinico->bindParam(5,$peso_corporal);
                    $insert_dato_clinico->bindParam(6,$circunfer_cintura); 
                    $insert_dato_clinico->bindParam(7,$talla);
                    $insert_dato_clinico->bindParam(8,$id_alcohol);
                    $insert_dato_clinico->bindParam(9,$id_marihuana);
                    $insert_dato_clinico->bindParam(10,$id_otras);
                    $insert_dato_clinico->bindParam(11,$id_tabaco);
                    $insert_dato_clinico->bindParam(12,$estado_clinico);
                    $insert_dato_clinico->execute();
                
                $insert_dato_clinico = $insert_dato_clinico->rowCount();
                if ($insert_dato_clinico) {
                    //array_push($lista, "Success", 'estado_users');

                    $lista = array(
                        "estado_users" => "Success"
                    );

                    echo json_encode($lista);
                }

                }

            }
           catch(PDOException $e) {
            $error = "Error conectando con la base de datos: ".$e->getMessage();  
            $lista = array(
                "estado_users" =>  $error
            ); 
            echo json_encode($lista);
          
    }
    
    ?>