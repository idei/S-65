<?php session_start();
if (isset($_POST['id_paciente'])) {
  $id_paciente = $_POST["id_paciente"];
  }
  $id_medico = $_SESSION["id_medico"];

?>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>S-65 | Médico</title>

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

<body class="hold-transition sidebar-mini layout-fixed" onload="read_nombre_chequeos()">
  <div class="wrapper">

    <?php include('./templates/navbar_template.php'); ?>

    <?php include('./templates/sidebar_template.php'); ?>

    <div class="content-wrapper">

      <!-- Content Header (Page header) -->

      <?php
      $titulo = "";
      include('./templates/content_header.php');
      ?>

      <!-- Main content -->
      <section class="content">
        <!-- <div class="d-flex" id="wrapper"> -->
        <!-- Page content-->


        <div class="card card-primary">
          <div class="card-header">
            <h3 class="card-title">Nuevo Chequeo</h3>
          </div>
          <!-- /.card-header -->
          <!-- form start -->
          <form>
            <div class="card-body">
              <div class="form-group">
                <label>Chequeos</label>
                <select id="select_chequeos" class="form-control" aria-label="Default select example">

                </select>
              </div>
              <div class="form-group mb-4">
                <div class="form-group">
                  <label for="">Elegir Fecha</label>
                  <input type="date" placeholder="Elegir Fecha" class="form-control" id="fecha1">

                </div>
              </div>


            </div>
            <!-- /.card-body -->

            <div class="card-footer">
              <button type="submit" onclick="guardar_chequeo()" class="btn btn-primary">Enviar Chequeo</button>
            </div>
          </form>
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

  </script>
  <!-- jQuery -->
  <script src="plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- overlayScrollbars -->
  <script src="plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
  <!-- AdminLTE App -->
  <script src="dist/js/adminlte.min.js"></script>
</body>

<!-- Modal -->
<div class="modal fade" id="modal_chequeo" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="titulo_modal" align="center"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <div class="modal-footer">
        <a href="datos.php" class="btn btn-primary active" role="button" aria-pressed="true">Ok</a>
      </div>
    </div>
  </div>
</div>
</div>

<script>
  function read_nombre_chequeos() {
    var parametros = {};

    $.ajax({
      data: JSON.stringify(parametros),
      url: 'http://localhost/S-65/api/v1/chequeos',
      type: 'POST',
      dataType: "JSON",

      success: function(response) {

        if (response['status'] == 'Success') {
          var response = response['data'];

          response['chequeos'][0].forEach(element => {
            select_chequeos.innerHTML += `
              <option value="${element["id"]}">${element["nombre"]}</option>
              `;
          });

        } else {
          modal_body.innerHTML = `<p style="color:red;">No se encuentra el paciente</p>`;
        }

      }
    });

  }

  function guardar_chequeo() {
    console.log(document.getElementById("select_chequeos").value);
    console.log(document.getElementById("fecha1").value);

    var parametros = {
      id_chequeo: document.getElementById("select_chequeos").value,
      fecha_chequeo: document.getElementById("fecha1").value,
      rela_paciente: "<?php echo $id_paciente; ?>",
      rela_medico: "<?php echo $id_medico; ?>"
    };

    $.ajax({
      data: JSON.stringify(parametros),
      url: '../php/create_chequeo.php',
      type: 'POST',
      dataType: "JSON",

      success: function(response) {

        if (response['request'] == 'Success') {

          $('#modal_chequeo').modal('show'); // abrir

          titulo_modal.innerHTML = `Chequeo creado correctamente`;

        } else {
          titulo_modal.innerHTML = `<p style="color:red;">No se encuentra el paciente</p>`;
          //$("#mensaje").html("");
        }


      }
    });


  }
</script>

</html>