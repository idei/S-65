<?php
include(__DIR__ . "/env.php");

$rutaRaiz = Env::$_URL_API;

?>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>S+65 - Registro de Profesionales</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/adminlte.min.css">
  <!-- FIXES style -->
  <link rel="stylesheet" href="dist/css/fixes.css">

    <!-- jQuery -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">

<script src="plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="dist/js/adminlte.min.js"></script>

</head>

<body class="hold-transition register-page">
  <div class="register-box">
    <div class="card card-outline card-primary">
      <div class="card-header text-center">
        <a href="../index.php" class="h1"><img src="dist/img/logo.png" class="img-fluid" alt="Responsive image"></a>
      </div>
      <div class="card-body">
        <p class="login-box-msg">Registrar Nuevo Médico</p>

        <form action="" method="post">
          <div class="input-group mb-3">
            <input id="last_name" type="text" class="form-control" placeholder="Apellido">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-user"></span>
              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="name" type="text" class="form-control" placeholder="Nombre">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-user"></span>
              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="email" type="email" class="form-control" placeholder="Correo Electrónico">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-envelope"></span>
              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="dni" type="text" class="form-control" placeholder="Dni">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-address-card "></span>

              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="matricula" type="text" class="form-control" placeholder="Matricula">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-address-card "></span>

              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="especialidad" type="text" class="form-control" placeholder="Especialidad">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-user-nurse"></span>
              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="password" type="password" class="form-control" placeholder="Contraseña">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-lock"></span>
              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="password_retype" type="password" class="form-control" placeholder="Repetir Contraseña">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-lock "></span>
              </div>
            </div>
          </div>
          <div class="row">
         
            <div class="col-4">
              <button type="button" class="btn btn-primary btn-block" onclick="register_medico()">Registrar</button>
              <!-- <button type="button" class="btn btn-primary btn-block" onclick="login()">Iniciar Sesión</button> -->
            </div>
            <!-- /.col -->
          </div>
        </form>

        <a href="index.php" class="text-center">Ya tengo una cuenta de doctor</a>
      </div>
      <!-- /.form-box -->
    </div><!-- /.card -->
  </div>
  <!-- /.register-box -->

  <!-- Modal de Bootstrap para mostrar mensajes de error -->
  <div class="modal fade" id="errorModal" tabindex="-1" role="dialog" aria-labelledby="errorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="errorModalLabel">Mensaje</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body" id="errorModalBody">
          <!-- Contenido del mensaje de error -->
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>

  <script>
    function register_medico() {
      var rootRaiz = "<?php echo $rutaRaiz; ?>";

      document.getElementById("errorModalBody").innerHTML = '';

      var settings = {
          "apellido": document.getElementById("last_name").value,
          "nombre": document.getElementById("name").value,
          "email": document.getElementById("email").value,
          "password": document.getElementById("password").value,
          "dni": document.getElementById("dni").value,
          "matricula": document.getElementById("matricula").value,
          "especialidad": document.getElementById("especialidad").value
      };

      $.ajax({
        data: JSON.stringify(settings),
        url: rootRaiz + "/medico_register",
        type: 'POST',
        dataType: "JSON",

        success: function(response) {
          console.log(response);
          if (response['status'] == "Success") {

            mostrarModalExito();

          }
          else{
            $('#errorModalBody').html(`<p style="color:red;">Error: ${response['data']}</p>`);
            $('#errorModal').modal('show');
          }
        }
      });

    }

    function mostrarModalExito() {
    // Muestra el modal de éxito
    $('#errorModalBody').html(`<p style="color:green;">Registro Exitoso. Será redirigido para iniciar sesión</p>`);
    $('#errorModal').modal('show');

    // Cuenta regresiva de 5 segundos
    var segundos = 5;
    var cuentaRegresiva = setInterval(function () {
      // Actualiza el contenido del botón "Cerrar" con la cuenta regresiva
      $('#errorModal .modal-footer .btn-secondary').text('Cerrar (' + segundos + 's)');

      // Disminuye el contador
      segundos--;

      // Si el contador llega a cero, detén la cuenta regresiva y redirecciona
      if (segundos < 0) {
        clearInterval(cuentaRegresiva);
        // Cierra el modal
        $('#errorModal').modal('hide');
        // Redirecciona a login.php
        window.location.href = 'index.php';
      }
    }, 1000);
  }

  </script>

</body>

</html>