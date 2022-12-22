<?php

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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <link href="../css/styles.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
    

</head>

<body onload="read_avisos()">
    <div class="d-flex" id="wrapper">
        <?php include('navbar_template.php'); ?>
        <!-- Page content-->
        <div class="container">
            <!-- Stack the columns on mobile by making one full-width and the other half-width -->
            <div class="row" style="margin: 100;">
                <div class="p-5">
                    <h2>Chequeos</h2>
</br>
                    <h3>Seleccionar tipo de chequeo</h3>
                    <select class="form-select" aria-label="Default select example">
  <option selected>Síntomas físicos, motores y sensoriales
</option>
  <option value="1">Cuestionario de Quejas Cognitivas</option>
  <option value="2">Ánimo</option>
  <option value="3">Conductual</option>
  <option value="2">Actividades de la vida diaria</option>
  <option value="3">Riesgo Nutricional</option>
  <option value="2">Diabetes</option>
  <option value="3">Enfermedades Crónica</option>
</select>
<!-- Date Picker -->
</br>
<div class="form-group mb-4">
          <div class="datepicker date input-group">
            <input type="text" placeholder="Elegir Fecha" class="form-control" id="fecha1">
            <div class="input-group-append">
              <span class="input-group-text"><i class="fa fa-calendar"></i></span>
            </div>
          </div>
        </div>
    </div>
    <div class="container" style="margin: 30px;">
                    <div class="row">
                        <div class="col-sm">
                        <button type="button" class="btn btn-primary text-uppercase" data-toggle="modal" data-target="#modalMedico">Enviar</button>
                    </div>
                </div>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>

</body>
<script>
$(function () {
  $('.datepicker').datepicker({
    language: "es",
    autoclose: true,
    format: "dd/mm/yyyy"
  });
});
</script>
</html>