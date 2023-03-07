<?php 
session_start();
include (__DIR__."/env.php");
echo Env::$_URL_API;
?>

<!DOCTYPE html>
<html lang="en">

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

<body class="hold-transition sidebar-mini layout-fixed" onload="read_pacientes()">

  <!-- Site wrapper -->
  <div class="wrapper">

    <?php include('./templates/navbar_template.php'); ?>

    <?php include('./templates/sidebar_template.php'); ?>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">

      <?php
      $titulo = "Mis Pacientes";
      //include('./templates/content_header.php');
      ?>

      <!-- Main content -->
      <section class="content">
        <!-- <div class="d-flex" id="wrapper"> -->
        <!-- Page content-->
        <div class="container-fluid">
          <!-- Stack the columns on mobile by making one full-width and the other half-width -->

          <div class="card-tools">
            <div class="card-header">
              <form method="POST">
                <input id="buscar" type="search" class="form-control rounded" placeholder="Dni / Apellido / Nombre" onkeyup="doSearch()" />
              </form>
              <div id="mensaje">
              </div>

            </div>
            <!-- /.card-header -->
            <div class="card-body table-responsive p-0" style="height: 600px;">
              <table class="table table-head-fixed text-nowrap">
                <thead>

                  <tr>
                    <th scope="col"></th>
                    <th>Dni</th>
                    <th>Apellido</th>
                    <th>Nombre</th>
                    <th scope="col"></th>
                  </tr>
                </thead>
                <tbody id="tabla">

                </tbody>
              </table>
            </div>
            <!-- /.card-body -->
          </div>


        </div>
        <!-- </div> -->

      </section>
      <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <?php include('./templates/footer_template.php'); ?>


    <!-- Control Sidebar -->
    <aside class="control-sidebar control-sidebar-dark">
      <!-- Control sidebar content goes here -->
    </aside>
    <!-- /.control-sidebar -->
  </div>
  <!-- ./wrapper -->

  <script>
    function read_pacientes() {

      const tabla = document.querySelector('#tabla');

      var url_imagen = "";

      var parametros = {
        dni: "<?php echo $_SESSION['dni']; ?>"
      };

      $.ajax({
        data: JSON.stringify(parametros),
        url: 'http://localhost/S-65/api/v1/pacientes', 
        type: 'POST',
        dataType: "JSON",

        success: function(response) {
          console.log(response);
          if (response['status'] == 'Success') {

            response['data'].forEach(element => {

              tabla.innerHTML += `
              <tr>
              <th scope="row"></th>
              <td>${element['dni']}</td>
              <td>${element['apellido']}</td>
              <td>${element['nombre']}</td>
              <td>
              <form action="paciente.php" method="post">
              <input name="id_paciente" type="hidden" value="${element['id']}">
              <button id="ver_mas" type="submit" class="btn-primary btn-sm" ><i class="fa fa-chevron-right" aria-hidden="true"></i></button>
              </form>
              </td>
              </tr>
              `;
            });
          } else {
            console.log(response['status']);
            if (response['status'] == 'Vacio') {
              tabla.innerHTML += ``;
            }
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
        url: '../php/read_aviso.php',
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

    function doSearch() {

      const tableReg = document.getElementById('tabla');

      const searchText = document.getElementById('buscar').value.toLowerCase();

      let total = 0;

      // Recorremos todas las filas con contenido de la tabla

      for (let i = 1; i < tableReg.rows.length; i++) {

        // Si el td tiene la clase "noSearch" no se busca en su cntenido

        if (tableReg.rows[i].classList.contains("noSearch")) {

          continue;

        }


        let found = false;

        const cellsOfRow = tableReg.rows[i].getElementsByTagName('td');

        // Recorremos todas las celdas

        for (let j = 0; j < cellsOfRow.length && !found; j++) {

          const compareWith = cellsOfRow[j].innerHTML.toLowerCase();

          // Buscamos el texto en el contenido de la celda

          if (searchText.length == 0 || compareWith.indexOf(searchText) > -1) {

            found = true;

            total++;

          }

        }

        if (found) {

          tableReg.rows[i].style.display = '';

        } else {

          // si no ha encontrado ninguna coincidencia, esconde la

          // fila de la tabla

          tableReg.rows[i].style.display = 'none';

        }

      }

      // mostramos las coincidencias

      const lastTR = tableReg.rows[tableReg.rows.length - 1];

      const td = lastTR.querySelector("td");

      lastTR.classList.remove("hide", "red");

      if (searchText == "") {

        lastTR.classList.add("hide");

      } else if (total) {

        td.innerHTML = "Se ha encontrado " + total + " coincidencia" + ((total > 1) ? "s" : "");

      } else {

        lastTR.classList.add("red");

        td.innerHTML = "No se han encontrado coincidencias";

      }

    }
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

</html>