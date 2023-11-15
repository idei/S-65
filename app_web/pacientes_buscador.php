<?php
include(__DIR__ . "/env.php");

$rutaRaiz = Env::$_URL_API;

session_start();
$id_medico = $_SESSION["id_medico"];

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
                <div id="mensaje">
              </div>

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
        
        $('#nuevoPacienteModal').on('show.bs.modal', function() {
            // Blanquea los campos del formulario
            $('#dni_paciente').val('');
            $('#mensaje_paciente').val('');
            // Oculta el mensaje de resultado si estaba visible
            $('#mensajeResultado').hide();
        });

        function envio_solicitud() {

            var mensaje = document.getElementById("mensaje_paciente").value;

            if (mensaje.trim() === "") {
                mensaje = " ";
            }

            var rootRaiz = "<?php echo $rutaRaiz; ?>";

            var settings = {
                "url": rootRaiz + "/solicitud_medico_paciente",
                "method": "POST",
                "data": JSON.stringify({
                    "dni_paciente": document.getElementById("dni_paciente").value,
                    "mensaje_paciente": mensaje,
                    "id_medico": "<?php echo $id_medico; ?>",

                }),
            };
            console.log("<?php echo $id_medico; ?>");

            $.ajax(settings).done(function(response) {

                console.log(response);

                var mensajeResultado = document.getElementById("mensajeResultado");

                if (response['status'] == "Success") {
                    document.getElementById('button_ok').style.display = 'block';
                    document.getElementById('button_enviar').style.display = 'none';
                    document.getElementById('mensajeResultado').style.display = 'block';

                    mensajeResultado.innerHTML = '<div class="alert alert-success">Solicitud enviada correctamente</div>';

                    document.getElementById('formulario').style.display = 'none';

                } else {
                    if (response['status'] == "Vacio") {

                        //document.getElementById('button_ok').style.display = 'block';
                        //document.getElementById('button_enviar').style.display = 'none';
                        document.getElementById('mensajeResultado').style.display = 'block';

                        mensajeResultado.innerHTML = '<div class="alert alert-danger">No se pudo encontrar el paciente</div>';
                    }

                    if (response['status'] == "Error") {
                        document.getElementById('button_ok').style.display = 'block';
                        document.getElementById('button_enviar').style.display = 'none';

                        mensajeResultado.innerHTML = '<div class="alert alert-danger">Error!</div>';

                    }
                }
            });

        }
    </script>

</body>
    
</html>