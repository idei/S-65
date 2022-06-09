<?php
    require "db.php";

    $email = $_POST['email'];

    $select_data = $db->prepare("SELECT rela_users, rela_nivel_instruccion,
    rela_grupo_conviviente, rela_departamento, rela_genero, nombre, apellido, dni, 
    fecha_nacimiento, celular, contacto 
    FROM pacientes 
    INNER JOIN users ON pacientes.rela_users = users.id
    WHERE users.email = '".$email."'");

    $select_data->execute();
    $select_data= $select_data->fetch();

    $rela_users= $select_data["rela_users"];
    $rela_nivel_instruccion= $select_data["rela_nivel_instruccion"];
    $rela_grupo_conviviente= $select_data["rela_grupo_conviviente"];
    $rela_departamento= $select_data["rela_departamento"];
    $rela_genero= $select_data["rela_genero"];
    $nombre= $select_data["nombre"];
    $apellido= $select_data["apellido"];
    $dni= $select_data["dni"];
    $fecha_nacimiento= $select_data["fecha_nacimiento"];
    $celular= $select_data["celular"];
    $contacto= $select_data["contacto"];

   
    $lista = array(
        "estado_users" => "Success",
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
        "email" => $email,
    );

    echo json_encode($lista);
    //
?>