<?php 
include (__DIR__."/env.php");

$rutaRaiz = Env::$_URL_API;

session_start();
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pacientes Buscador</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <!-- <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">

    <!-- overlayScrollbars -->
    <link rel="stylesheet" href="plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <!-- FIXES style -->
  <link rel="stylesheet" href="dist/css/fixes.css">
</head>

<body class="hold-transition sidebar-mini layout-fixed" onload="chequeos_pacientes()">
    <div class="wrapper">
        <?php include('./templates/navbar_template.php'); ?>

        <?php include('./templates/sidebar_template.php'); ?>
        <!-- Page content-->
        <div class="content-wrapper">
            <!-- Content Header (Page header) -->
            <?php
            $titulo = "Chequeos";
            //include('./templates/content_header.php');
            ?>

            <!-- Main content -->
            <section class="content">

            <button id="nuevo_paciente" type="submit" class="btn-primary btn-sm" onclick="$('#nuevoPacienteModal').modal('show')"><i class="fa fa-plus" aria-hidden="true"></i></button>

            
                <!-- Stack the columns on mobile by making one full-width and the other half-width -->
                <div class="row" style="margin: 100; color: rgb(92, 90, 90);">
                    <div class="container-fluid">

                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th scope="col"></th>
                                    <th scope="col">Tipo de Chequeo</th>
                                    <th scope="col">Fecha de Envío</th>
                                    <th scope="col">Fecha Límite</th>
                                    <th scope="col">Paciente</th>
                                    <th scope="col">Estado</th>
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
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="modal1.innerHTML = ``">Enviar</button>
                    <!--<a href="datos.html" class="btn btn-primary active" role="button" aria-pressed="true">Aceptar</a> -->
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Nuevo Paciente-->
<div class="modal fade" id="nuevoPacienteModal" tabindex="-1" role="dialog" aria-labelledby="nuevoPacienteModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Nueva Solicitud <abbr title="Envia una solicitud al paciente"><i class="fa-sharp fa-solid fa-circle-info"></i></abbr></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="modal_nuevo_anuncio" class="modal-body">
        <div id="formulario">
        <form action="" method="post">
          <div class="form-group">
          <label for="dni-text" class="col-form-label">Dni:</label>
          <input class="form-control" id="dni_paciente" type="number" value="">
          </div>
          <div class="form-group">
            <label for="descripcion-text" class="col-form-label">Mensaje(Opcional):</label>
            <textarea class="form-control" id="mensaje_paciente"></textarea>
          </div>
        </form>
        </div>
        <div id="mensajeResultado"></div>
      </div>
      <div class="modal-footer">
        <button id="button_enviar" type="button" class="btn btn-primary" onclick="envio_solicitud()">Enviar</button>
        <button id="button_ok" data-dismiss="modal" type="button" class="btn btn-primary" style="display: none;">Entendido</button>

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

            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            $.ajax({
                data: JSON.stringify(parametros),
                url: rootRaiz + '/deptos_generos_patologias',
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

        function ver_mas(id) {

            $('#avisoModal').modal('show'); // abrir

            var parametros = {
                id: id,
            };

            $.ajax({
                data: JSON.stringify(parametros),
                url: '/read_aviso.php',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {

                        modal1.innerHTML += `
                        <p> Descripcion: ` + response['aviso']['descripcion'] + ` </p>
                        <p> Fecha Creación: ` + response['aviso']['fecha_creacion'] + ` </p>
                        <p> Fecha Límite: ` + response['aviso']['fecha_limite'] + ` </p>
                        `;

                    } else {
                        console.log(response['status']);
                    }


                }
            });
        }


        function read_recordatorio() {

            const tabla = document.querySelector('#tabla');

            var url_imagen = "";

            var parametros = {};

            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            $.ajax({
                data: JSON.stringify(parametros),
                url: rootRaiz + '/recordatorios_medicos',
                type: 'POST',
                dataType: "JSON",

                success: function(response) {

                    if (response['status'] == 'Success') {

                        response['data'].forEach(element => {
                            tabla.innerHTML += `
                <tr>
                <th scope="row"></th>
                <td>${element['descripcion'].slice(0,30)}</td>
                <td>${element['fecha_limite']}</td>
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

        function chequeos_pacientes(email) {

            var estado;
            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            var settings = {
                "url": rootRaiz + "/chequeos_medico",
                "method": "POST",
                "data": JSON.stringify({
                    "id_medico": "<?php echo $_SESSION['id_medico']; ?>"
                }),
            };

            $.ajax(settings).done(function(response) {
                if (response['status'] == "Success") {
                    response['data'].forEach(element => {
                        console.log(element['nombre']);
                        if (element['nombre_estado'] == "Respondido") {
                            estado = '';
                        } else {
                            if (element['nombre_estado'] == "Enviado") {
                                estado = 'disabled';
                            }
                        }
                        tabla.innerHTML += `<tr>
          <th scope="row"></th>
          <td>${element['nombre']}</td>
          <td>${element['fecha_creacion']}</td>
          <td>${element['fecha_limite']}</td>
          <td>${element['apellido_paciente']} ${element['nombre_paciente']}</td>
          <td>${element['nombre_estado']}</td>
          <td><button class="btn btn-sm btn-primary ${estado} " onclick="ver_mas_chequeo('${element['id']}','${element['nombre']}','${element['resultado']}')"><i class="fa-solid fa-file-lines"></i></button>
          </td>
          </tr>
          `;
                    });

                } else {
                    if (response['status'] == "Vacio") {
                        $("#nombre").html('No hay datos personales registrados');
                    }
                }
            });

        }

        function ver_mas_chequeo(id_chequeo, nombre_estado, resultado) {
      if (nombre_estado == "Enviado") {
        console.log(nombre_estado);

      } else {
        if (nombre_estado = "Respondido") {
          console.log(nombre_estado);
          $('#modal_resultado_chequeo').modal('show'); // abrir
          modal_resultado.innerHTML = `
    <p style="color:red;">${resultado}</p>`;

        }
      }
    }
    </script>

</body>

<!-- Modal Ver Resultado Chequeo-->
<div class="modal fade" id="modal_resultado_chequeo" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="titulo_modal" align="center">Resultado del Chequeo</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="modal_resultado" class="modal-body">

      </div>


    </div>
  </div>
</div>

</html>