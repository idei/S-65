<?php
    require "db.php";
    
    $nombre = $_POST['nombre'];
    $apellido = $_POST['apellido'];
    $email = $_POST['email'];
    $dni = $_POST['dni'];
    $fecha_nacimiento = $_POST['fecha_nacimiento'];
    $rela_genero=$_POST['rela_genero'];
    $rela_departamento = $_POST['rela_departamento'];
	$rela_nivel_instruccion = $_POST['rela_nivel_instruccion'];
    $rela_grupo_conviviente = $_POST['rela_grupo_conviviente'];
    $celular = $_POST['celular'];
    $contacto = $_POST['contacto'];
    $estado_users =$_POST['estado_users'];
    $rela_users=$_POST['rela_users'];
    
        try {            
                $select_email = $db->prepare("SELECT id FROM users WHERE email = '".$email."'");
                $select_email->execute();
                $rela_users= $select_email->fetch();
                $rela_users= $rela_users["id"];


                /*$insert_email = $db->prepare("UPDATE users
                SET email=:email
                WHERE id=:rela_users");

                $insert_email->execute([$email,$rela_users]);
                */


                
                $insert_paciente = $db->prepare("UPDATE pacientes
                SET nombre=:nombre, 
                apellido=:apellido,
                dni=:dni, 
                fecha_nacimiento=:fecha_nacimiento, 
                rela_genero=:rela_genero,
                rela_nivel_instruccion=:rela_nivel_instruccion,
                rela_grupo_conviviente=:rela_grupo_conviviente,
                celular=:celular, 
                contacto=:contacto,
                rela_departamento=:rela_departamento,
                estado_users=:estado_users
                WHERE rela_users=:rela_users");
                

                $insert_paciente->execute([$nombre,$apellido,$dni,$fecha_nacimiento,$rela_genero,$rela_nivel_instruccion,$rela_grupo_conviviente,$celular,$contacto,$rela_departamento,$estado_users,$rela_users]);
                
                echo json_encode("Success");
                

            }
           catch(PDOException $e) {
            echo json_encode('Error conectando con la base de datos: ' . $e->getMessage());
          
    }
    
?>