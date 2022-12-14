<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="https://getbootstrap.com/docs/4.0/assets/img/favicons/favicon.ico">
    <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>

    <title>Signin Template for Bootstrap</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/sign-in/">

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/signin.css" rel="stylesheet">
  </head>

  <body class="text-center">
    <form class="form-signin" name="person" method="POST">
      <img class="mb-4" src="https://getbootstrap.com/docs/4.0/assets/brand/bootstrap-solid.svg" alt="" width="72" height="72">
      <h1 class="h3 mb-3 font-weight-normal">S +65</h1>
      <label for="inputEmail" class="sr-only">Email</label>
      <input type="email" id="email" class="form-control" placeholder="Email address" required autofocus>
      <label for="inputPassword" class="sr-only">Contraseña</label>
      <input type="password" id="password" class="form-control" placeholder="Password" required>
      <div class="checkbox mb-3">
        <label>
          <input type="checkbox" value="remember-me"> Remember me
        </label>
      </div>
      <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="login()">Iniciar Sesión</button>
      <p class="mt-5 mb-3 text-muted">&copy; 2022</p>
    </form>
    
    <div id='error'>
        
    </div>

  </body>

  <script>
	function login()
    {

      var parametros = 
      {
        "email" : document.getElementById("email").value,
        "password" : document.getElementById("password").value,
      };

      $.ajax({
        data: parametros,
        url: 'php/user_login.php',
        type: 'POST',
        dataType:"JSON",
    
        success: function(response)
        {        
            if(response['request']=='Success'){   
                window.location.replace("pages/index.php");
            }else{
                console.log(response['request']);
                $('#error').html(mensaje);
            }
        }
      });
}


</script>

</html>