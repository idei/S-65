<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sistema de Salud</title>

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
  <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
  <!-- Bootstrap 5 CSS (última versión) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="hold-transition login-page">
  <div class="login-box">
    <!-- /.login-logo -->
    <div class="card card-outline card-primary">
      <div class="card-header text-center">
        <img src="dist/img/logo.png" class="img-fluid" alt="Responsive image">
      </div>
      <div class="card-body">
        <p class="login-box-msg">Acceso para Médicos</p>

        <!-- Agregado un div para mostrar mensajes de error -->
        <div id="mensaje"></div>

        <form action="../index3.html" method="post">
          <div class="input-group mb-3">
            <input id="email" type="email" class="form-control" placeholder="Correo Electrónico" autocomplete="username">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-envelope"></span>
              </div>
            </div>
          </div>
          <div class="input-group mb-3">
            <input id="password" type="password" class="form-control" placeholder="Contraseña" autocomplete="current-password">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-lock"></span>
              </div>
              <div class="input-group-text">
                <!-- Agrega un botón de alternancia -->
                <span id="togglePassword" class="fas fa-eye" onclick="togglePassword()"></span>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-6">
              <div class="icheck-primary">
                <input type="checkbox" id="remember">
                <label for="remember">
                  Recordarme
                </label>
              </div>
            </div>
            <!-- /.col -->
            <div class="col-6">
              <!-- Cambiado el tipo de botón a "button" y llamando a la función login() al hacer clic -->
              <button type="button" class="btn btn-primary btn-block" onclick="login()">Iniciar Sesión</button>
            </div>
            <!-- /.col -->
          </div>
        </form>

        <p class="mb-1">
          <a href="forgot-password.html">Olvidé mi contraseña</a>
        </p>
        <p class="mb-0">
          <a href="register.php" class="text-center">Registrarme</a>
        </p>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
  </div>
  <!-- /.login-box -->

  <!-- Modal de Bootstrap para mostrar mensajes de error -->
  <div class="modal fade" id="errorModal" tabindex="-1" role="dialog" aria-labelledby="errorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="errorModalLabel">Error de inicio de sesión</h5>
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

  <!-- Bootstrap 5 JS (última versión) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <script>
    function login() {
  console.log("Inicio de sesión iniciado");

  // Limpiar el mensaje de error antes de realizar la nueva solicitud
  document.getElementById("errorModalBody").innerHTML = '';

  var parametros = {
    "email": document.getElementById("email").value,
    "password": document.getElementById("password").value,
  };

  $.ajax({
    data: parametros,
    url: 'session.php',
    type: 'POST',
    dataType: "text",  // Cambiado a "text" para evitar la conversión automática a JSON
    success: function(response) {
      console.log("Respuesta del servidor:", response);

      // Intenta analizar la respuesta como JSON
      try {
        var json = JSON.parse(response);
        // Procede con el manejo del JSON
        if (json['status'] == 'Success') {
          console.log("Inicio de sesión exitoso");
          window.location.replace("home.php");
        } else {
          console.log("Error en el inicio de sesión");
          // Mostrar mensaje de error en el modal
          $('#errorModalBody').html(`<p style="color:red;">Usuario o Contraseña Incorrecta</p>`);
          $('#errorModal').modal('show');
        }
      } catch (e) {
        console.error("Error al analizar la respuesta JSON:", e);
      }
    },
    error: function(xhr, textStatus, errorThrown) {
      console.error("Error en la solicitud AJAX:", errorThrown);
    }
  });
}

  </script>

<script>
  function togglePassword() {
    var passwordInput = document.getElementById("password");
    var toggleIcon = document.getElementById("togglePassword");

    // Cambio de tipo de entrada del campo de contraseña
    if (passwordInput.type === "password") {
      passwordInput.type = "text";
      // Cambio el icono a un ojo cerrado
      toggleIcon.className = "fas fa-eye-slash";
    } else {
      passwordInput.type = "password";
      // Cambio el icono a un ojo abierto
      toggleIcon.className = "fas fa-eye";
    }
  }
</script>


  
</body>

</html>
