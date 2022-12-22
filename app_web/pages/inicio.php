<?php
//session_start();
$email = "doc@gmail.com";
?>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <meta name="description" content="" />
  <meta name="author" content="" />
  <title>Home</title>
  <!-- Favicon-->
  <link rel="icon" type="image/x-icon" href="../assets/logo1.png" />
  <!-- Core theme CSS (includes Bootstrap)-->
  <!-- CSS only -->
  <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  <link href="../css/styles.css" rel="stylesheet" />
</head>

<body>
  <div class="d-flex" id="wrapper">
    <?php include('navbar_template.php'); ?>
    <!-- Page content-->
    <div class="container col-md-8">
      <!-- Stack the columns on mobile by making one full-width and the other half-width -->
      <div class="row" style="margin: 100; color: rgb(92, 90, 90);">
        <div class="p-5">
          <h2>Buscador de pacientes</h2>
          <div class="row">
            <div class="p-2">
              <form method="POST">
                <input id="dni" type="search" class="form-control rounded" placeholder="Escribir DNI de paciente" aria-label="Search" aria-describedby="search-addon" />
            </div>
            <div id="mensaje"></div>
            <div class="p-2">
              <button onclick="buscar()" type="button" class="btn btn-primary p-2" >Buscar</button>
            </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="modal_paciente" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="titulo_modal">Paciente buscado</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <div id="nombre" class=""> </div>
            </br>
            <div id="apellido"></div>
          </div>
          <div class="modal-footer">
            <button onclick="mensaje.innerHTML = ``;" type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <a href="datos.php" class="btn btn-primary active" role="button" aria-pressed="true">Ver Datos</a>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script>
    function buscar() {

      var parametros = {
        dni: document.getElementById("dni").value
      };

      $.ajax({
        data: JSON.stringify(parametros),
        url: '../php/buscar_paciente.php',
        type: 'POST',
        dataType: "JSON",

        success: function(response) {

          if (response['request'] == 'Success') {

            $('#modal_paciente').modal('show'); // abrir

            var nombre = "Nombre: " + response["paciente"]['nombre']
            var apellido = "Apellido: " + response["paciente"]['apellido']
            $("#nombre").html(nombre);
            $("#apellido").html(apellido);
            // window.location.replace("datos.php");
          } else {
            mensaje.innerHTML = `<p style="color:red;">No se encuentra el paciente</p>`;
            //$("#mensaje").html("");
          }


        }
      });


    }
  </script>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
</body>

</html>