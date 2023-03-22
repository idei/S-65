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

        <form action="../index3.html" method="post">
          <div class="input-group mb-3">
            <input id="email" type="email" class="form-control" placeholder="Correo Electrónico">
            <div class="input-group-append">
              <div class="input-group-text">
                <span class="fas fa-envelope"></span>
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
              <a type="submit" class="btn btn-primary btn-block" onclick="login()">Iniciar Sesión</a>
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

  <script>
    function login() {
      
      var parametros = {
        "email": document.getElementById("email").value,
        "password": document.getElementById("password").value,
      };

      $.ajax({
        data: parametros,
        url: 'session.php',
        type: 'POST',
        dataType: "JSON",

        success: function(response) {
          if (response['status'] == 'Success') {
            
            window.location.replace("home.php");
            
          } else {
            mensaje.innerHTML = `<p style="color:red;">Usuario o Contraseña Incorrecta</p>`;

          }
        }
      });
    }
  </script>

  <!-- jQuery -->
  <script src="plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- AdminLTE App -->
  <script src="dist/js/adminlte.min.js"></script>
</body>

</html>