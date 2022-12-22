<!doctype html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <link rel="icon" type="image/x-icon" href="assets/logo1.png" />
  <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  <link href="../css/styles.css" rel="stylesheet" />
  <title>Login</title>


</head>

<body class="text-center">
  <div class="container">
    <div class="row">
      <div class="col-sm">
        <form class="" name="person" method="POST">
          <img src="assets/logo1.png" alt="" width="500" height="300">
          <div class="row justify-content-md-center">
            <div class="col-6">
              <input type="email" id="email" class="form-control" placeholder="Email" required autofocus>
              </br>
              <input type="password" id="password" class="form-control" placeholder="Contraseña" required>
              </br>
            </div>
          </div>
          <div id='mensaje'>
        </div>
          <a class="btn btn-primary active" role="button" onclick="login()">Iniciar Sesión</a>
        </form>

      </div>
    </div>
  </div>
</body>

<script>
  function login() {

    var parametros = {
      "email": document.getElementById("email").value,
      "password": document.getElementById("password").value,
    };

    console.log(document.getElementById("password").value);

    $.ajax({
      data: parametros,
      url: 'php/user_login.php',
      type: 'POST',
      dataType: "JSON",

      success: function(response) {
        console.log(response);
        if (response['request'] == 'Success') {
          window.location.replace("pages/inicio.php");
        } else {
          mensaje.innerHTML = `<p style="color:red;">Usuario o Pass Incorrecto</p>`;

        }
      }
    });
  }
</script>

</html>