<?php 
include (__DIR__."/env.php");

$rutaRaiz = Env::$_URL_API;

session_start(); 
$id_medico = $_SESSION["id_medico"];

?>
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
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
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
            //include('./templates/content_header.php');
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
                                    <th scope="col"></th>
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
                    <h5 class="modal-title" id="exampleModalLongTitle">Nuevo Aviso Grupal <abbr title="Envia un aviso grupal a los pacientes de distintos departamentos, sexo o edad para cumplir con indicaciones en una determinada fecha."><i class="fa-sharp fa-solid fa-circle-info"></i></abbr></h5>
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
                                <option value="5">Patologías</option>
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
    <script src="dist/js/alert-msg.js"></script>


    <script>
        var arreglo_opcion_select = [];
        var check_genero = "";

        function checkear(id) {

            var check = document.getElementById(id);

            if (check.checked) {
                console.log("si");
                arreglo_opcion_select.push(id);
            } else {
                arreglo_opcion_select = arreglo_opcion_select.filter((item) => item !== id)
                console.log("no");

            }
            console.log(arreglo_opcion_select);
        }

        function checkear_genero(id) {

            var check = document.getElementById(id);
            check_genero = id;

        }

        function return_options_selected() {
            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            var option_value = document.getElementById("select_tipo").value;

            var parametros = {
                tipo: document.getElementById("select_tipo").value,
            };


            $.ajax({
                data: JSON.stringify(parametros),
                url: rootRaiz + '/deptos_generos_patologias',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {
                console.log(response);
                    if (response['status'] == 'Success' && option_value == 2) {
                        options_selected.innerHTML = ``;

                        response['data'].forEach(element => {
                            options_selected.innerHTML += `<div class="form-check">
                            <input class="form-check-input" type="radio" name="exampleRadios" id="${element["id"]}" value="${element["id"]}" onclick="checkear_genero(${element["id"]})" checked>
                            <label class="form-check-label" for="exampleRadios1">
                                ${element["nombre"]}
                            </label>
                            </div>`;
                        });

                    }

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

                    if (response['status'] == 'Success' && option_value == 5) {
                        options_selected.innerHTML = ``;
                        response['data'].forEach(element => {
                            options_selected.innerHTML += `<div class="form-check">
                    <input class="form-check-input" type="checkbox" name="eventos" value="${element["id"]}" id="${element["id"]}" onclick="checkear(${element["id"]})" ">
                    <label class="form-check-label" for="defaultCheck1">
                    ${element["nombre_evento"]}
                    </label>
                    </div>
                   `;
                        });
                    }

                }
            });
        }

        function nuevo_anuncio_grupal() {

            var rootRaiz = "<?php echo $rutaRaiz; ?>";
            
            var parametros = {
                criterio: document.getElementById("select_tipo").value,
                descripcion: document.getElementById("descripcion_anuncio_grupal").value,
                fecha_limite: document.getElementById("fecha_limite").value,
                id_medico: <?php echo $id_medico; ?>,
                arreglo_opcion_select: arreglo_opcion_select,
                opcion_check: check_genero.toString()
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: rootRaiz + '/create_avisos',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {
                        tabla.innerHTML = ``;
                        read_avisos();
                        showalert("Aviso enviados","alert-primary");


                    } else {
                        alert_danger("Error");
                        showalert("Error","alert-danger");
                        console.log(response['status']);
                    }


                }
            });
        }

        function ver_mas(id_aviso) {

            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            $('#avisoModal').modal('show'); // abrir

            modal1.innerHTML = ``;

            var parametros = {
                id: id_aviso,
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: rootRaiz + '/aviso',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {
                        console.log(response);
                        var response = response['data'];

                        modal1.innerHTML += `
                        <p><b> Descripcion: </b>` + response['descripcion'] + ` </p>
                        <p><b> Fecha Creación: </b>` + response['fecha_creacion'] + `</p>
                        <p><b> Fecha Límite: </b>` + response['fecha_limite'] + `</p>
                        <p><b> Criterio del aviso enviado:</b></p>
                        <ul class="list-group">
                        `;
                        avisos_criterios(response['id'], response['aviso_criterio']);
                        modal1.innerHTML += `</ul>`;

                    } else {
                        console.log(response['status']);
                    }


                }
            });
        }


        function read_avisos() {

            const tabla = document.querySelector('#tabla');

            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            var url_imagen = "";


            var parametros = {
                email: "<?php echo $_SESSION['email']; ?>",
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: rootRaiz + '/avisos',
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
                            }
                            if (element['aviso_criterio'] == 2) {
                                criterio = "Géneros"
                            }
                            if (element['aviso_criterio'] == 5) {
                                criterio = "Patologias"
                            }
                            if (element['aviso_criterio'] == 4) {
                                criterio = "Personal"
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
            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            var settings = {
                "url": rootRaiz + "/avisos_criterios",
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
                            modal1.innerHTML +=`
                    <li class="list-group-item">
                    <div class="d-inline-flex align-items-center justify-content-center text-white m-1 me-2" style="background-color: green; width: 26px; height: 26px;">
                            <i class="fas fa-check-square fa-lg"></i>
                        </div>
                    ${element['nombre']}
                    </li>`
                             ;
                        });
                    }  

                    if (criterio == 2) {
                        response.forEach(element => {
                            modal1.innerHTML += `<li class="list-group-item">
                    <div class="d-inline-flex align-items-center justify-content-center text-white m-1 me-2" style="background-color: green; width: 26px; height: 26px;">
                            <i class="fas fa-check-square fa-lg"></i>
                        </div>
                    ${element['nombre']}
                    </li>`;
                        });
                    }

                    if (criterio == 5) {
                        response.forEach(element => {
                            modal1.innerHTML += `<li class="list-group-item">
                    <div class="d-inline-flex align-items-center justify-content-center text-white m-1 me-2" style="background-color: green; width: 26px; height: 26px;">
                            <i class="fas fa-check-square fa-lg"></i>
                        </div>
                    ${element['nombre_evento']}
                    </li>`;
                        });
                    }

                    if (criterio == 4) {
                            modal1.innerHTML += `<li class="list-group-item">
                    <div class="d-inline-flex align-items-center justify-content-center text-white m-1 me-2" style="background-color: green; width: 26px; height: 26px;">
                            <i class="fas fa-check-square fa-lg"></i>
                        </div>
                    ${response['nombre']}
                    </li>`;

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