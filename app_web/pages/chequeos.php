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

<body onload="read_nombre_chequeos()">
  <div class="d-flex" id="wrapper">
    <?php include('navbar_template.php'); ?>
    <!-- Page content-->
    <div class="container">
      <!-- Stack the columns on mobile by making one full-width and the other half-width -->
      <div class="row" style="margin: 100; color: rgb(92, 90, 90);">
        <div class="p-5">
          <h2>Chequeos</h2>
          </br>
          <h3>Seleccionar tipo de chequeo</h3>
          <select id="select_chequeos" class="form-select" aria-label="Default select example">
          </select>
          <!-- Date Picker -->
          </br>
          <div class="form-group mb-4">
            <div class="form-group">
              <input type="date" placeholder="Elegir Fecha" class="form-control" id="fecha1">
             
            </div>
          </div>
        </div>
        <div class="container" style="margin: 30px;">
          <div class="row">
            <div class="col-sm">
              <button type="button" onclick="guardar_chequeo()" class="btn btn-primary text-uppercase" data-toggle="modal" data-target="#modalMedico">Enviar</button>
            </div>
          </div>
          <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>

          <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
          <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>

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
    var parametros = {
    };

    $.ajax({
      data: JSON.stringify(parametros),
      url: 'http://localhost/S-65/api/v1/chequeos.php',
      type: 'POST',
      dataType: "JSON",

      success: function(response) {

        if (response['request'] == 'Success') {
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
      rela_paciente: 22,
      rela_medico: 1
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