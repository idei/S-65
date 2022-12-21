<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Datos</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="../assets/logo1.png" />
        <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
        <link href="../css/styles.css" rel="stylesheet" />
        <link href="../css/styleP.css" rel="stylesheet" />

    </head>
    <body onload="buscar()" >
        <div class="d-flex" id="wrapper">
                <?php include('navbar_template.php'); ?>
                <h4>Datos de Paciente</h4>
                <div id="nombre"></div>
                <div id="dni"></div>
                <div id="contacto"></div>
                <div id="depto"></div>
                <h4>Datos Clínicos</h4>
                <p>Fecha:</p>
                <p>Presión Alta:</p>
                <p>Pulso:</p>
                <p>Circunferencia de la cintura</p>
                <p>Fuma:</p>
                <p>Consume Marihuana:</p>
                <button type="button" class="btn btn-outline-primary">Ver más</button>
                <h4>Antecedentes Médicos</h4>
                <h4>Antecedentes Familiares</h4>
                <div class="container">
                    <div class="row">
                        <div class="col-sm">
                        <button type="button" class="btn btn-primary text-uppercase">Enviar un Aviso personal</button>
                        <button type="button" class="btn btn-primary text-uppercase">Enviar un chequeo</button>
</div>
</div>
                </div>
                
        </div>
        <script>
	function buscar()
    {
      var settings = {
      "url": "http://localhost/s-65/app_web/php/user_read_datos_personales.php",
      "method": "POST",
      "data": JSON.stringify({
      "dni": 141414,
      }),
      };

$.ajax(settings).done(function (response) {
  var nombre= "Nombre y Apellido: " +response['nombre'] + " " + response['apellido']
  var dni = "DNI: " + response['dni']
  var contacto = "Contacto: " + response['contacto']
  var depto = "Departamento: "+ response['departamento']
  $("#nombre").html(nombre);
  $('#dni').html(dni)
  $('#contacto').html(contacto);
  $('#depto').html(depto)
});

      var settings2 = {
      "url": "../php/datos_clinicos",
      "method": "POST",
      "data": JSON.stringify({
      "dni": 141414,
      }),
      };

$.ajax(settings2).done(function (response) {
    console.log(response)
});
}

</script>
<script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    </body>
</html>