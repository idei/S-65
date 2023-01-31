<?php session_start(); ?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Avisos</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <!-- <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">

    <!-- overlayScrollbars -->
    <link rel="stylesheet" href="plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
</head>

<body class="hold-transition sidebar-mini layout-fixed" onload="read_avisos()">
    <div class="wrapper">

        <?php include('./templates/navbar_template.php'); ?>

        <?php include('./templates/sidebar_template.php'); ?>

        <div class="content-wrapper">
            <!-- Content Header (Page header) -->
            <?php
            $titulo = "Avisos";
            include('./templates/content_header.php');
            ?>

            <!-- Main content -->
            <section class="content">

                <!-- Stack the columns on mobile by making one full-width and the other half-width -->
                <div class="row" style="margin: 100; color: rgb(92, 90, 90);">
                    <div class="container-fluid">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-3">
                                    <button class="btn btn-danger float-left" onclick="$('#nuevoAvisoGrupalModal').modal('show')"><i class="fa fa-users" aria-hidden="true"></i> Crear Aviso Grupal</button>
                                </div>
                                <div class="col-9">
                                </div>

                            </div>
                        </div>
                        <br></br>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th scope="col"></th>
                                    <th scope="col">Descripción</th>
                                    <th scope="col">Fecha de Creación</th>
                                    <th scope="col">Fecha Límite</th>
                                    <th scope="col">Criterio</th>
                                    <th scope="col">Acción</th>
                                </tr>
                            </thead>
                            <tbody id="tabla">

                            </tbody>
                        </table>
                    </div>
                </div>

            </section>
            <!-- /.content -->

        </div>
        <!-- Control Sidebar -->
        <aside class="control-sidebar control-sidebar-dark">
            <!-- Control sidebar content goes here -->
        </aside>
        <!-- /.control-sidebar -->
    </div>

    <?php include('./templates/footer_template.php'); ?>


    <!-- Modal -->
    <div class="modal fade" id="avisoModal" tabindex="-1" role="dialog" aria-labelledby="avisoModalTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Aviso</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div id="modal1" class="modal-body">

                </div>
                <div class="modal-footer">
                    <!--<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="modal1.innerHTML = ``">Enviar</button>-->
                    <!--<a href="datos.html" class="btn btn-primary active" role="button" aria-pressed="true">Aceptar</a> -->
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Nuevo Anuncio Grupal-->
    <div class="modal fade" id="nuevoAvisoGrupalModal" tabindex="-1" role="dialog" aria-labelledby="nuevoAvisoGrupalModalTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Nuevo Aviso Grupal</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div id="modal_nuevo_anuncio_grupal" class="modal-body">
                    <form action="" method="post">
                        <div class="form-group">
                            <label for="descripcion-text" class="col-form-label">Descripción:</label>
                            <textarea class="form-control" id="descripcion_anuncio_grupal"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="descripcion-text" class="col-form-label">Seleccionar tipo:</label>
                            <select name="select_tipo" id="select_tipo" onchange="return_options_selected()">
                                <option selected value="1">Departamento</option>
                                <option value="2">Género</option>
                            </select>
                        </div>
                        <br>
                        <div id="options_selected"></div>
                        <br>
                        <div class="form-group">
                            <label for="fecha-text" class="col-form-label">Fecha Límite:</label>
                            <input type="date" name="" id="fecha_limite">
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="nuevo_anuncio_grupal()">Enviar Aviso</button>
                    <!--<a href="datos.html" class="btn btn-primary active" role="button" aria-pressed="true">Aceptar</a> -->
                </div>
            </div>
        </div>
    </div>


    <!-- Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">¿Estas seguro de eliminar este aviso?</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                </div>
                <div class="modal-footer d-flex justify-content-center">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
                    <button type="button" class="btn btn-danger">Si</button>
                </div>
            </div>
        </div>
    </div>


    <!-- jQuery -->
    <script src="plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- overlayScrollbars -->
    <script src="plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/adminlte.min.js"></script>
    <script src="../js/alerts_msg.js"></script>


    <script>
        var arreglo_departamentos = [];
        var check_genero = "";

        function checkear(id) {

            var check = document.getElementById(id);

            if (check.checked) {
                console.log("si");
                arreglo_departamentos.push(id);
            } else {
                arreglo_departamentos = arreglo_departamentos.filter((item) => item !== id)
                console.log("no");

            }
            console.log(arreglo_departamentos);
        }

        function checkear_genero(id) {

            var check = document.getElementById(id);
            check_genero = id;

        }

        function return_options_selected() {

            var option_value = document.getElementById("select_tipo").value;

            var parametros = {
                tipo: document.getElementById("select_tipo").value,
            };

            console.log(document.getElementById("select_tipo").value);

            $.ajax({
                data: JSON.stringify(parametros),
                url: 'http://localhost/S-65/api/v1/deptos_generos',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success' && option_value == 2) {
                        options_selected.innerHTML = ``;

                        response['data'].forEach(element => {
                            options_selected.innerHTML += `<div class="form-check">
                    <input class="form-check-input" type="radio" name="exampleRadios" id="${element["id"]}" value="${element["id"]}" onclick="checkear_genero(${element["id"]})" checked>
                    <label class="form-check-label" for="exampleRadios1">
                        ${element["nombre"]}
                    </label>
                    </div>                    
                        `;
                        });

                    } else
                    if (response['status'] == 'Success' && option_value == 1) {
                        options_selected.innerHTML = ``;

                        response['data'].forEach(element => {
                            options_selected.innerHTML += `<div class="form-check">
                    <input class="form-check-input" type="checkbox" name="prueba" value="${element["id"]}" id="${element["id"]}" onclick="checkear(${element["id"]})" ">
                    <label class="form-check-label" for="defaultCheck1">
                    ${element["nombre"]}
                    </label>
                    </div>
                   `;
                        });
                    }

                }
            });
        }


        function nuevo_anuncio() {

            var parametros = {
                descripcion: document.getElementById("descripcion_anuncio_individual").value,
                fecha_limite: document.getElementById("fecha_limite").value,
                email_medico: 'doc@gmail.com',
                email_paciente: 'prueba@gmail.com'
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: '../php/create_aviso.php',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {
                        tabla.innerHTML = ``;
                        read_avisos();
                        alert_success("Aviso creado");

                    } else {
                        alert_danger("Error");
                        console.log(response['status']);
                    }


                }
            });
        }

        function nuevo_anuncio_grupal() {

            var parametros = {
                descripcion: document.getElementById("descripcion_anuncio_grupal").value,
                fecha_limite: document.getElementById("fecha_limite").value,
                email_medico: 'doc@gmail.com',
                arreglo: arreglo_departamentos,
                genero: check_genero
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: '../php/create_aviso_grupal.php',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {
                        tabla.innerHTML = ``;
                        read_avisos();
                        alert_success("Avisos enviados");

                    } else {
                        alert_danger("Error");
                        console.log(response['status']);
                    }


                }
            });
        }

        function ver_mas(id_aviso) {

            $('#avisoModal').modal('show'); // abrir

            modal1.innerHTML = ``;

            var parametros = {
                id: id_aviso,
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: 'http://localhost/S-65/api/v1/aviso',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {
                        var response = response['data'];

                        modal1.innerHTML += `
                        <p> Descripcion: ` + response['descripcion'] + ` </p>
                        <p> Fecha Creación: ` + response['fecha_creacion'] + ` </p>
                        <p> Fecha Límite: ` + response['fecha_limite'] + ` </p>
                        <p><b>Criterio del aviso enviado:</b></p>
                        `;
                        avisos_criterios(response['id'], response['aviso_criterio']);

                    } else {
                        console.log(response['status']);
                    }


                }
            });
        }


        function read_avisos() {

            const tabla = document.querySelector('#tabla');

            var url_imagen = "";


            var parametros = {
                email: "doc@gmail.com",
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: 'http://localhost/S-65/api/v1/avisos',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {

                        response['data'].forEach(element => {
                            if (element['url_imagen'] == null || element['url_imagen'] == "") {
                                url_imagen = "Sin Imagen"
                            } else {
                                url_imagen = element['url_imagen'];
                            }

                            if (element['aviso_criterio'] == 1) {
                                criterio = "Departamentos"
                            } else {
                                criterio = "Género";
                            }

                            tabla.innerHTML += `
                <tr>
                <th scope="row"></th>
                <td>${element['descripcion'].slice(0,30)}</td>
                <td>${element['fecha_creacion']}</td>
                <td>${element['fecha_limite']}</td>
                <td>${criterio}</td>
                <td><button onclick="ver_mas('${element['id']}')" id="ver_mas" type="button" class="btn-primary btn-sm" ><i class="fa-solid fa-file-lines"></i></button>
                <button type="button" class="btn-danger btn-sm" data-toggle="modal" data-target="#exampleModal"><i class="fa-solid fa-trash"></i></button>
                </td>
                </tr>
                `;
                        });
                    } else {
                        console.log(response['status']);
                    }

                }
            });
        }

        function avisos_criterios(id_aviso, criterio) {
            console.log(id_aviso);
            var settings = {
                "url": "http://localhost/S-65/api/v1/avisos_criterios",
                "method": "POST",
                "data": JSON.stringify({
                    "id_aviso": id_aviso,
                    "criterio": criterio,
                }),
            };
            $.ajax(settings).done(function(response) {
                if (response['status'] == "Success") {
                    var response = response['data'];

                    if (criterio == 1) {
                        response.forEach(element => {
                            modal1.innerHTML += `<p >${element['nombre']}</p>`;
                        });
                    } else {
                        response.forEach(element => {
                            modal1.innerHTML += `<p >${element['nombre']}</p>`;
                        });
                    }


                } else {
                    if (response['status'] == "Vacio") {
                        console.log("Sin Datos")
                        $("#retraso").html('Sin Datos');
                    }
                }

            });
        }
    </script>

</body>

</html>